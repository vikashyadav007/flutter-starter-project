import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_vehicle_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/vehicles_list_provider.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class ConsumablesDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumablesProviderState = ref.watch(consumablesProvider);
    final selectedConsumableProviderState =
        ref.watch(selectedConsumableProvider.notifier);

    return consumablesProviderState.when(
      data: (consumablesList) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextFieldLabel(label: 'Consumable'),
            customDropdown(
              key: _dropdownKey,
              value: selectedConsumableProviderState.state,
              context: context,
              dropdownList: consumablesList,
              isRequired: true,
              type: 'Consumable',
              hintText: 'Select Consumable',
              onChanged: (p0) {
                selectedConsumableProviderState.state = p0 as ConsumablesEntity;
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
