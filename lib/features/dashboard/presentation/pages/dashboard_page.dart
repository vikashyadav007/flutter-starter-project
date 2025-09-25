import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/dashboard/presentation/providers/dashboard_analytics_provider.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';
import 'package:fuel_pro_360/shared/widgets/dashboard_cards.dart';
import 'package:fuel_pro_360/shared/widgets/date_filter_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/title_header.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/dashboard/data/utils/dashboard_utils.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  DateFilterOption selectedPeriod = DateFilterOption.monthtodate;
  DateRange? customDateRange;

  @override
  void initState() {
    super.initState();
    // Load initial dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedFuelPump = ref.read(selectedFuelPumpProvider);
      print(
          'Dashboard initState: Current selected fuel pump: ${selectedFuelPump?.id}');
      // Always fetch dashboard data - the data source will return mock data if no fuel pump is selected
      _fetchDashboardData();
    });
  }

  void _fetchDashboardData() {
    final dateRange = _getDateRange(selectedPeriod, customDateRange);
    final startDateFormatted = DashboardUtils.formatDate(dateRange.startDate);
    final endDateFormatted = DashboardUtils.formatDate(dateRange.endDate);
    print(
        'Dashboard: Fetching data for date range: $startDateFormatted to $endDateFormatted');
    ref.read(dashboardAnalyticsProvider.notifier).loadDashboardData(
          startDateFormatted,
          endDateFormatted,
        );
  }

  ({DateTime startDate, DateTime endDate}) _getDateRange(
      DateFilterOption period, DateRange? customRange) {
    final today = DateTime.now();

    switch (period) {
      case DateFilterOption.today:
        return (startDate: today, endDate: today);
      case DateFilterOption.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return (startDate: yesterday, endDate: yesterday);
      case DateFilterOption.last7days:
        return (
          startDate: today.subtract(const Duration(days: 6)),
          endDate: today
        );
      case DateFilterOption.monthtodate:
        return (
          startDate: DateTime(today.year, today.month, 1),
          endDate: today
        );
      case DateFilterOption.custom:
        if (customRange?.from != null) {
          return (
            startDate: customRange!.from!,
            endDate: customRange.to ?? customRange.from!
          );
        }
        return (startDate: today, endDate: today);
    }
  }

  void _handleDateFilterChange(DateFilterOption option, DateRange? dateRange) {
    setState(() {
      selectedPeriod = option;
      if (option == DateFilterOption.custom && dateRange != null) {
        customDateRange = dateRange;
      }
    });
    _fetchDashboardData();
  }

  String _formatCurrency(double amount) {
    return '${Currency.rupee}${getCommaSeperatedNumberDouble(number: amount)}';
  }

  String _formatVolume(double volume) {
    return '${getCommaSeperatedNumberDouble(number: volume)}L';
  }

  double _parseCurrencyAmount(String amount) {
    // Remove currency symbol and commas, then parse
    final cleanAmount =
        amount.replaceAll(Currency.rupee, '').replaceAll(',', '').trim();
    return double.tryParse(cleanAmount) ?? 0.0;
  }

  double _parseVolumeAmount(String volume) {
    // Remove 'L' and commas, then parse
    final cleanVolume = volume.replaceAll('L', '').replaceAll(',', '').trim();
    return double.tryParse(cleanVolume) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardAnalyticsProvider);
    final selectedFuelPump = ref.watch(selectedFuelPumpProvider);

    // Debug logging to see the current state
    print(
        'Dashboard: Current selectedFuelPump: ${selectedFuelPump?.id} (${selectedFuelPump?.name})');
    print('Dashboard: Current dashboardState: ${dashboardState.runtimeType}');

    // Listen to selected fuel pump changes and refresh dashboard data
    ref.listen<FuelPumpEntity?>(selectedFuelPumpProvider, (previous, next) {
      print(
          'Dashboard: Selected fuel pump changed from ${previous?.id} to ${next?.id}');
      // Always fetch data when fuel pump changes, including when it gets selected for the first time
      _fetchDashboardData();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TitleHeader(
                title: 'Dashboard',
                onBackPressed: () {},
                showLogoutButton: true,
              ),
              const SizedBox(height: 20),

              // Date Filter
              DateFilterDropdown(
                value: selectedPeriod,
                onChange: _handleDateFilterChange,
                customDateRange: customDateRange,
              ),
              const SizedBox(height: 20),

              // Dashboard Content
              Expanded(
                child: dashboardState.when(
                  initial: () {
                    print('Dashboard: State is initial');
                    return const Center(
                      child: Text(
                        'Welcome to Dashboard Analytics',
                        style: TextStyle(
                          fontSize: 16,
                          color: UiColors.gray,
                        ),
                      ),
                    );
                  },
                  loading: () {
                    print('Dashboard: State is loading');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading dashboard...',
                            style: TextStyle(
                              color: UiColors.gray,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loaded: (salesData, fuelVolumeData, metrics,
                      recentTransactions, todaysSummary, fuelLevels) {
                    print('Dashboard: State is loaded with data');
                    print('Dashboard: todaysSummary = $todaysSummary');
                    return _buildDashboardContent(metrics, todaysSummary);
                  },
                  error: (failure) {
                    print('Dashboard: State is error - ${failure.message}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: UiColors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading dashboard',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            failure.message,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchDashboardData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    dynamic metrics,
    dynamic todaysSummary,
  ) {
    print('Dashboard: Building content with todaysSummary: $todaysSummary');

    // Handle case where todaysSummary might be null or incomplete
    if (todaysSummary == null) {
      print('Dashboard: todaysSummary is null, showing fallback data');
      return _buildFallbackContent();
    }

    try {
      // Extract metrics from todaysSummary since that contains the actual dashboard data
      // Parse the total amount from currency string
      final String totalAmountStr = todaysSummary.total?.amount ?? '₹0';
      final double totalSales = _parseCurrencyAmount(totalAmountStr);

      // Calculate fuel volume from fuel type sales
      double fuelVolume = 0.0;
      final Map<String, double> fuelVolumeByType = {};

      todaysSummary.fuelTypeSales?.forEach((fuelType, salesData) {
        final double volume = _parseVolumeAmount(salesData.volume ?? '0 L');
        fuelVolumeByType[fuelType] = volume;
        fuelVolume += volume;
      });

      final double indentSales =
          _parseCurrencyAmount(todaysSummary.indentSales?.amount ?? '₹0');
      final double customerPayments =
          0.0; // This would come from a separate call
      final double consumablesSales =
          _parseCurrencyAmount(todaysSummary.consumablesSales?.amount ?? '₹0');
      final int activeShifts = 0; // This would come from metrics
      final int pendingApprovals = 0; // This would come from metrics
      final int transactionCount = todaysSummary.total?.count ?? 0;

      // Convert fuel volume by type to formatted strings
      final Map<String, String> formattedFuelVolume = fuelVolumeByType.map(
        (key, value) => MapEntry(key, _formatVolume(value)),
      );

      return _buildDashboardGrid(
        totalSales: totalSales,
        fuelVolume: fuelVolume,
        formattedFuelVolume: formattedFuelVolume,
        indentSales: indentSales,
        customerPayments: customerPayments,
        consumablesSales: consumablesSales,
        activeShifts: activeShifts,
        pendingApprovals: pendingApprovals,
        transactionCount: transactionCount,
      );
    } catch (e) {
      print('Dashboard: Error building content: $e');
      return _buildFallbackContent();
    }
  }

  Widget _buildFallbackContent() {
    return _buildDashboardGrid(
      totalSales: 0.0,
      fuelVolume: 0.0,
      formattedFuelVolume: {},
      indentSales: 0.0,
      customerPayments: 0.0,
      consumablesSales: 0.0,
      activeShifts: 0,
      pendingApprovals: 0,
      transactionCount: 0,
    );
  }

  Widget _buildDashboardGrid({
    required double totalSales,
    required double fuelVolume,
    required Map<String, String> formattedFuelVolume,
    required double indentSales,
    required double customerPayments,
    required double consumablesSales,
    required int activeShifts,
    required int pendingApprovals,
    required int transactionCount,
  }) {
    return ListView(
      children: [
        // Hero Card - Total Sales
        HeroCard(
          title: 'Total Sales',
          value: _formatCurrency(totalSales),
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 16),

        // 2x2 Grid for main metrics
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            // Fuel Volume - Special card with breakdown
            formattedFuelVolume.isNotEmpty
                ? FuelVolumeCard(
                    title: 'Fuel Volume',
                    totalVolume: _formatVolume(fuelVolume),
                    fuelVolumeByType: formattedFuelVolume,
                    icon: Icons.local_gas_station,
                    iconColor: Colors.blue,
                  )
                : MetricCard(
                    title: 'Fuel Volume',
                    value: _formatVolume(fuelVolume),
                    icon: Icons.local_gas_station,
                    gradient: 'blue',
                    iconColor: Colors.blue,
                  ),

            // Indent Sales
            MetricCard(
              title: 'Indent Sales',
              value: _formatCurrency(indentSales),
              icon: Icons.credit_card,
              gradient: 'blue',
              iconColor: Colors.blue,
            ),

            // Customer Payments
            MetricCard(
              title: 'Customer Payments',
              value: _formatCurrency(customerPayments),
              icon: Icons.account_balance_wallet,
              gradient: 'purple',
              iconColor: Colors.purple,
            ),

            // Consumables Sales
            MetricCard(
              title: 'Consumables Sales',
              value: _formatCurrency(consumablesSales),
              icon: Icons.shopping_cart,
              gradient: 'orange',
              iconColor: Colors.orange,
            ),

            // Active Shifts & Pending Approvals
            DualMetricCard(
              title1: 'Active Shifts',
              value1: activeShifts.toString(),
              icon1: Icons.people,
              iconColor1: Colors.green,
              title2: 'Pending Approvals',
              value2: pendingApprovals.toString(),
              icon2: Icons.schedule,
              iconColor2: Colors.orange,
            ),

            // Transaction Count
            MetricCard(
              title: 'Total Transactions',
              value: transactionCount.toString(),
              icon: Icons.receipt_long,
              gradient: 'indigo',
              iconColor: Colors.indigo,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
