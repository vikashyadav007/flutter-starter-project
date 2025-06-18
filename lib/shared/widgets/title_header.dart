import 'package:flutter/material.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/logout_button.dart';

class TitleHeader extends StatelessWidget {
  final String title;

  const TitleHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  size: 24,
                )),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: UiColors.titleBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        LogoutButton(),
      ],
    );
  }
}
