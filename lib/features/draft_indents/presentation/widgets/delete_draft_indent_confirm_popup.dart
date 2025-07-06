import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/delete_draft_indent_provider.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/provider.dart';
import 'package:starter_project/features/draft_indents/presentation/widgets/draft_indent_summary.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/widgets/custom_popup.dart';

void DeleteDraftIndentConfirmPopup() {
  customPopup(
    context: navigatorKey!.currentState!.context,
    childWidget: Consumer(builder: (context, ref, child) {
      return Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: UiColors.red,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'Delete Draft Indent',
                  style: TextStyle(
                    fontSize: 18,
                    color: UiColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'This action cannot be undone. The draft indent will be permanently deleted.',
              style: TextStyle(
                fontSize: 14,
                color: UiColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            DraftIndentSummary(
              showStatus: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(selectedDraftIndentProvider.notifier).state =
                            null;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    return SizedBox(
                      height: 48,
                      width: 50,
                      child: Consumer(builder: (context, ref, child) {
                        final delteIndentState =
                            ref.watch(deleteDraftIndentProvider);

                        return delteIndentState.maybeWhen(
                          orElse: () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UiColors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ref
                                  .read(deleteDraftIndentProvider.notifier)
                                  .deleteDraftIndent();
                            },
                            child: const Text(
                              "Delete Draft",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          loading: () => const SizedBox(
                            height: 30,
                            width: 30,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      );
    }),
    barrierDismissible: false,
    onBarrierDismiss: () {
      Navigator.of(navigatorKey!.currentState!.context).pop();
    },
  );
}
