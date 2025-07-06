import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_reconciliation.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_header.dart';
import 'package:starter_project/shared/constants/app_constants.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/utils/validators.dart';

class ConsumablesReconciliationEditor extends ConsumerStatefulWidget {
  const ConsumablesReconciliationEditor({super.key});

  @override
  ConsumerState<ConsumablesReconciliationEditor> createState() =>
      _ConsumablesReconciliationEditorState();
}

class _ConsumablesReconciliationEditorState
    extends ConsumerState<ConsumablesReconciliationEditor> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(
      List<ConsumablesReconciliation> consumablesReconciliations) {
    // Create or update controllers
    for (var consumablesReconciliation in consumablesReconciliations) {
      final key = consumablesReconciliation.shiftConsumables.id ?? "";
      if (_controllers.containsKey(key)) {
        if (_controllers[key]!.text != consumablesReconciliation.returns) {
          _controllers[key]!.text = consumablesReconciliation.returns;
        }
      } else {
        _controllers[key] =
            TextEditingController(text: consumablesReconciliation.returns);
      }
    }

    // Remove controllers for deleted nozzles
    final currentKeys =
        consumablesReconciliations.map((r) => r.shiftConsumables.id).toSet();
    final keysToRemove =
        _controllers.keys.where((k) => !currentKeys.contains(k)).toList();
    for (final key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }
  }

  Widget nozzleInputField(
      ConsumablesReconciliation consumablesReconciliation, int index) {
    final controller =
        _controllers[consumablesReconciliation.shiftConsumables.id]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EndShiftHeader(
                    title: consumablesReconciliation
                            .shiftConsumables.consumables?.name ??
                        "",
                    fontSize: 14,
                  ),
                  Text(
                    'Price: ${Currency.rupee}${consumablesReconciliation.shiftConsumables.consumables?.pricePerUnit ?? ""}/per pieces',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: UiColors.lightGray,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: UiColors.gray,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${consumablesReconciliation.shiftConsumables.quantityAllocated ?? ""} pieces allcoated',
                  style: const TextStyle(
                    fontSize: 12,
                    color: UiColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Allocated:",
            style: TextStyle(
              color: UiColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
              '${consumablesReconciliation.shiftConsumables.quantityAllocated.toString()} pieces',
              style: const TextStyle(
                  color: UiColors.textBluecolor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(height: 10),
          const Text(
            "Return:",
            style: TextStyle(
              color: UiColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
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
                        final state =
                            ref.read(consumablesReconciliationProvider);
                        final index = state.indexWhere(
                          (r) =>
                              r.shiftConsumables.id ==
                              consumablesReconciliation.shiftConsumables.id,
                        );
                        if (index == -1) return;

                        int sold = (consumablesReconciliation
                                    .shiftConsumables.quantityAllocated ??
                                0) -
                            (int.tryParse(value) ?? 0);

                        print("sold: $sold");

                        double soldPrice = (consumablesReconciliation
                                    .shiftConsumables
                                    .consumables
                                    ?.pricePerUnit ??
                                0) *
                            sold;

                        print("soldPrice: $soldPrice");

                        final updatedList = [...state];
                        updatedList[index] = updatedList[index].copyWith(
                          returns: value,
                          sold: sold,
                          soldPrice: soldPrice,
                        );

                        ref
                            .read(consumablesReconciliationProvider.notifier)
                            .state = updatedList;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pieces',
                  style: TextStyle(
                    color: UiColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: UiColors.gray,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sold:',
                    style: TextStyle(
                        color: UiColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
                Text(
                    '${consumablesReconciliation.sold} pieces (${Currency.rupee}${consumablesReconciliation.soldPrice.toStringAsFixed(2)})',
                    style: const TextStyle(
                        color: UiColors.paidGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ],
            ),
          ),
          const Divider(
            color: UiColors.gray,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shiftConsumablesState = ref.watch(shiftConsumablesProvider);

    return shiftConsumablesState.when(
      data: (data) {
        final consumablesReconciliation =
            ref.watch(consumablesReconciliationProvider);

        _syncControllers(consumablesReconciliation);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...consumablesReconciliation.asMap().entries.map(
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
