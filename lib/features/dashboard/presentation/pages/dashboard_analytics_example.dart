import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/dashboard/presentation/providers/dashboard_analytics_provider.dart';

class DashboardAnalyticsExample extends ConsumerStatefulWidget {
  const DashboardAnalyticsExample({super.key});

  @override
  ConsumerState<DashboardAnalyticsExample> createState() => _DashboardAnalyticsExampleState();
}

class _DashboardAnalyticsExampleState extends ConsumerState<DashboardAnalyticsExample> {
  @override
  void initState() {
    super.initState();
    // Load today's data when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardAnalyticsProvider.notifier).loadTodaysData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dashboardAnalyticsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: dashboardState.when(
        initial: () => const Center(
          child: Text('Welcome to Dashboard Analytics'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        loaded: (salesData, fuelVolumeData, metrics, recentTransactions, todaysSummary, fuelLevels) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Metrics Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard Metrics',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _MetricCard(
                                title: 'Total Sales',
                                value: metrics.totalSales,
                                icon: Icons.currency_rupee,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricCard(
                                title: 'Customers',
                                value: metrics.customers,
                                icon: Icons.people,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _MetricCard(
                                title: 'Fuel Volume',
                                value: metrics.fuelVolume,
                                icon: Icons.local_gas_station,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _MetricCard(
                                title: 'Growth',
                                value: metrics.growth,
                                icon: Icons.trending_up,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sales Data Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sales Data',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (salesData.isNotEmpty)
                          ...salesData.map((data) => ListTile(
                            title: Text(data.name),
                            trailing: Text('₹${data.total.toStringAsFixed(0)}'),
                          ))
                        else
                          const Text('No sales data available'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Recent Transactions Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (recentTransactions.isNotEmpty)
                          ...recentTransactions.map((transaction) => ListTile(
                            leading: const Icon(Icons.local_gas_station),
                            title: Text(transaction.fuelType),
                            subtitle: Text('${transaction.quantity}L'),
                            trailing: Text('₹${transaction.amount.toStringAsFixed(0)}'),
                          ))
                        else
                          const Text('No recent transactions'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Fuel Levels Section
                if (fuelLevels.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fuel Levels',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...fuelLevels.entries.map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(entry.key),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: LinearProgressIndicator(
                                    value: entry.value / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      entry.value > 50 ? Colors.green : 
                                      entry.value > 20 ? Colors.orange : Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('${entry.value.toStringAsFixed(1)}%'),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        error: (failure) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: ${failure.message}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(dashboardAnalyticsProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Example: Load current month data
          ref.read(dashboardAnalyticsProvider.notifier).loadCurrentMonthData();
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('Load Monthly Data'),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}