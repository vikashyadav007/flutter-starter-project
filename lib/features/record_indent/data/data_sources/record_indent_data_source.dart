import 'package:starter_project/features/customers/data/models/customer_model.dart';
import 'package:starter_project/features/record_indent/data/models/fuel_model.dart';
import 'package:starter_project/features/record_indent/data/models/indent_booklet_model.dart';
import 'package:starter_project/features/record_indent/data/models/indent_model.dart';
import 'package:starter_project/features/record_indent/data/models/vehicle_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordIndentDataSource {
  SupabaseClient get client => Supabase.instance.client;
  RecordIndentDataSource();

  Future<List<VehicleModel>> getCustomerVehicles(
      {required String customerId, required String fuelPumpId}) async {
    try {
      var response = await client
          .from('vehicles')
          .select("id,customer_id,number,type,capacity,created_at,fuel_pump_id")
          .eq("customer_id", customerId)
          .eq('fuel_pump_id', fuelPumpId);
      return response != null
          ? (response as List)
              .map((item) => VehicleModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<IndentBookletModel>> getCustomerIndentBooklets({
    required String customerId,
    required String fuelPumpId,
  }) async {
    try {
      //TODO add order created_at desc
      var response = await client
          .from('indent_booklets')
          .select(
              "id,start_number,end_number,used_indents,total_indents,status")
          .eq("customer_id", customerId)
          .eq('fuel_pump_id', fuelPumpId);
      return response != null
          ? (response as List)
              .map((item) => IndentBookletModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<FuelModel>> getFuelTypes({required String fuelPumpId}) async {
    try {
      var response = await client
          .from('fuel_settings')
          .select("fuel_type,current_price")
          .eq('fuel_pump_id', fuelPumpId);
      return response != null
          ? (response as List).map((item) => FuelModel.fromJson(item)).toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<IndentModel>> verifyCustomerIndentNumber(
      {required String indentNumber, required String bookletId}) async {
    try {
      print("this comes hererer $indentNumber");
      var response = await client
          .from('indents')
          .select("id")
          .eq('indent_number', indentNumber)
          .eq('booklet_id', bookletId);
      print("response: $response");
      return response != null
          ? (response as List)
              .map((item) => IndentModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<CustomerModel>> searchCustomer(
      {required String searchKey}) async {
    try {
      var response = await client.rpc('get_fuel_pump_by_email', params: {
        'email_param': Supabase.instance.client.auth.currentUser?.email
      });
      return response != null
          ? (response as List)
              .map((item) => CustomerModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<IndentBookletModel>> getIndentBooklets(
      {required String fuelPumpId}) async {
    try {
      print("this comes here $fuelPumpId");
      print("Fuel Pump ID: $fuelPumpId");
      var response = await client
          .from('indent_booklets')
          .select("id,customer_id,start_number,end_number")
          .eq('fuel_pump_id', fuelPumpId);

      return response != null
          ? (response as List)
              .map((item) => IndentBookletModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<CustomerModel>> getCustomer(
      {required String customerId, required String fuelPumpId}) async {
    try {
      print("this comes here to get customer $customerId");
      print("Fuel Pump ID: $fuelPumpId");
      var response = await client
          .from('customers')
          .select("id,name")
          .eq("id", customerId)
          .eq('fuel_pump_id', fuelPumpId);

      print("response: $response");
      return response != null
          ? (response as List)
              .map((item) => CustomerModel.fromJson(item))
              .toList()
          : [];
    } catch (e) {
      print("Error fetching Customers: $e");
      throw Exception("Failed to fetch Custome");
    }
  }
}
