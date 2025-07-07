import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/record_indent_body.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';
import 'package:fuel_pro_360/shared/widgets/title_header.dart';

class RecordIndent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          invalidateRecordIndentProviders(ref: ref);
        }
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: const EdgeInsets.all(20),
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  TitleHeader(
                    title: 'Record Indent',
                    onBackPressed: () {
                      invalidateRecordIndentProviders(ref: ref);
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RecordIndentBody(),
                  ),

                  // Add your content here
                ],
              ),
            )),
      ),
    );
  }
}
