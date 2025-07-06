import 'package:starter_project/features/record_indent/data/models/indent_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DraftIndentsDataSource {
  SupabaseClient get client => Supabase.instance.client;

  Future<List<IndentModel>> getIndents() async {
    try {
      var query = client
          .from('indents')
          .select('*,customers:customer_id(name),vehicles:vehicle_id(number)')
          .inFilter('status', ['Draft', 'Pending Approval']).order('created_at',
              ascending: false);

      var response = await query;
      print("Response from getShifts: $response");
      return (response as List)
          .map((item) => IndentModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching Indents: $e');
      throw Exception("Failed to fetch Indents: $e");
    }
  }

  Future<void> completeDraftIndent(
      {required Map<String, dynamic> body, required String id}) async {
    try {
      print("complete draft indent body: $body");
      print("draft indent id: $id");
      return await client.from('indents').update(body).eq('id', id);
    } catch (e) {
      print("error in completing draft indent: $e");
      throw Exception("Failed to complete draft indent");
    }
  }

  Future<void> createTransaction({
    required Map<String, dynamic> body,
  }) async {
    try {
      print("createTransaction body: $body");
      return await client.from('transactions').insert(body);
    } catch (e) {
      print("error in creating transaction: $e");
      throw Exception("Failed to create draft indent");
    }
  }

  Future<void> deleteDraftIndent({required String id}) async {
    try {
      print("delete draft indent id: $id");
      return await client.from('indents').delete().eq('id', id);
    } catch (e) {
      print("error in deleting draft indent: $e");
      throw Exception("Failed to delete draft indent");
    }
  }
}
