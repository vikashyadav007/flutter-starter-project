import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/other_expenses.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class ShiftFinancialSummary extends ConsumerWidget {
  Widget row({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? UiColors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(thickness: 0.4, color: UiColors.gray),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardSales = ref.watch(cardSalesProvider);
    final upiSales = ref.watch(upiSalesProvider);
    final cashSales = ref.watch(cashSalesProvider);
    final otherSales = ref.watch(otherSalesProvider);
    final indentSales = ref.watch(indentSalesProvider);
    final consumablesReconciliation =
        ref.watch(consumablesReconciliationProvider);
    final selectedShift = ref.watch(selectedShiftProvider);

    final otherExpenses = ref.watch(otherExpensesProvider);
    final cashCount = ref.watch(cashCountProvider);

    double totalConsumablesSales = 0;
    for (var consumable in consumablesReconciliation) {
      totalConsumablesSales += (consumable.soldPrice ?? 0);
    }

    double totalRevenue = (double.tryParse(cardSales) ?? 0.0) +
        (double.tryParse(upiSales) ?? 0.0) +
        (double.tryParse(cashSales) ?? 0.0) +
        (double.tryParse(otherSales) ?? 0.0) +
        (double.tryParse(indentSales) ?? 0.0) +
        totalConsumablesSales;

    double totalExpenses = double.tryParse(otherExpenses) ?? 0.0;

    double netRevenue = totalRevenue - totalExpenses;

    double expectedCashCount = (selectedShift?.readings?[0].cashGiven ?? 0.0) +
        (cashSales.isEmpty ? 0.0 : double.tryParse(cashSales) ?? 0.0) -
        (otherExpenses.isEmpty ? 0.0 : double.tryParse(otherExpenses) ?? 0.0);

    double cashDifference =
        (cashCount.isEmpty ? 0.0 : double.tryParse(cashCount) ?? 0.0) -
            expectedCashCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: UiColors.blue.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: UiColors.gray.withAlpha(100), width: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cashDifference == 0
                  ? const Icon(
                      Icons.done,
                      color: UiColors.paidGreen,
                    )
                  : const Icon(
                      Icons.warning_amber,
                      color: Colors.amber,
                    ),
              const SizedBox(width: 10),
              Text(
                'Shift Financial Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextFieldLabel(label: 'Revenue Streams'),
                    row(
                      context: context,
                      label: 'Card Sales:',
                      value: '₹${cardSales.isEmpty ? '0.00' : cardSales}',
                    ),
                    row(
                      context: context,
                      label: 'UPI Sales:',
                      value: '₹${upiSales.isEmpty ? '0.00' : upiSales}',
                    ),
                    row(
                      context: context,
                      label: 'Cash Sales:',
                      value: '₹${cashSales.isEmpty ? '0.00' : cashSales}',
                    ),
                    row(
                      context: context,
                      label: 'Other Sales:',
                      value: '₹${otherSales.isEmpty ? '0.00' : otherSales}',
                    ),
                    row(
                      context: context,
                      label: 'Indent Sales:',
                      value: '₹${indentSales.isEmpty ? '0.00' : indentSales}',
                    ),
                    divider(),
                    row(
                      context: context,
                      label: 'Consumables Sales:',
                      value: '₹${totalConsumablesSales.toStringAsFixed(2)}',
                    ),
                    divider(),
                    row(
                      context: context,
                      label: 'Total Revenue:',
                      valueColor: UiColors.paidGreen,
                      value:
                          '${Currency.rupee}${totalRevenue.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldLabel(label: 'Expenses & Deductions'),
                    row(
                      context: context,
                      label: 'Other Expenses:',
                      valueColor: UiColors.red,
                      value:
                          '₹${otherExpenses.isEmpty ? '0.00' : otherExpenses}',
                    ),
                    divider(),
                    row(
                        context: context,
                        label: 'Total Expenses:',
                        valueColor: UiColors.red,
                        value:
                            '${Currency.rupee}${totalExpenses.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
          divider(),
          row(
            context: context,
            label: 'Net Revenue:',
            valueColor: UiColors.paidGreen,
            value: '${Currency.rupee}${netRevenue.toStringAsFixed(2)}',
          ),
          divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: [
                  row(
                    context: context,
                    label: 'Cash at shift start',
                    value:
                        '${Currency.rupee}${selectedShift?.readings?[0].cashGiven?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  row(
                    context: context,
                    label: 'Cash Sales: ',
                    value:
                        '${Currency.rupee}${cashSales.isEmpty ? '0.00' : cashSales}',
                  ),
                  row(
                    context: context,
                    label: 'Less: Other Expenses:',
                    value:
                        '${Currency.rupee}${otherExpenses.isEmpty ? '0.00' : otherExpenses}',
                    valueColor: UiColors.red,
                  ),
                  divider(),
                  row(
                      context: context,
                      label: 'Expected Cash:',
                      value:
                          '${Currency.rupee}${expectedCashCount.toStringAsFixed(2)}'),
                ],
              )),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                children: [
                  row(
                    context: context,
                    label: 'Actual Cash Remaining:',
                    value:
                        '${Currency.rupee}${cashCount.isEmpty ? '0.00' : cashCount}',
                  ),
                  row(
                    context: context,
                    label: 'Difference:',
                    valueColor:
                        cashDifference == 0 ? UiColors.paidGreen : UiColors.red,
                    value:
                        '${Currency.rupee}${cashDifference.toStringAsFixed(2)}',
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: cashDifference == 0
                          ? Theme.of(context).colorScheme.primary
                          : UiColors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                        cashDifference == 0 ? 'Balanced' : 'Check Required',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: UiColors.white,
                              fontWeight: FontWeight.w600,
                            )),
                  ),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
