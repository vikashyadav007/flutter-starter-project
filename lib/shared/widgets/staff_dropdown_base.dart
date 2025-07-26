import 'package:flutter/material.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/shared/widgets/custom_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';

class StaffDropdownBase extends StatelessWidget {
  String label;
  Key dropdownKey;
  StaffEntity? selectedStaff;
  List<StaffEntity> staffList;
  Function(StaffEntity?)? onChanged;

  StaffDropdownBase({
    this.label = 'Select Staff',
    required this.dropdownKey,
    required this.selectedStaff,
    required this.staffList,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldLabel(label: label),
        customDropdown(
          key: dropdownKey,
          value: selectedStaff,
          context: context,
          dropdownList: staffList,
          isRequired: true,
          type: 'Staff',
          hintText: 'Select Staff',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
