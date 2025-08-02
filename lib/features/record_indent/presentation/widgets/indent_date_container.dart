import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/date_utils.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class IndentDateContainer extends ConsumerWidget {
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indentDate = ref.watch(indentDateProvider);
    dateController.text =
        "${indentDate.day}/${indentDate.month}/${indentDate.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(
          label: 'Date',
        ),
        InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              ).then((value) {
                if (value != null) {
                  ref.read(indentDateProvider.notifier).state = value;
                }
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: UiColors.gray,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: 10),
                  Text(formatDateWithOrdinal(indentDate),
                      style: const TextStyle(
                        color: UiColors.titleBlack,
                        fontSize: 14,
                      )),
                ],
              ),
            )),
      ],
    );
  }
}
