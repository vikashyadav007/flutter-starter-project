import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/logout_confirm_popup.dart';

class LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: UiColors.lightGray, width: 1.5),
      ),
      child: IconButton(
        onPressed: () {
          LogoutConfirmPopup();
        },
        icon: const Icon(
          Icons.logout,
          color: UiColors.gray,
        ),
      ),
    );
  }
}
