import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TitleWithBackHeader extends ConsumerWidget {
  String title;
  TitleWithBackHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.chevron_left),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
