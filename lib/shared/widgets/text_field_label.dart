import 'package:flutter/material.dart';

class TextFieldLabel extends StatelessWidget {
  final String label;
  const TextFieldLabel({
    Key? key,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
