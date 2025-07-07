import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class VehicleDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleListState = ref.watch(customerVehicleListProvider);
    final selectedVehicle = ref.watch(selectedCustomerVehicleProvider);

    return vehicleListState.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text('No vehicles available'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextFieldLabel(label: 'Vehicle'),
            customDropdown(
              key: _dropdownKey,
              value: selectedVehicle,
              context: context,
              dropdownList: data,
              isRequired: true,
              type: 'Vehicle',
              hintText: 'Select Vehicle',
              onChanged: (p0) {
                ref.read(selectedCustomerVehicleProvider.notifier).state =
                    p0 as VehicleEntity?;
              },
            ),
          ],
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading vehicles: $error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
