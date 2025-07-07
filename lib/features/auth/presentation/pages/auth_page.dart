import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/auth/presentation/widgets/login_form.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/whole_screen_circular_progress.dart';
import 'package:fuel_pro_360/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, current) {
      current.maybeWhen(
        completed: (user) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(AppPath.home.name);
          });
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              UiColors.loginBgColor,
            ], // Start and end colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: authState.maybeWhen(
          checkingSavedAuth: () => const WholeScreenCircularProgress(),
          orElse: () => SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 90),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        UiColors.loginBgColor,
                        Colors.white,
                      ], // Start and end colors
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    // borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.fuel_pro_360_logo,
                        height: 60,
                      ),
                      const SizedBox(height: 16),

                      // Welcome Text
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          color: UiColors.titleBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Enter your credentials to access your account",
                        style: TextStyle(fontSize: 14, color: UiColors.grey),
                      ),

                      const SizedBox(height: 30),

                      LoginForm(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
