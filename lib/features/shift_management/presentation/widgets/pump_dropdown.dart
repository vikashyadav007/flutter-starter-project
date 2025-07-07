import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_nozzle_readings.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class PumpDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pumpProviderState = ref.watch(pumpSettingsProvider);
    final selectedPumpState = ref.watch(selectedPumpProvider.notifier);
    final pumpNozzleReadings = ref.watch(pumpNozzleReadingsProvider.notifier);

    return pumpProviderState.when(
      data: (pumpList) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextFieldLabel(label: 'Select Pump'),
            customDropdown(
              key: _dropdownKey,
              value: selectedPumpState.state,
              context: context,
              dropdownList: pumpList,
              isRequired: true,
              type: 'Pump',
              hintText: 'Select Pump',
              onChanged: (p0) {
                selectedPumpState.state = p0 as PumpSettingEntity;
                pumpNozzleReadings.state = [];
                List<PumpNozzleReadings> readings = [];
                for (String fuelType in p0.fuelTypes) {
                  readings.add(PumpNozzleReadings(
                    fuelType: fuelType,
                    currentReading: '',
                  ));
                }
                pumpNozzleReadings.state = readings;
              },
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return Text('Error: $error');
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
