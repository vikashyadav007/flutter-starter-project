import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';
import 'package:fuel_pro_360/shared/widgets/custom_popup.dart';

void endShiftSuccessPopup() {
  customPopup(
    context: navigatorKey!.currentState!.context,
    childWidget: Consumer(builder: (context, ref, child) {
      return Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done,
                  color: UiColors.paidGreen,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'End Shift Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    color: UiColors.paidGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  invalidateActiveShifts(ref: ref);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }),
    barrierDismissible: false,
    onBarrierDismiss: () {
      Navigator.of(navigatorKey!.currentState!.context).pop();
    },
  );
}
