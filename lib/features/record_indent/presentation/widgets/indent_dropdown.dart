import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/presentation/providers/customer_indents_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_indent_booklet.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class IndentBookletDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerIndents = ref.watch(customerIndentProvider);
    final selectedIndentBooklet =
        ref.watch(selectedIndentBookletProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(label: 'Indent Booklet'),
        customDropdown(
          key: _dropdownKey,
          value: selectedIndentBooklet.indentBooklet,
          context: context,
          dropdownList: customerIndents,
          isRequired: true,
          type: 'Indent Booklet',
          hintText: 'Select Indent Booklet',
          onChanged: (p0) {
            selectedIndentBooklet.setIndentBooklet(p0 as IndentBookletEntity);
            print(p0);
          },
        ),
      ],
    );
  }
}
