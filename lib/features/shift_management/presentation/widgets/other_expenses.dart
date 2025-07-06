import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class OtherExpenses extends ConsumerWidget {
  TextEditingController otherExpensesController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherExpenses = ref.watch(otherExpensesProvider);
    otherExpensesController.text = otherExpenses;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: UiColors.red.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: UiColors.gray.withAlpha(100), width: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Other Expenses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 20),
          const TextFieldLabel(label: 'Other Expenses (INR)'),
          CustomTextField(
              hintText: 'Enter other expenses',
              validator: Validators.validateAmount,
              controller: otherExpensesController,
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                    ref.read(otherExpensesProvider.notifier).state = value,
                  }),
          const SizedBox(height: 5),
          Text('Enter any additional expenses during this shift',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                  )),
        ],
      ),
    );
  }
}
