import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class CashCount extends ConsumerWidget {
  TextEditingController cashCountController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashCount = ref.watch(cashCountProvider);
    cashCountController.text = cashCount;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: UiColors.paidGreen.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: UiColors.gray.withAlpha(100), width: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cash Count',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 20),
          const TextFieldLabel(label: 'Cash Remaining (INR)'),
          CustomTextField(
              hintText: 'Enter actual cash count',
              validator: Validators.validateAmount,
              controller: cashCountController,
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                    ref.read(cashCountProvider.notifier).state = value,
                  }),
          const SizedBox(height: 5),
          Text('Count and enter the actual cash remaining at shift end',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w300,
                  )),
        ],
      ),
    );
  }
}
