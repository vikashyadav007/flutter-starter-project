import 'package:flutter/material.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/consumables_dropdown.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/opening_readings.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/pump_dropdown.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/staff_dropdown.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/shared/widgets/title_header.dart';
import 'package:starter_project/utils/validators.dart';

class StartNewShift extends StatelessWidget {
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              const TitleHeader(title: 'Start New Shift'),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    StaffDropdown(),
                    const SizedBox(height: 10),
                    PumpDropdown(),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextFieldLabel(label: 'Starting Cash Amount'),
                        CustomTextField(
                            hintText: 'Enter starting cash amount',
                            validator: Validators.validateAmount,
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => {}),
                      ],
                    ),
                    OpeningReadings(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ConsumablesDropdown(),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextFieldLabel(label: 'Quantity'),
                              CustomTextField(
                                  hintText: '1',
                                  validator: Validators.validateQuantity,
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => {}),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const TextFieldLabel(label: ''),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                  ),
                                  onPressed: () {},
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Add",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
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
