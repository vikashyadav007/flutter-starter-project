import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/widgets/staff_dropdown_base.dart';

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
        return StaffDropdownBase(
          label: label,
          dropdownKey: _dropdownKey,
          selectedStaff: selectedStaff.state,
          staffList: staffList,
          onChanged: (p0) {
            selectedStaff.state = p0 as StaffEntity;
          },
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
