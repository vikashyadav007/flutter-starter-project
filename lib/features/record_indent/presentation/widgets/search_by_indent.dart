import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/record_indent_provider.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class SearchByIndent extends ConsumerWidget {
  void onSearch(WidgetRef ref) async {
    if (ref.read(indentNumberProvider).isNotEmpty) {
      await ref.read(recordIndentProvider.notifier).verifyRecordIndent(
            indentNumber: ref.read(indentNumberProvider),
            selectedTabIndex: ref.read(selectedTabIndexProvider),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordIndentState = ref.watch(recordIndentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(
          label: "Enter Indent Number",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 13,
              child: CustomTextField(
                hintText: 'Enter indent number to search',
                controller:
                    TextEditingController(text: ref.read(indentNumberProvider)),
                validator: Validators.validatePassword,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  ref.read(indentNumberProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 7,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                  onPressed: () {
                    onSearch(ref);
                  },
                  child: recordIndentState.maybeWhen(
                    orElse: () => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(
                      height: 30,
                      width: 30,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        recordIndentState.maybeWhen(
          orElse: () => const SizedBox(),
          error: (error) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                error.message ?? "",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
