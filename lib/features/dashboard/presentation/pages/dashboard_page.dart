import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboardData();
    });
  }

  void _fetchDashboardData() {
    Map<String, dynamic> dateRangeMap = {};
    if (selectedPeriod == DateFilterOption.custom &&
        customDateRange != null &&
        customDateRange?.from != null) {
      final startDate = customDateRange!.from!;
      final endDate = customDateRange?.to ?? customDateRange!.from!;

      final startDateFormatted = DashboardUtils.formatDate(startDate);
      final endDateFormatted = DashboardUtils.formatDate(endDate);

      dateRangeMap = {
        'from': startDateFormatted,
        'to': endDateFormatted,
      };
    }
    ref.read(dashboardAnalyticsProvider.notifier).loadDashboardData(
          selectedPeriod.toString().split('.').last,
          dateRangeMap,
        );
  }

  void _handleDateFilterChange(DateFilterOption option, DateRange? dateRange) {
    setState(() {
      selectedPeriod = option;
      if (option == DateFilterOption.custom && dateRange != null) {
        customDateRange = dateRange;
      } else {
        customDateRange = null;
      }
    });
    _fetchDashboardData();
  }

  String _formatCurrency(double amount) {
    return '${Currency.rupee}${getCommaSeperatedNumberDouble(number: amount)}';
  }

  String _formatCustomDateRange() {
    if (customDateRange?.from != null) {
      final startDate =
          DashboardUtils.formatDate(customDateRange!.from!, 'dd MMM yyyy');
      if (customDateRange!.to != null) {
        final endDate =
            DashboardUtils.formatDate(customDateRange!.to!, 'dd MMM yyyy');
        return '$startDate - $endDate';
      } else {
        return startDate;
      }
    }
    return 'No date selected';
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardAnalyticsProvider);

    ref.listen<FuelPumpEntity?>(selectedFuelPumpProvider, (previous, next) {
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

              // Show custom date range when selected
              if (selectedPeriod == DateFilterOption.custom &&
                  customDateRange != null)
                InkWell(
                  onTap: () {
                    selectCustomDateRange(
                      context: context,
                      onChange: _handleDateFilterChange,
                      customDateRange: customDateRange,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatCustomDateRange(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Dashboard Content
              Expanded(
                child: dashboardState.when(
                  initial: () {
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
                  loaded: (dashBoardData) {
                    return _buildDashboardContent(dashBoardData);
                  },
                  error: (failure) {
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
    DashboardDataEntity? dashboardData,
  ) {
    if (dashboardData == null) {
      return _buildFallbackContent();
    }

    try {
      return _buildDashboardGrid(
        dashboardData: dashboardData,
      );
    } catch (e) {
      return _buildFallbackContent();
    }
  }

  Widget _buildFallbackContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No dashboard data available',
          style: TextStyle(
            fontSize: 16,
            color: UiColors.gray,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardGrid({
    required DashboardDataEntity dashboardData,
  }) {
    return ListView(
      children: [
        // Hero Card - Total Sales
        HeroCard(
          title: 'Total Sales',
          value: dashboardData.salesAmount ?? _formatCurrency(0),
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 16),

        FuelVolumeCard(
          title: 'Total Fuel Volume',
          totalVolume: dashboardData.fuelVolume ?? "0",
          fuelVolumeByType: dashboardData.fuelVolumeByType ?? {},
          icon: Icons.local_gas_station,
        ),
        const SizedBox(height: 12),

        // 2x2 Grid for main metrics
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            // Indent Sales
            MetricCard(
              title: 'Indent Sales',
              value: dashboardData.indentSalesAmount ?? _formatCurrency(0),
              icon: Icons.credit_card,
              gradient: 'blue',
              iconColor: Colors.blue,
            ),

            // Customer Payments
            MetricCard(
              title: 'Customer Payments',
              value: dashboardData.customerPayments ?? _formatCurrency(0),
              icon: Icons.account_balance_wallet,
              gradient: 'purple',
              iconColor: Colors.purple,
            ),

            // Consumables Sales
            MetricCard(
              title: 'Consumables Sales',
              value: dashboardData.consumablesSales ?? _formatCurrency(0),
              icon: Icons.shopping_cart,
              gradient: 'orange',
              iconColor: Colors.orange,
            ),

            // Active Shifts & Pending Approvals
            DualMetricCard(
              title1: 'Active Shifts',
              value1: dashboardData.activeShifts?.toString() ?? "0",
              icon1: Icons.people,
              iconColor1: Colors.green,
              title2: 'Pending Approvals',
              value2: dashboardData.pendingApprovals?.toString() ?? "0",
              icon2: Icons.schedule,
              iconColor2: Colors.orange,
            ),

            // Transaction Count
            MetricCard(
              title: 'Total Transactions',
              value: dashboardData.transactionCount?.toString() ?? "0",
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
