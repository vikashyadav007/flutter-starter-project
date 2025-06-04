// Flutter imports:
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:flutter/material.dart';

// Project imports:

//TODO add your colors
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(primary: UiColors.blue),
      textTheme: const TextTheme().copyWith(
        displayLarge: const TextStyle(color: UiColors.black),
        displayMedium: const TextStyle(color: UiColors.black),
        displaySmall: const TextStyle(color: UiColors.black),
        headlineLarge: const TextStyle(color: UiColors.black),
        headlineMedium: const TextStyle(color: UiColors.black),
        headlineSmall: const TextStyle(color: UiColors.tundora),
        titleLarge: const TextStyle(color: UiColors.black),
        titleMedium: const TextStyle(color: UiColors.black),
        titleSmall: const TextStyle(color: UiColors.black),
        bodyLarge: const TextStyle(color: UiColors.tundora),
        bodyMedium: const TextStyle(color: UiColors.tundora),
        bodySmall: const TextStyle(color: UiColors.tundora),
        labelLarge: const TextStyle(color: UiColors.tundora),
        labelMedium: const TextStyle(color: UiColors.grey),
        labelSmall: const TextStyle(color: UiColors.grey),
      ),
      scaffoldBackgroundColor: UiColors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(primary: Color(0xff3366FF)),
      scaffoldBackgroundColor: Colors.white,
    );
  }
}
