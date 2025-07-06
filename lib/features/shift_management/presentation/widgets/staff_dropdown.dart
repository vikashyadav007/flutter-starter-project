import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/widgets/custom_dropdown.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';

class StaffDropdown extends ConsumerWidget {
  String label;

  StaffDropdown({this.label = 'Select Staff'});
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffProvider = ref.watch(staffsProvider);
    final selectedStaff = ref.watch(selectedStaffProvider.notifier);

    return staffProvider.when(
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
              onChanged: (p0) {
                selectedStaff.state = p0 as StaffEntity;
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
