import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class IndentBookletDropdown extends ConsumerWidget {
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerIndents = ref.watch(customerIndentProvider);
    final selectedIndentBooklet = ref.watch(selectedIndentBookletProvider);
    return customerIndents.when(data: (data) {
      if (data.isEmpty) {
        return const Center(
          child: Text('No Indent Booklets available'),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextFieldLabel(label: 'Indent Booklet'),
          customDropdown(
            key: _dropdownKey,
            value: selectedIndentBooklet,
            context: context,
            dropdownList: data,
            isRequired: true,
            type: 'Indent Booklet',
            hintText: 'Select Indent Booklet',
            onChanged: (p0) {
              ref.read(selectedIndentBookletProvider.notifier).state =
                  p0 as IndentBookletEntity?;
            },
          ),
        ],
      );
    }, error: (error, stackTrace) {
      return Center(
        child: Text('Error: $error'),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
