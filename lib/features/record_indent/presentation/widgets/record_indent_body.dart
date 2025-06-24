import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/record_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_content.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_tab.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_customer.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class RecordIndentBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordIndentState = ref.watch(recordIndentProvider);
    final selectedTabIndex = ref.watch(selectedTabIndexProvider);

    print("RecordIndentBody rebuilds");

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
                      ref.read(selectedTabIndexProvider.notifier).state = 0;
                    }),
                IndentTab(
                    label: "Customer",
                    index: 1,
                    selectedIndex: selectedTabIndex,
                    onTap: () {
                      ref.read(selectedTabIndexProvider.notifier).state = 1;
                      ref.read(indentNumberProvider.notifier).state = '';
                      ref.read(recordIndentProvider.notifier).clearAll();
                    }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          selectedTabIndex == 0 ? SearchByIndent() : SearchIndentByCustomer(),
          const SizedBox(height: 20),
          selectedTabIndex == 0
              ? recordIndentState.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  verifiedRecordIndents: (verified) {
                    if (verified) {
                      return IndentContent();
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              : recordIndentState.maybeWhen(
                  orElse: () => IndentContent(),
                  loading: () {
                    return const SizedBox(
                      height: 30,
                      width: 30,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
