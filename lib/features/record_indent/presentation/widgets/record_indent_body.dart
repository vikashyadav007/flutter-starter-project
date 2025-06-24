import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/record_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_content.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_tab.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_customer.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class RecordIndentBody extends ConsumerStatefulWidget {
  const RecordIndentBody({super.key});

  @override
  _RecordIndentBodyState createState() => _RecordIndentBodyState();
}

class _RecordIndentBodyState extends ConsumerState<RecordIndentBody> {
  TextEditingController indentNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final recordIndentState = ref.watch(recordIndentProvider);

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
                  selectedIndex: selectedIndex,
                  onTap: () => setState(
                    () {
                      selectedIndex = 0;
                    },
                  ),
                ),
                IndentTab(
                  label: "Customer",
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: () => setState(
                    () {
                      selectedIndex = 1;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          selectedIndex == 0
              ? SearchByIndent(
                  controller: indentNumberController,
                )
              : SearchIndentByCustomer(
                  controller: customerNameController,
                ),
          const SizedBox(height: 20),
          recordIndentState.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            verifiedRecordIndents: (verified) {
              if (verified) {
                return IndentContent(
                  indentNumberController: indentNumberController,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
