import 'package:starter_project/core/api/api_client.dart';
import 'package:starter_project/features/home/data/models/fuel_pump_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDataSource {
  final ApiClient _apiClient;

  HomeDataSource(this._apiClient);

  Future<List<FuelPumpModel>> getFuelPump() async {
    try {
      var response = await Supabase.instance.client
          .rpc('get_fuel_pump_by_email', params: {
        'email_param': Supabase.instance.client.auth.currentUser?.email
      });
      print("Response from get_fuel_pump_by_email: $response");
      return response != null
          ? (response as List)
              .map((item) => FuelPumpModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching fuel data: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }
}
