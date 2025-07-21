import 'dart:io';

import 'package:fuel_pro_360/features/customers/data/models/customer_model.dart';
import 'package:fuel_pro_360/features/record_indent/data/models/fuel_model.dart';
import 'package:fuel_pro_360/features/record_indent/data/models/indent_booklet_model.dart';
import 'package:fuel_pro_360/features/record_indent/data/models/indent_model.dart';
import 'package:fuel_pro_360/features/record_indent/data/models/vehicle_model.dart';
import 'package:fuel_pro_360/features/shift_management/data/models/staff_model.dart';
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
      return (response as List)
          .map((item) => VehicleModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to customer vehicles");
    }
  }

  Future<List<IndentBookletModel>> getCustomerIndentBooklets(
      {String? customerId, String? fuelPumpId, String? id}) async {
    try {
      print("fetching customer indent booklets with customerId: $customerId, "
          "fuelPumpId: $fuelPumpId, id: $id");

      String table = 'indent_booklets';
      String columns =
          'id,start_number,end_number,used_indents,total_indents,status';

      var response = [];
      if (id != null && id.isNotEmpty) {
        response = await client.from(table).select(columns).eq("id", id);
      } else if (customerId != null &&
          customerId.isNotEmpty &&
          fuelPumpId != null &&
          fuelPumpId.isNotEmpty) {
        response = await client
            .from(table)
            .select(columns)
            .eq("customer_id", customerId)
            .eq('fuel_pump_id', fuelPumpId);
      }

      return (response as List)
          .map((item) => IndentBookletModel.fromJson(item))
          .toList();
    } catch (e) {
      print("error in fetching cutomer indent booklets: $e");
      throw Exception("Failed to fetch customer indent booklets");
    }
  }

  Future<List<FuelModel>> getFuelTypes({required String fuelPumpId}) async {
    try {
      var response = await client
          .from('fuel_settings')
          .select("fuel_type,current_price")
          .eq('fuel_pump_id', fuelPumpId);

      print("objects from getFuelTypes: $response");
      return (response as List)
          .map((item) => FuelModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<IndentModel>> verifyCustomerIndentNumber(
      {required String indentNumber, required String bookletId}) async {
    try {
      var response = await client
          .from('indents')
          .select("id")
          .eq('indent_number', indentNumber)
          .eq('booklet_id', bookletId);
      return (response as List)
          .map((item) => IndentModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to verify customer indent");
    }
  }

//TODO implement this
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
      throw Exception("Failed to fetch fuel data");
    }
  }

//TODO wherever this is calling replace this with getCustomerIndentBooklets
  Future<List<IndentBookletModel>> getIndentBooklets(
      {required String fuelPumpId}) async {
    try {
      var response = await client
          .from('indent_booklets')
          .select("id,customer_id,start_number,end_number")
          .eq('fuel_pump_id', fuelPumpId);

      return (response as List)
          .map((item) => IndentBookletModel.fromJson(item))
          .toList();
    } catch (e) {
      print("Error fetching Vehicles: $e");
      throw Exception("Failed to fetch fuel data");
    }
  }

  Future<List<CustomerModel>> getCustomer(
      {required String customerId, required String fuelPumpId}) async {
    try {
      var response = await client
          .from('customers')
          .select("id,name,balance")
          .eq("id", customerId)
          .eq('fuel_pump_id', fuelPumpId);

      return (response as List)
          .map((item) => CustomerModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch Custome");
    }
  }

  Future<List<StaffModel>> getStaffs({required String fuelPumpId}) async {
    try {
      var response = await client
          .from('staff')
          .select("id,name")
          .eq('fuel_pump_id', fuelPumpId)
          .order('name', ascending: false);

      return (response as List)
          .map((item) => StaffModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch Staffs");
    }
  }

  Future<void> createIndent({required Map<String, dynamic> body}) async {
    try {
      print("create indent body: $body");
      return await client.from('indents').insert(body);
    } catch (e) {
      print("error in creating indent: $e");
      throw Exception("Failed to Create Indent");
    }
  }

  Future<List<CustomerModel>> getAllCustomers(
      {required String fuelPumpId}) async {
    try {
      print("fetching all customers for fuelPumpId: $fuelPumpId");
      var response = await client
          .from('customers')
          .select("*")
          .eq('fuel_pump_id', fuelPumpId)
          .order('name', ascending: true);

      print("response from getAllCustomers: $response");

      return (response as List)
          .map((item) => CustomerModel.fromJson(item))
          .toList();
    } catch (e) {
      print("Error fetching Customers: $e");
      throw Exception("Failed to fetch Customers");
    }
  }

  Future<String> uploadMeterReadingImage({required File file}) async {
    try {
      String publicUrl = '';
      final fileName =
          'meter-readings/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fullPath = await client.storage.from('assets').upload(
            fileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      print("full path: $fullPath");

      if (fullPath.isNotEmpty) {
        publicUrl = await client.storage.from('assets').getPublicUrl(fileName);
      }
      print("publicUrl: $publicUrl");

      return publicUrl;
    } catch (e) {
      print("Error uploading meter reading image: $e");
      throw Exception("Failed to upload meter reading image");
    }
  }
}
