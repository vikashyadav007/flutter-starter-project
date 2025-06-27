import 'package:starter_project/features/shift_management/data/models/reading_model.dart';
import 'package:starter_project/features/shift_management/data/models/shift_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShiftManagementDataSource {
  SupabaseClient get client => Supabase.instance.client;

  Future<List<ShiftModel>> getShifts({
    required String fuelPumpId,
  }) async {
    print("this one getShifts is called with fuelPumpId: $fuelPumpId");
    try {
      var query = client
          .from('shifts')
          .select('*,staff:staff_id(id,name,staff_numeric_id)')
          .eq('status', 'active')
          .eq('fuel_pump_id', fuelPumpId);

      var response = await query;
      print("Response from getShifts: $response");
      return (response as List)
          .map((item) => ShiftModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching shifts: $e');
      throw Exception("Failed to fetch shifts: $e");
    }
  }

  Future<List<ReadingModel>> getReadings({
    required List<String> shiftIds,
  }) async {
    try {
      var query = client.from('readings').select('*').inFilter(
            'shift_id',
            shiftIds,
          );
      var response = await query;
      print("Response from getReadings: $response");
      return (response as List)
          .map((item) => ReadingModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching reading: $e');
      throw Exception("Failed to fetch Readings: $e");
    }
  }
}
