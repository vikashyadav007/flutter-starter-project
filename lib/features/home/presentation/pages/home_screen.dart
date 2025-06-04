import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: UiColors.white,
        child: Column(children: [const SizedBox(height: 50), Text("Home")]),
      ),
    );
  }
}
