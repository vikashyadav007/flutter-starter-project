import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/fuel_types_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_fuel_type.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class FuelTypeDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuels = ref.watch(fuelTypesProvider);
    final selectedFuel = ref.watch(selectedFuelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(label: 'Fuel Type'),
        customDropdown(
          key: _dropdownKey,
          context: context,
          value: selectedFuel.selectedFuel,
          dropdownList: fuels,
          isRequired: true,
          type: 'Fuel Type',
          hintText: 'Select Fuel Type',
          onChanged: (p0) {
            print(p0);
            selectedFuel.setFuel(p0 as FuelEntity);
          },
        ),
      ],
    );
  }
}
