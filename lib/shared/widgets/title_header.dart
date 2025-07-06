import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/logout_button.dart';

class TitleHeader extends ConsumerWidget {
  final String title;
  final Function onBackPressed;

  const TitleHeader(
      {Key? key, required this.title, required this.onBackPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  onBackPressed();
                  router.pop();
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
