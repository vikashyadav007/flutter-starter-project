import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/provider.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class PaymentMethodDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  List<String> paymentModes = [
    'Cash',
    'Card',
    'UPI',
    'Indent/Credit',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(label: 'Payment Method'),
        customDropdown(
          key: _dropdownKey,
          value: selectedPaymentMethod,
          context: context,
          dropdownList: paymentModes,
          isRequired: true,
          type: 'Staff',
          hintText: 'Select Staff',
          onChanged: (p0) {
            ref.read(selectedPaymentMethodProvider.notifier).state =
                p0 as String;
          },
        ),
      ],
    );
  }
}
