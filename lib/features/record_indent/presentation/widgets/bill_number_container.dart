import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class BillNumberContainer extends StatelessWidget {
  TextEditingController billNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(builder: (context, ref, child) {
          final billNumber = ref.watch(billNumberProvider);
          billNumberController.text = billNumber;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextFieldLabel(
                label: 'Bill Number (Optional)',
              ),
              CustomTextField(
                hintText: 'Enter Bill Number',
                validator: Validators.validateAmount,
                controller: billNumberController,
                keyboardType: TextInputType.number,
                onChanged: (value) => {
                  ref.read(billNumberProvider.notifier).state = value,
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
