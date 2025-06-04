import 'package:flutter/material.dart';

class WholeScreenCircularProgress extends StatelessWidget {
  const WholeScreenCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
