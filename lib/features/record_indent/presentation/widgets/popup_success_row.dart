import 'package:flutter/widgets.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

class PopupSuccessRow extends StatelessWidget {
  final String label;
  final String value;

  const PopupSuccessRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: UiColors.titleBlack,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
                fontSize: 16,
                color: UiColors.titleBlack,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
