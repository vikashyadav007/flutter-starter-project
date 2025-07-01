import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/utils/validators.dart';

class OpeningReadings extends ConsumerWidget {
  Widget nozzleInputField({
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Enter reading',
                  validator: Validators.validateQuantity,
                  controller: TextEditingController(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => {},
                ),
                const Text(
                  'Current: Not set',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPumpProviderState = ref.watch(selectedPumpProvider);
    return selectedPumpProviderState == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              const Text(
                'Opening Readings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Pump: ${selectedPumpProviderState.pumpNumber}",
                      style: const TextStyle(
                          color: UiColors.textBluecolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    ...List.generate(
                        selectedPumpProviderState.fuelTypes.length,
                        (index) => nozzleInputField(
                              label:
                                  '${selectedPumpProviderState.fuelTypes[index]} (Nozzle ${index + 1})',
                            )),
                  ],
                ),
              ),

              // Add your input fields for opening readings here
            ],
          );
  }
}
