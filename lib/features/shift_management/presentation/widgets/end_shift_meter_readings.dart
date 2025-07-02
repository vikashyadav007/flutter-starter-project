import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_header.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class EndShiftMeterReadings extends ConsumerStatefulWidget {
  const EndShiftMeterReadings({super.key});

  @override
  ConsumerState<EndShiftMeterReadings> createState() =>
      _EndShiftMeterReadingsState();
}

class _EndShiftMeterReadingsState extends ConsumerState<EndShiftMeterReadings> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<PumpClosingReadings> readings) {
    // Create or update controllers
    for (var reading in readings) {
      final key = reading.reading.fuelType ?? "";
      if (_controllers.containsKey(key)) {
        if (_controllers[key]!.text != reading.closingReading) {
          _controllers[key]!.text = reading.closingReading;
        }
      } else {
        _controllers[key] = TextEditingController(text: reading.closingReading);
      }
    }

    // Remove controllers for deleted nozzles
    final currentKeys = readings.map((r) => r.reading.fuelType).toSet();
    final keysToRemove =
        _controllers.keys.where((k) => !currentKeys.contains(k)).toList();
    for (final key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }

  Widget nozzleInputField(PumpClosingReadings pumpClosingReadings, int index) {
    final controller = _controllers[pumpClosingReadings.reading.fuelType]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EndShiftHeader(
            title: pumpClosingReadings.reading.fuelType ?? "",
            fontSize: 14,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Opening Reading",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CustomTextField(
                      hintText: 'Enter reading',
                      validator: Validators.validateQuantity,
                      controller: TextEditingController(
                          text: pumpClosingReadings.reading.openingReading
                                  .toString() ??
                              '0'),
                      keyboardType: TextInputType.number,
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Closing Reading",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CustomTextField(
                      hintText: 'Enter reading',
                      validator: Validators.validateQuantity,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final state = ref.read(pumpClosingReadingsProvider);
                        final index = state.indexWhere(
                          (r) =>
                              r.reading.fuelType ==
                              pumpClosingReadings.reading.fuelType,
                        );
                        if (index == -1) return;

                        var totalLiters = 0.0;
                        if (value.isNotEmpty) {
                          final openingReading =
                              pumpClosingReadings.reading.openingReading ?? 0;
                          final closingReading = double.tryParse(value);
                          if (closingReading != null) {
                            totalLiters = closingReading - openingReading;
                          }
                        } else {
                          totalLiters = 0.0;
                        }

                        print("totalLiters: $totalLiters");
                        final updatedList = [...state];
                        updatedList[index] = updatedList[index].copyWith(
                            closingReading: value,
                            totalLiters: totalLiters.toStringAsFixed(2));

                        ref.read(pumpClosingReadingsProvider.notifier).state =
                            updatedList;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: ${pumpClosingReadings.totalLiters} liters',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final endShitReadingState = ref.watch(endShiftReadingProvider);

    return endShitReadingState.when(
      data: (data) {
        final closingReadings = ref.watch(pumpClosingReadingsProvider);
        _syncControllers(closingReadings);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            EndShiftHeader(title: 'Meter Readings'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...closingReadings.asMap().entries.map(
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
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
