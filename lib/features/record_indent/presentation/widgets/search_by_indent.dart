import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/pages/search_by_indent_body.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_customer_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_indent_provider.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class SearchByIndent extends ConsumerWidget {
  int source = 0; // 0 for search by customer, 1 for search by indent
  SearchByIndent({super.key, required this.source});

  TextEditingController indentNumberController = TextEditingController();
  void onSearch(WidgetRef ref) async {
    if (ref.read(indentNumberProvider).isNotEmpty) {
      if (source == 0) {
        await ref.read(searchByIndentProvider.notifier).verifyRecordIndent();
      } else {
        await ref.read(searchByCustomerProvider.notifier).verifyRecordIndent();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(
          label: "Enter Indent Number",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(builder: (context, ref, child) {
              final indentNumber = ref.watch(indentNumberProvider);
              indentNumberController.text = indentNumber;
              final indentNumberVerified =
                  ref.watch(indentNumberVerifiedProvider);

              return Expanded(
                flex: 13,
                child: CustomTextField(
                  hintText: 'Enter indent number to search',
                  controller: indentNumberController,
                  validator: Validators.validatePassword,
                  keyboardType: TextInputType.text,
                  enabled: indentNumberVerified == false,
                  onChanged: (value) {
                    ref.read(indentNumberVerifiedProvider.notifier).state =
                        false;
                    ref.read(indentNumberProvider.notifier).state = value;
                  },
                ),
              );
            }),
            const SizedBox(width: 10),
            Consumer(builder: (context, ref, child) {
              var searchByIndentState;
              if (source == 0) {
                searchByIndentState = ref.watch(searchByIndentProvider);
              } else {
                searchByIndentState = ref.watch(searchByCustomerProvider);
              }

              return Expanded(
                flex: 7,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                    ),
                    onPressed: () {
                      onSearch(ref);
                    },
                    child: searchByIndentState.maybeWhen(
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
              );
            }),
          ],
        ),
        Consumer(builder: (context, ref, child) {
          var searchByIndentState;
          if (source == 0) {
            searchByIndentState = ref.watch(searchByIndentProvider);
          } else {
            searchByIndentState = ref.watch(searchByCustomerProvider);
          }
          return searchByIndentState.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            error: (error) => Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                error.message,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          );
        }),
      ],
    );
  }
}
