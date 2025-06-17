import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: UiColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text("Home"),
            ElevatedButton(
              onPressed: () async {
                var result = await Supabase.instance.client
                    .from('customers')
                    .select('*')
                    .eq('fuel_pump_id', '2c762f9c-f89b-4084-9ebe-b6902fdf4311')
                    .order('name');

                print("result: $result");
              },
              child: const Text("Get Clients"),
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await Supabase.instance.client
                    .rpc('get_fuel_pump_by_email', params: {
                  'email_param':
                      Supabase.instance.client.auth.currentUser?.email
                });

                print("result: $response");
              },
              child: const Text("Get Fuel Pump by Email"),
            ),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
