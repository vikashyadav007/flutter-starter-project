import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class DraftIndentSummary extends ConsumerWidget {
  bool showStatus;
  DraftIndentSummary({Key? key, required this.showStatus}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDraftIndent = ref.watch(selectedDraftIndentProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UiColors.gray.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedDraftIndent?.customers?.name ?? "N/A"}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Row(
            children: [
              Text(
                '${selectedDraftIndent?.vehicles?.number}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 5),
              Container(
                height: 4,
                width: 4,
                decoration: const BoxDecoration(color: Colors.black),
              ),
              const SizedBox(width: 5),
              Text(
                '${selectedDraftIndent?.fuelType}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Text(
            'Indent ID: ${selectedDraftIndent?.indentNumber}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showStatus)
            Text(
              'Status: ${selectedDraftIndent?.status}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
