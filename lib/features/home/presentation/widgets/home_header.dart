import 'package:flutter/material.dart';
import 'package:fuel_pro_360/shared/widgets/logout_button.dart';
import 'package:fuel_pro_360/utils/app_assets.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          AppAssets.fuel_pro_360_logo,
          height: 50,
        ),
        LogoutButton(),
      ],
    );
  }
}
