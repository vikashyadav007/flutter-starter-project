import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class HomeInfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UiColors.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.orangeAccent,
          ),
          SizedBox(width: 10),
          Expanded(
              child: Text(
                  "Operations recorded on mobile require approval before they're finalized. ")),
        ],
      ),
    );
  }
}
