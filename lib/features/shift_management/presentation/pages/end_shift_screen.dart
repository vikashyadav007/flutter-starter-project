import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_header.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_meter_readings.dart';
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
            const TitleHeader(title: 'End Shift'),
            const SizedBox(height: 20),
            Expanded(
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
                        value: selectedShift?.reading?.pumpId ?? "",
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
                          final cardSales = ref.watch(cardSalesProvider);
                          cardSalesController.text = cardSales;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextFieldLabel(label: 'Card Sales (INR)'),
                              CustomTextField(
                                  hintText: '',
                                  validator: Validators.validateAmount,
                                  controller: cardSalesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => {
                                        ref
                                            .read(cardSalesProvider.notifier)
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextFieldLabel(label: 'UPI Sales (INR)'),
                              CustomTextField(
                                  hintText: '',
                                  validator: Validators.validateAmount,
                                  controller: upiSalesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => {
                                        ref
                                            .read(upiSalesProvider.notifier)
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
                          final cashSales = ref.watch(cashSalesProvider);
                          cashSalesController.text = cashSales;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextFieldLabel(label: 'Cash Sales (INR)'),
                              CustomTextField(
                                  hintText: '',
                                  validator: Validators.validateAmount,
                                  controller: cashSalesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => {
                                        ref
                                            .read(cashSalesProvider.notifier)
                                            .state = value,
                                      }),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Consumer(builder: (context, ref, child) {
                          final otherSales = ref.watch(otherSalesProvider);
                          otherSalesController.text = otherSales;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextFieldLabel(label: 'Others Sales (INR)'),
                              CustomTextField(
                                  hintText: '',
                                  validator: Validators.validateAmount,
                                  controller: otherSalesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => {
                                        ref
                                            .read(otherSalesProvider.notifier)
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
                        const TextFieldLabel(label: 'Indent Sales (INR)'),
                        CustomTextField(
                            hintText: '',
                            validator: Validators.validateAmount,
                            controller: indentSalesController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => {
                                  ref.read(indentSalesProvider.notifier).state =
                                      value,
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
                  const SizedBox(height: 100),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
