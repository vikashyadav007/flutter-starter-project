import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/providers/complete_draft_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/custom_popup.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

void addNewVehiclePopup() {
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController capacityController = TextEditingController();

  customPopup(
    context: navigatorKey!.currentState!.context,
    childWidget: Consumer(builder: (context, ref, child) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.add, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Add New Vehicle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              size: 18, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Add a new vehicle for this customer to use in the indent.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Consumer(builder: (context, ref, child) {
            final vehicleNumber = ref.watch(vehicleNumberProvider);
            vehicleNumberController.text = vehicleNumber;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldLabel(
                  label: 'Vehicle Number *',
                ),
                CustomTextField(
                  hintText: 'e.g. KA-01-AB-1234',
                  validator: Validators.validateIndent,
                  controller: vehicleNumberController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => {
                    ref.read(vehicleNumberProvider.notifier).state = value,
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Consumer(builder: (context, ref, child) {
            final vehicleType = ref.watch(vehicleTypeProvider);
            vehicleTypeController.text = vehicleType;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldLabel(
                  label: 'Vehicle Type',
                ),
                CustomTextField(
                  hintText: 'Truck',
                  validator: Validators.validateIndent,
                  controller: vehicleTypeController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => {
                    ref.read(vehicleTypeProvider.notifier).state = value,
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Consumer(builder: (context, ref, child) {
            final capacity = ref.watch(capacityProvider);
            capacityController.text = capacity;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextFieldLabel(
                  label: 'Capacity',
                ),
                CustomTextField(
                  hintText: 'e.g. 12 Ton, 20000 Liters',
                  validator: Validators.validateIndent,
                  controller: capacityController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => {
                    ref.read(capacityProvider.notifier).state = value,
                  },
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(vehicleNumberProvider.notifier).state = "";
                      ref.read(vehicleTypeProvider.notifier).state = "";
                      ref.read(capacityProvider.notifier).state = "";
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
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final vehicleNumber = ref.watch(vehicleNumberProvider);

                  return SizedBox(
                    height: 48,
                    child: Consumer(builder: (context, ref, child) {
                      final submitState = ref.watch(completeDraftProvider);

                      return submitState.maybeWhen(
                        orElse: () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: vehicleNumber.isEmpty
                              ? null
                              : () {
                                  ref
                                      .read(completeDraftProvider.notifier)
                                      .submitDraft();
                                },
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "Add Vehicle",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
        ]),
      );
    }),
    barrierDismissible: true,
    onBarrierDismiss: () {
      Navigator.of(navigatorKey!.currentState!.context).pop();
    },
  );
}
