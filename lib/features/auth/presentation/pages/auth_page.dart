import 'package:starter_project/features/auth/presentation/widgets/login_form.dart';
import 'package:starter_project/features/auth/presentation/providers/auth_provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/whole_screen_circular_progress.dart';
import 'package:starter_project/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: authState.maybeWhen(
          checkingSavedAuth: () => const WholeScreenCircularProgress(),
          orElse:
              () => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    SvgPicture.asset(
                      AppAssets.appIconSvg,
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 16),

                    // Welcome Text
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    LoginForm(),

                    // OR continue with
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Or continue with"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Google & Apple Sign-in Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          FontAwesomeIcons.google,
                          "Google",
                          Colors.red,
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          FontAwesomeIcons.apple,
                          "Apple",
                          Colors.black,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Sign Up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  // Function to Build Social Login Buttons
  Widget _buildSocialButton(IconData icon, String label, Color? color) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: UiColors.grey),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        onPressed: () {},
        icon: FaIcon(icon, size: 18, color: color),
        label: Text(label),
      ),
    );
  }
}
