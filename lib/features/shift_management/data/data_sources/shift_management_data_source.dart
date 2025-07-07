import 'package:fuel_pro_360/features/shift_management/data/models/consumables_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/pump_setting_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/reading_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/shift_consumables_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/shift_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/staff_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/transaction_model.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
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

  Future<List<StaffModel>> getStaffs({
    required String fuelPumpId,
  }) async {
    try {
      var query =
          client.from('staff').select('*').eq('fuel_pump_id', fuelPumpId);
      var response = await query;
      print("Response from getReadings: $response");
      return (response as List)
          .map((item) => StaffModel.fromJson(item))
          .toList();
    } catch (e, stackTrace) {
      print('Error fetching staff: $e');
      print('Stack trace: $stackTrace');
      throw Exception("Failed to fetch staff: $e");
    }
  }

  Future<List<ConsumablesModel>> getConsumables({
    required String fuelPumpId,
  }) async {
    try {
      var query = client
          .from('consumables')
          .select('*')
          .eq('fuel_pump_id', fuelPumpId)
          .order('name', ascending: true);
      var response = await query;
      print("Response from getConsumables: $response");
      return (response as List)
          .map((item) => ConsumablesModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching consumables: $e');
      throw Exception("Failed to fetch consumables: $e");
    }
  }

  Future<List<PumpSettingModel>> getFuelPumpSettings({
    required String fuelPumpId,
  }) async {
    try {
      var query = client
          .from('pump_settings')
          .select('*')
          .eq('fuel_pump_id', fuelPumpId)
          .order('pump_number', ascending: true);
      var response = await query;
      print("Response from pump_settings: $response");
      return (response as List)
          .map((item) => PumpSettingModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching pump_settings: $e');
      throw Exception("Failed to fetch pump_settings: $e");
    }
  }

  Future<List<ShiftModel>> createShift(
      {required Map<String, dynamic> body}) async {
    try {
      print("create Shift body: $body");
      var response = await client.from('shifts').insert(body).select();
      print("shift created successfully: $response");
      return (response as List)
          .map((item) => ShiftModel.fromJson(item))
          .toList();
    } catch (e) {
      print("error in creating shift: $e");
      throw Exception("Failed to Create shift");
    }
  }

  Future<List<ReadingModel>> createReading(
      {required Map<String, dynamic> body}) async {
    try {
      print("create Readings body: $body");
      var response = await client.from('readings').insert(body).select();
      print("readings response: $response");
      return (response as List)
          .map((item) => ReadingModel.fromJson(item))
          .toList();
    } catch (e) {
      print("error in creating readings: $e");
      throw Exception("Failed to Create readings");
    }
  }

  Future<void> createShiftConsumables(
      {required Map<String, dynamic> body}) async {
    try {
      print("create Shift Consumables body: $body");
      return await client.from('shift_consumables').insert(body);
    } catch (e) {
      print("error in creating Shift Consumables: $e");
      throw Exception("Failed to Create Shift Consumables");
    }
  }

  Future<List<ShiftConsumablesModel>> getShiftConsumables({
    required String shiftId,
  }) async {
    try {
      var query = client
          .from('shift_consumables')
          .select(
              'id,quantity_allocated,quantity_returned,consumable_id,consumables(name,price_per_unit,unit)')
          .eq(
            'shift_id',
            shiftId,
          );
      var response = await query;
      print("Response from getConsumables: $response");
      return (response as List)
          .map((item) => ShiftConsumablesModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching consumables: $e');
      throw Exception("Failed to fetch consumables: $e");
    }
  }

  Future<List<TransactionModel>> getTransactions({
    required String staffId,
    required String createdAt,
  }) async {
    try {
      var query = client
          .from('transactions')
          .select('amount')
          .eq('staff_id', staffId)
          .gte('created_at', createdAt)
          .lte('created_at', DateTime.now().toIso8601String());

      var response = await query;
      print("Response from getTransactions: $response");
      return (response as List)
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching Transactions: $e');
      throw Exception("Failed to fetch transactions: $e");
    }
  }

  Future<void> completeShift(
      {required Map<String, dynamic> body, required String shiftId}) async {
    try {
      print("complete shift body: $body");
      return await client.from('shifts').update(body).eq('id', shiftId);
    } catch (e) {
      print("error in complete shift: $e");
      throw Exception("Failed to complete shift: $e");
    }
  }

  Future<void> updateReading({
    required Map<String, dynamic> body,
    required String shiftId,
    required String fuelType,
  }) async {
    try {
      print("update Reading body: $body");
      return await client
          .from('readings')
          .update(body)
          .eq('shift_id', shiftId)
          .eq('fuel_type', fuelType);
    } catch (e) {
      print("error in updating reading: $e");
      throw Exception("Failed to update reading");
    }
  }

  Future<void> reconilizeShiftConsumables({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    try {
      print("reconilizeShiftConsumables body: $body");
      return await client.from('shift_consumables').update(body).eq('id', id);
    } catch (e) {
      print("error in updating reading: $e");
      throw Exception("Failed to update reading");
    }
  }
}
