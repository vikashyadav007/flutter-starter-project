import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/record_indent_provider.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class SearchByIndent extends ConsumerStatefulWidget {
  final TextEditingController controller;
  SearchByIndent({super.key, required this.controller});

  @override
  ConsumerState<SearchByIndent> createState() => _SearchByIndentState();
}

class _SearchByIndentState extends ConsumerState<SearchByIndent> {
  void _onSearch() async {
    if (widget.controller.text.isNotEmpty) {
      final result = await ref
          .read(recordIndentProvider.notifier)
          .verifyRecordIndent(indentNumber: widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                validator: Validators.validatePassword,
                controller: widget.controller,
                keyboardType: TextInputType.number,
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
                    _onSearch();
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
                    verifyingReocrdIndent: () =>
                        const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
        recordIndentState.maybeWhen(
          orElse: () => SizedBox(),
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
