import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> customPopup({
  required BuildContext context,
  required Widget childWidget,
  bool barrierDismissible = true,
  bool childIsScrollable = false,
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
              padding: childIsScrollable
                  ? EdgeInsets.symmetric(horizontal: 20).copyWith(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    )
                  : EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {}, // Prevent tap-through
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Material(
                      color: Colors.white,
                      child: childIsScrollable
                          ? SingleChildScrollView(
                              child: childWidget,
                            )
                          : IntrinsicWidth(
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
