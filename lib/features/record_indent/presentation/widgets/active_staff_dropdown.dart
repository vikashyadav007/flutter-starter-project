import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class ActiveStaffDropdown extends ConsumerWidget {
  String label;

  ActiveStaffDropdown({this.label = 'Select Staff'});
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStaffState = ref.watch(activeStaffProvider);
    final selectedStaff = ref.watch(selectedActiveStaffProvider.notifier);

    return activeStaffState.when(
      data: (staffList) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldLabel(label: label),
            customDropdown(
              key: _dropdownKey,
              value: selectedStaff.state,
              context: context,
              dropdownList: staffList,
              isRequired: true,
              type: 'Staff',
              hintText: 'Select Staff',
              onChanged: (value) {
                ref.read(selectedActiveStaffProvider.notifier).state =
                    value as ActiveStaffEntity?;
              },
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print(stackTrace);
        return Text('Error: $error');
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
