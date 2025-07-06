import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/shift_management/presentation/providers/end_shift_provider.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/cash_count.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_consumables_reconciliation.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_header.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_meter_readings.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/other_expenses.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/shift_financial_summary.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/testing_fuel_reading.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/total_sales_card.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/shared/widgets/title_header.dart';
import 'package:starter_project/utils/validators.dart';

class EndShiftScreen extends ConsumerWidget {
  TextEditingController cardSalesController = TextEditingController();
  TextEditingController upiSalesController = TextEditingController();
  TextEditingController cashSalesController = TextEditingController();
  TextEditingController otherSalesController = TextEditingController();
  TextEditingController indentSalesController = TextEditingController();
  Widget detailRow(
      {required String label, required String value, required int flex}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedShift = ref.watch(selectedShiftProvider);
    final transactionProvider = ref.watch(transactionsProvider);
    final fuelTpyeProvider = ref.watch(fuelTypesProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: fuelTpyeProvider.when(
            data: (fuelTypes) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  TitleHeader(
                    title: 'End Shift',
                    onBackPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: [
                          EndShiftHeader(title: 'Shift Details'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              detailRow(
                                label: 'Staff:',
                                value: selectedShift?.staff?.name ?? "",
                                flex: 1,
                              ),
                              detailRow(
                                label: 'Pump:',
                                value: selectedShift?.readings?[0].pumpId ?? "",
                                flex: 1,
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          EndShiftMeterReadings(),
                          const SizedBox(height: 10),
                          EndShiftHeader(title: 'Sales Details'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final cardSales =
                                      ref.watch(cardSalesProvider);
                                  cardSalesController.text = cardSales;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                          label: 'Card Sales (INR)'),
                                      CustomTextField(
                                          hintText: '',
                                          validator: Validators.validateAmount,
                                          controller: cardSalesController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => {
                                                ref
                                                    .read(cardSalesProvider
                                                        .notifier)
                                                    .state = value,
                                              }),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final upiSales = ref.watch(upiSalesProvider);
                                  upiSalesController.text = upiSales;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                          label: 'UPI Sales (INR)'),
                                      CustomTextField(
                                          hintText: '',
                                          validator: Validators.validateAmount,
                                          controller: upiSalesController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => {
                                                ref
                                                    .read(upiSalesProvider
                                                        .notifier)
                                                    .state = value,
                                              }),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final cashSales =
                                      ref.watch(cashSalesProvider);
                                  cashSalesController.text = cashSales;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                          label: 'Cash Sales (INR)'),
                                      CustomTextField(
                                          hintText: '',
                                          validator: Validators.validateAmount,
                                          controller: cashSalesController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => {
                                                ref
                                                    .read(cashSalesProvider
                                                        .notifier)
                                                    .state = value,
                                              }),
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer(builder: (context, ref, child) {
                                  final otherSales =
                                      ref.watch(otherSalesProvider);
                                  otherSalesController.text = otherSales;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TextFieldLabel(
                                          label: 'Others Sales (INR)'),
                                      CustomTextField(
                                          hintText: '',
                                          validator: Validators.validateAmount,
                                          controller: otherSalesController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => {
                                                ref
                                                    .read(otherSalesProvider
                                                        .notifier)
                                                    .state = value,
                                              }),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Consumer(builder: (context, ref, child) {
                            final indentSales = ref.watch(indentSalesProvider);
                            indentSalesController.text = indentSales;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextFieldLabel(
                                    label: 'Indent Sales (INR)'),
                                CustomTextField(
                                    hintText: '',
                                    validator: Validators.validateAmount,
                                    controller: indentSalesController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => {
                                          ref
                                              .read(
                                                  indentSalesProvider.notifier)
                                              .state = value,
                                        }),
                              ],
                            );
                          }),
                          const Text(
                            'Pre-filled with your recorded indent transactions during this shift',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 20),
                          TestingFuelReading(),
                          const SizedBox(height: 20),
                          TotalSalesCard(),
                          const SizedBox(height: 20),
                          EndShiftConsumablesReconciliation(),
                          const SizedBox(height: 20),
                          OtherExpenses(),
                          const SizedBox(height: 20),
                          CashCount(),
                          const SizedBox(height: 20),
                          ShiftFinancialSummary(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final endShiftState = ref.watch(endShiftProvider);

                            final selectedStaff =
                                ref.watch(selectedStaffProvider);
                            final selectedPump =
                                ref.watch(selectedPumpProvider);

                            final startCashAmount =
                                ref.watch(startingCashAmountProvider);

                            return SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  ref
                                      .read(endShiftProvider.notifier)
                                      .endShift();
                                },
                                child: endShiftState.maybeWhen(
                                  orElse: () => const Text(
                                    "End Shift",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  submitting: () => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Handle cancel action
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              side: const BorderSide(color: Colors.black12),
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
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading fuel types: $error'),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
