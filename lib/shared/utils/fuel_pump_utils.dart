import 'package:supabase_flutter/supabase_flutter.dart';

class FuelPumpUtils {
  static Future<String?> getCurrentFuelPumpId() async {
    try {
      // Get current user email
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser?.email == null) {
        print('getCurrentFuelPumpId: No authenticated user found');
        return null;
      }

      // Query fuel pump by email
      final response = await Supabase.instance.client.rpc(
          'get_fuel_pump_by_email',
          params: {'email_param': currentUser!.email});

      if (response != null && response is List && response.isNotEmpty) {
        final fuelPumpData = response[0] as Map<String, dynamic>;
        return fuelPumpData['id'] as String?;
      }

      print(
          'getCurrentFuelPumpId: No fuel pump found for user ${currentUser.email}');
      return null;
    } catch (e) {
      print('getCurrentFuelPumpId: Error fetching fuel pump ID: $e');
      return null;
    }
  }
}
