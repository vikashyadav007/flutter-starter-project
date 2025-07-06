import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> customPopup({
  required BuildContext context,
  required Widget childWidget,
  bool barrierDismissible = true,
  VoidCallback? onBarrierDismiss,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext dialogContext) {
      return Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            if (barrierDismissible) {
              onBarrierDismiss?.call();
              Navigator.of(dialogContext).pop();
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {}, // Prevent tap-through
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Material(
                      color: Colors.white,
                      child: IntrinsicWidth(
                        child: IntrinsicHeight(
                          child: childWidget,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
