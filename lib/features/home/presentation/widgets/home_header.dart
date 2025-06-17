import 'package:flutter/material.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: UiColors.lightGray, width: 1.5),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout,
              color: UiColors.gray,
            ),
          ),
        )
      ],
    );
  }
}
