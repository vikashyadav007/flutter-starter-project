import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/features/auth/presentation/providers/auth_provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/custom_circular_progress.dart';
import 'package:starter_project/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool status = await ref
          .read(authProvider.notifier)
          .login(_usernameController.text, _passwordController.text);

      if (status) {
        final router = ref.read(routerProvider);
        router.goNamed(AppPath.home.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ref.listen<AuthState>(authProvider, (previous, current) {
    //   print("this calls");
    //   current.maybeWhen(
    //       completed: (userEntity) {
    //         print("this also comes here");
    //         WidgetsBinding.instance.addPersistentFrameCallback((_) {
    //           print("thsi also comes here 33");
    //           if (mounted) {
    //             context.goNamed(AppPath.home.name);
    //           }
    //         });
    //       },
    //       orElse: () {});
    // });
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          _buildTextField(
            hintText: "Enter your email",
            icon: Icons.email_outlined,
            label: "Email",
            controller: _usernameController,
            validator: Validators.validateEmail,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            hintText: "Enter your password",
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            label: "Password",
            controller: _passwordController,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text("Remember me"),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _onLogin();
              },
              child: authState.maybeWhen(
                orElse:
                    () => const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                loggingIn: () => const CustomCircularProgress(),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Function to Build Text Fields
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required String label,
    required Function(String?) validator,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: (value) {
            return validator(value);
          },
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: UiColors.grey, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
