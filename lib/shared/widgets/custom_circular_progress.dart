import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final Color color;
  const CustomCircularProgress({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
