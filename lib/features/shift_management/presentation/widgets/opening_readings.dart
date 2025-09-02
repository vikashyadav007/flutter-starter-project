import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_nozzle_readings.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class OpeningReadings extends ConsumerStatefulWidget {
  const OpeningReadings({super.key});

  @override
  ConsumerState<OpeningReadings> createState() => _OpeningReadingsState();
}

class _OpeningReadingsState extends ConsumerState<OpeningReadings> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<PumpNozzleReadings> readings) {
    // Create or update controllers
    for (var reading in readings) {
      final key = reading.nozzle.id ?? "";
      if (_controllers.containsKey(key)) {
        if (_controllers[key]!.text != reading.currentReading) {
          _controllers[key]!.text = reading.currentReading;
        }
      } else {
        _controllers[key] = TextEditingController(text: reading.currentReading);
      }
    }

    // Remove controllers for deleted nozzles
    final currentKeys = readings.map((r) => r.nozzle.id ?? "").toSet();
    final keysToRemove =
        _controllers.keys.where((k) => !currentKeys.contains(k)).toList();
    for (final key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }

  Widget nozzleInputField(PumpNozzleReadings reading, int index) {
    final controller = _controllers[reading.nozzle.id ?? ""]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${reading.nozzle.nozzleName != null && reading.nozzle.nozzleName!.isNotEmpty ? reading.nozzle.nozzleName : '(Nozzle ${index + 1})'} (${reading.nozzle.fuelType})',
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
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final state = ref.read(pumpNozzleReadingsProvider);
                    final index = state.indexWhere(
                      (r) => r.nozzle.id == reading.nozzle.id,
                    );
                    if (index == -1) return;

                    final updatedList = [...state];
                    updatedList[index] =
                        updatedList[index].copyWith(currentReading: value);

                    ref.read(pumpNozzleReadingsProvider.notifier).state =
                        updatedList;
                  },
                ),
                Text(
                  'Current: ${reading.currentReading.isEmpty ? 'Not Set' : reading.currentReading}',
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
  Widget build(BuildContext context) {
    final selectedPumpProviderState = ref.watch(selectedPumpProvider);

    final readings = ref.watch(pumpNozzleReadingsProvider);
    print(readings);

    _syncControllers(readings); // keep controllers in sync with state

    return selectedPumpProviderState == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ...readings.asMap().entries.map(
                          (entry) => nozzleInputField(
                            entry.value,
                            entry.key,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          );
  }
}
