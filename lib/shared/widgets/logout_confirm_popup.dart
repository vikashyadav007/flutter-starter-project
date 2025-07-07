import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';
import 'package:fuel_pro_360/shared/widgets/custom_popup.dart';

void LogoutConfirmPopup() {
  customPopup(
    context: navigatorKey!.currentState!.context,
    childWidget: Consumer(builder: (context, ref, child) {
      return Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: UiColors.red,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'Signout Confirmation',
                  style: TextStyle(
                    fontSize: 18,
                    color: UiColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to Logout?',
              style: TextStyle(
                fontSize: 14,
                color: UiColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    return SizedBox(
                      height: 48,
                      width: 50,
                      child: Consumer(builder: (context, ref, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            invalidateAllProviders(ref: ref);
                            Navigator.of(context).pop();
                            ref.read(authProvider.notifier).logout();
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      );
    }),
    barrierDismissible: true,
    onBarrierDismiss: () {
      Navigator.of(navigatorKey!.currentState!.context).pop();
    },
  );
}
