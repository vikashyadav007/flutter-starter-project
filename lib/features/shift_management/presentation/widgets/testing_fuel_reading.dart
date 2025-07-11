import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class TestingFuelReading extends ConsumerStatefulWidget {
  const TestingFuelReading({super.key});

  @override
  ConsumerState<TestingFuelReading> createState() => _OpeningReadingsState();
}

class _OpeningReadingsState extends ConsumerState<TestingFuelReading> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<PumpClosingReadings> pumpClosingReadings) {
    // Create or update controllers
    for (var pumpClosingReading in pumpClosingReadings) {
      final key = pumpClosingReading.reading.fuelType ?? "";
      if (_controllers.containsKey(key)) {
        if (_controllers[key]!.text != pumpClosingReading.testingFuelReading) {
          _controllers[key]!.text = pumpClosingReading.testingFuelReading;
        }
      } else {
        _controllers[key] =
            TextEditingController(text: pumpClosingReading.testingFuelReading);
      }
    }

    // Remove controllers for deleted nozzles
    final currentKeys =
        pumpClosingReadings.map((r) => r.reading.fuelType).toSet();
    final keysToRemove =
        _controllers.keys.where((k) => !currentKeys.contains(k)).toList();
    for (final key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }

  Widget nozzleInputField(PumpClosingReadings pumpClosingReading, int index) {
    final controller = _controllers[pumpClosingReading.reading.fuelType]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${pumpClosingReading.reading.fuelType} sales:',
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
                  hintText: '0.00',
                  validator: Validators.validateQuantity,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final state = ref.read(pumpClosingReadingsProvider);
                    final index = state.indexWhere(
                      (r) =>
                          r.reading.fuelType ==
                          pumpClosingReading.reading.fuelType,
                    );
                    if (index == -1) return;

                    final updatedList = [...state];
                    updatedList[index] =
                        updatedList[index].copyWith(testingFuelReading: value);

                    ref.read(pumpClosingReadingsProvider.notifier).state =
                        updatedList;
                  },
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
    final readings = ref.watch(pumpClosingReadingsProvider);

    _syncControllers(readings); // keep controllers in sync with state

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: UiColors.lightGray.withAlpha(200),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: UiColors.lightGray,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Testing Fuel By Type (Liters)",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ...readings.asMap().entries.map(
                    (entry) => nozzleInputField(
                      entry.value,
                      entry.key,
                    ),
                  ),
              const Text(
                "Enter any fuel used for testing purposes that wasn't sold to customers",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
