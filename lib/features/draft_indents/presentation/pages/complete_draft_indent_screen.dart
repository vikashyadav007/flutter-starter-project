import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/providers/complete_draft_provider.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/widgets/draft_indent_summary.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/widgets/payment_method_dropdown.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/staff_dropdown.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/shared/widgets/title_header.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class CompleteDraftIndentScreen extends ConsumerWidget {
  final TextEditingController actualQuantityController =
      TextEditingController();
  final TextEditingController acturalAmountController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  CompleteDraftIndentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDraftIndent = ref.watch(selectedDraftIndentProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              TitleHeader(
                title: 'Draft Indents',
                onBackPressed: () {},
              ),
              const SizedBox(height: 20),
              selectedDraftIndent == null
                  ? const Center(
                      child: Text('No draft indent selected'),
                    )
                  : Expanded(
                      child: ListView(
                        children: [
                          DraftIndentSummary(
                            showStatus: false,
                          ),
                          const SizedBox(height: 20),
                          StaffDropdown(
                            label: 'Assign to Staff Member',
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final actualQuantity =
                                      ref.watch(actualQuantityProvider);
                                  actualQuantityController.text =
                                      actualQuantity;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                        label: 'Actual Quantity (L)',
                                      ),
                                      CustomTextField(
                                        hintText: '',
                                        validator: Validators.validateAmount,
                                        controller: actualQuantityController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => {
                                          ref
                                              .read(
                                                  actualAmountProvider.notifier)
                                              .state = value,
                                        },
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final actualAmount =
                                      ref.watch(actualAmountProvider);
                                  acturalAmountController.text = actualAmount;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                          label:
                                              'Actual Amount (${Currency.rupee})'),
                                      CustomTextField(
                                          hintText: '',
                                          validator: Validators.validateAmount,
                                          controller: acturalAmountController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => {
                                                ref
                                                    .read(actualAmountProvider
                                                        .notifier)
                                                    .state = value,
                                              }),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          PaymentMethodDropdown(),
                          const SizedBox(height: 20),
                          Consumer(
                            builder: (context, ref, child) {
                              final additionalNotes =
                                  ref.watch(additionalNotesProvider);
                              additionalNotesController.text = additionalNotes;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextFieldLabel(
                                    label: 'Notes (Optional)',
                                  ),
                                  CustomTextField(
                                    hintText: 'Any additional notes...',
                                    validator: Validators.validateAmount,
                                    minLines: 3,
                                    maxLines: 3,
                                    controller: additionalNotesController,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) => {
                                      ref
                                          .read(
                                              additionalNotesProvider.notifier)
                                          .state = value,
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      ref
                                          .read(selectedDraftIndentProvider
                                              .notifier)
                                          .state = null;
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      side: const BorderSide(
                                          color: Colors.black12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final selectedStaff =
                                      ref.watch(selectedStaffProvider);

                                  final actualQuantity =
                                      ref.watch(actualQuantityProvider);

                                  final actualAmount =
                                      ref.watch(actualAmountProvider);

                                  final selectedpaymentMethod =
                                      ref.watch(selectedPaymentMethodProvider);

                                  return SizedBox(
                                    height: 48,
                                    width: 50,
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                      final submitState =
                                          ref.watch(completeDraftProvider);

                                      return submitState.maybeWhen(
                                        orElse: () => ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: selectedStaff == null ||
                                                  selectedpaymentMethod ==
                                                      null ||
                                                  actualAmount.isEmpty ||
                                                  actualQuantity.isEmpty
                                              ? null
                                              : () {
                                                  ref
                                                      .read(
                                                          completeDraftProvider
                                                              .notifier)
                                                      .submitDraft();
                                                },
                                          child: const Text(
                                            "Complete Indent",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        submitting: () => const SizedBox(
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
                                      );
                                    }),
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
