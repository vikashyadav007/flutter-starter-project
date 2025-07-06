import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/pages/search_by_customer_body.dart';
import 'package:starter_project/features/record_indent/presentation/pages/search_by_indent_body.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_tab.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_customer.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/utils/methods.dart';

class RecordIndentBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTabIndex = ref.watch(selectedTabIndexProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: UiColors.lightGray, width: 1.5),
      ),
      child: ListView(
        children: [
          Row(
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Indent Details',
                style: const TextStyle(
                  fontSize: 16,
                  color: UiColors.titleBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Search by indent number or customer to record a fuel indent',
            style: const TextStyle(
              fontSize: 12,
              color: UiColors.titleBlack,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IndentTab(
                    label: "Indent Number",
                    index: 0,
                    selectedIndex: selectedTabIndex,
                    onTap: () {
                      invalidateRecordIndentProviders(ref: ref);

                      ref.read(selectedTabIndexProvider.notifier).state = 0;
                    }),
                IndentTab(
                    label: "Customer",
                    index: 1,
                    selectedIndex: selectedTabIndex,
                    onTap: () {
                      invalidateRecordIndentProviders(ref: ref);
                      ref.read(selectedTabIndexProvider.notifier).state = 1;
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          selectedTabIndex == 0
              ? SearchByIndent(
                  source: 0,
                )
              : SearchIndentByCustomer(),
          const SizedBox(height: 20),
          selectedTabIndex == 0 ? SearchByIndentBody() : SearchByCustomerBody(),
        ],
      ),
    );
  }
}
