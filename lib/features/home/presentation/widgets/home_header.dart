import 'package:flutter/material.dart';
import 'package:starter_project/shared/widgets/logout_button.dart';
import 'package:starter_project/utils/app_assets.dart';

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
