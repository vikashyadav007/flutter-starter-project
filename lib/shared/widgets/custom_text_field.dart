import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

class CustomTextField extends StatelessWidget {
  String hintText;
  bool obscureText;
  Function(String?) validator;
  TextEditingController controller;
  TextInputType keyboardType;
  Function(String)? onChanged;
  bool enabled;
  int? minLines;
  int? maxLines;
  TextCapitalization textCapitalization;
  List<TextInputFormatter> inputFormatters;

  CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.validator,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      minLines: minLines,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      inputFormatters: [
        ...inputFormatters,
      ],
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: UiColors.gray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: UiColors.gray,
            width: 1,
          ),
        ),
      ),
    );
  }
}
