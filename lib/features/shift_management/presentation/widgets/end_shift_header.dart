import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class EndShiftHeader extends StatelessWidget {
  String title;
  double fontSize;
  EndShiftHeader({
    required this.title,
    this.fontSize = 18,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title,
          style: TextStyle(
            fontSize: fontSize,
            color: UiColors.textBlack,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
