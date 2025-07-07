import 'package:go_router/go_router.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/home/presentation/providers/home_provider.dart';
import 'package:fuel_pro_360/features/home/presentation/widgets/home_header.dart';
import 'package:fuel_pro_360/features/home/presentation/widgets/home_info_text.dart';
import 'package:fuel_pro_360/features/home/presentation/widgets/home_item_tile.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    final homeState = ref.watch(homeProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          color: UiColors.white,
          child: Column(
            children: [
              HomeHeader(),
              const SizedBox(height: 30),
              HomeInfoText(),
              const SizedBox(height: 20),
              Row(
                children: [
                  HomeItemTile(
                    icon: Icons.credit_card,
                    title: "Indent",
                    subtitle: "Record",
                    onTap: () {
                      context.push('/${AppPath.recordIndent.name}');
                    },
                    iconColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  HomeItemTile(
                    icon: Icons.calendar_today,
                    onTap: () {
                      context.push('/${AppPath.shiftManagement.name}');
                    },
                    title: "Shift",
                    subtitle: "Log",
                    iconColor: Colors.lightGreen,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  HomeItemTile(
                    icon: Icons.person,
                    title: "Client",
                    subtitle: "View",
                    iconColor: UiColors.orange,
                    onTap: () {
                      context.push('/${AppPath.customers.name}');
                    },
                  ),
                  const SizedBox(width: 10),
                  HomeItemTile(
                    icon: Icons.note_sharp,
                    title: "Draft",
                    subtitle: "Indents",
                    iconColor: Colors.blueAccent,
                    onTap: () {
                      context.push('/${AppPath.draftIndents.name}');
                    },
                  ),
                ],
              )

              // const SizedBox(height: 50),
              // Text("Home"),
              // ElevatedButton(
              //   onPressed: () async {
              //     var result = await Supabase.instance.client
              //         .from('customers')
              //         .select('*')
              //         .eq('fuel_pump_id', '2c762f9c-f89b-4084-9ebe-b6902fdf4311')
              //         .order('name');

              //     print("result: $result");
              //   },
              //   child: const Text("Get Clients"),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     var response = await Supabase.instance.client
              //         .rpc('get_fuel_pump_by_email', params: {
              //       'email_param':
              //           Supabase.instance.client.auth.currentUser?.email
              //     });

              //     print("result: $response");
              //   },
              //   child: const Text("Get Fuel Pump by Email"),
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await Supabase.instance.client.auth.signOut();
              //   },
              //   child: const Text("Logout"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
