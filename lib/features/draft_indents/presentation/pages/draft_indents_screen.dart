import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starter_project/features/draft_indents/presentation/widgets/indents_list.dart';
import 'package:starter_project/shared/widgets/title_header.dart';

class DraftIndentsScreen extends StatelessWidget {
  const DraftIndentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                TitleHeader(title: 'Draft Indents', onBackPressed: () {}),
                const SizedBox(height: 20),
                Expanded(child: IndentsList()),
              ],
            ),
          )),
    );
  }
}
