import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_vehicle_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/vehicles_list_provider.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class VehicleDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleList = ref.watch(customerVehicleListProvider);
    final selectedVehicle = ref.watch(selectedCustomerVehicleProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(label: 'Vehicle'),
        customDropdown(
          key: _dropdownKey,
          value: selectedVehicle.vehile,
          context: context,
          dropdownList: vehicleList,
          isRequired: true,
          type: 'Vehicle',
          hintText: 'Select Vehicle',
          onChanged: (p0) {
            selectedVehicle.setSelectedVehicle(p0 as VehicleEntity);
          },
        ),
      ],
    );
  }
}
