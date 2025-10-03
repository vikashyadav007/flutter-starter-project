import 'package:flutter/foundation.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuel_pro_360/shared/widgets/custom_circular_progress.dart';
import 'package:fuel_pro_360/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _usernameController = TextEditingController(text: "admin@example.com");
      _passwordController = TextEditingController(text: "admin123");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).login(
          _usernameController.text, _passwordController.text, _rememberMe);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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

          // Remember Me Checkbox
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              const Text(
                'Remember me',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
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
                orElse: () => const Text(
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
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
