import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_vehicle_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/vehicles_list_provider.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class PumpDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pumpProviderState = ref.watch(pumpSettingsProvider);
    final selectedPumpState = ref.watch(selectedPumpProvider.notifier);

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
