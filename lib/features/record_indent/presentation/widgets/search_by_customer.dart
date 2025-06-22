import 'package:flutter/material.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class SearchIndentByCustomer extends StatelessWidget {
  TextEditingController controller;
  SearchIndentByCustomer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextFieldLabel(
          label: "Search Customer",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 13,
              child: CustomTextField(
                  hintText: 'Select a customer...',
                  validator: Validators.validatePassword,
                  controller: controller),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 7,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
