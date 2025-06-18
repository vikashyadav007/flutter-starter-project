import 'package:flutter/material.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/record_indent_body.dart';
import 'package:starter_project/shared/widgets/title_header.dart';

class RecordIndent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                TitleHeader(title: 'Record Indent'),
                const SizedBox(height: 20),
                RecordIndentBody(),

                // Add your content here
              ],
            ),
          )),
    );
  }
}
