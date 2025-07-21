import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class ConsumablesDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumablesProviderState = ref.watch(consumablesProvider);
    final consumablesCartState = ref.watch(consumablesCartProvider);
    final selectedConsumableProviderState =
        ref.watch(selectedConsumableProvider);

    return consumablesProviderState.when(
      data: (consumablesList) {
        final selected =
            consumablesCartState.map((cart) => cart.consumables).toSet();

        final availableConsumables =
            consumablesList.where((item) => !selected.contains(item)).toList();

        print("availableConsumables: $availableConsumables");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextFieldLabel(label: 'Consumable'),
            customDropdown(
              key: _dropdownKey,
              value: selectedConsumableProviderState,
              context: context,
              dropdownList: availableConsumables,
              isRequired: true,
              type: 'Consumable',
              hintText: 'Select Consumable',
              onChanged: (p0) {
                ref.read(selectedConsumableProvider.notifier).state =
                    p0 as ConsumablesEntity;
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
