import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/widgets/indents_list.dart';
import 'package:fuel_pro_360/shared/widgets/title_header.dart';

class DraftIndentsScreen extends ConsumerWidget {
  const DraftIndentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
