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
}
