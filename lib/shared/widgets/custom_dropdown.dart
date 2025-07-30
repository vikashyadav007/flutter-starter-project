import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

Widget customDropdown<T>({
  required Key key,
  required List<T> dropdownList,
  required bool isRequired,
  required String type,
  T? value,
  String? hintText,
  void Function(T?)? onChanged,
  void Function(T?)? onSaved,
  bool isExpanded = true,
  Color boxColor = UiColors.gray,
  Color iconColor = UiColors.gray,
  Color bgcolor = UiColors.white,
  Color textColor = UiColors.black,
  double? fontSize = 14,
  double verticalPadding = 10,
  double horizontalPadding = 5,
  double maxHeight = 50,
  required BuildContext context,
  Widget? extraItemToList,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      DropdownButtonFormField2<T>(
        key: key,
        value: value,
        isExpanded: isExpanded,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          constraints: BoxConstraints(maxHeight: maxHeight),
          filled: true, // Enables the background fill
          fillColor: bgcolor, // Sets background color
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: boxColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: boxColor)),
        ),
        hint: Text(
          hintText ?? 'Select',
          style: TextStyle(fontSize: fontSize, color: UiColors.gray),
        ),
        items: [
          ...dropdownList
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Text(
                        item.toString(),
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: UiColors.black,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          if (extraItemToList != null)
            DropdownMenuItem<T>(
              enabled: false,
              child: extraItemToList,
            ),
        ],
        validator: (value) {
          if (value == null) {
            return 'Please select a $type.';
          }
          return null;
        },
        onChanged: onChanged,
        onSaved: onSaved,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 0),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor,
          ),
          iconSize: 20,
        ),
        selectedItemBuilder: (context) {
          return dropdownList.map((item) {
            return Text(
              item.toString(),
              overflow: TextOverflow.ellipsis, // Show ellipsis when closed
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
              ),
            );
          }).toList();
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: UiColors.white),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 11),
        ),
      ),
    ],
  );
}
