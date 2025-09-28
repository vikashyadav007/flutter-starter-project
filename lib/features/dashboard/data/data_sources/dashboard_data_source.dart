import 'package:fuel_pro_360/features/dashboard/data/models/dashboard_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardDataSource {
  SupabaseClient get client => Supabase.instance.client;

  DashboardDataSource();

  Future<DashboardDataModel> getSalesData(
      String period, Map<String, dynamic> dateRange) async {
    print("getSalesData called");
    try {
      print("period: $period, dateRange: $dateRange");
      var response = await client.functions.invoke(
        'get-mobile-dashboard-metrics',
        body: {
          "period": period,
          if (dateRange.isNotEmpty) "customDateRange": dateRange,
        },
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${client.auth.currentSession?.accessToken}",
        },
      );
      print("response from getSalesData: ${response.data}");
      return DashboardDataModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print("error in fetching sales data: $e");
      throw Exception('Failed to load sales data: $e');
    }
  }
}
