import 'package:flutter/material.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

class IndentTab extends StatelessWidget {
  String label;
  int index;
  int selectedIndex;
  Function()? onTap;
  IndentTab({
    super.key,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: index == selectedIndex
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight:
                    index == selectedIndex ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
                color: index == selectedIndex ? UiColors.black : UiColors.gray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
