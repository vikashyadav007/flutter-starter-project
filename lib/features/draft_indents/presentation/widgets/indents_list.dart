import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/provider.dart';
import 'package:starter_project/features/draft_indents/presentation/widgets/delete_draft_indent_confirm_popup.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/app_constants.dart';
import 'package:starter_project/shared/utils/utils.dart';

class IndentsList extends ConsumerWidget {
  Widget detailRow(
      {required String label, required String value, required int flex}) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftIndents = ref.watch(draftIndentsProvider);

    return draftIndents.when(
      data: (indents) {
        if (indents.isEmpty) {
          return const Center(
            child: Text(
              "No draft indents found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          );
        }
        return ListView.builder(
          itemCount: indents.length,
          itemBuilder: (context, index) {
            final indent = indents[index];
            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          '${indent.customers?.name ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(indent.status ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(indent.source ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      detailRow(
                        label: "Indent #",
                        value: indent.indentNumber ?? 'N/A',
                        flex: 2,
                      ),
                      const SizedBox(width: 10),
                      detailRow(
                        flex: 2,
                        label: "Date",
                        value: formatDate(
                            dateTimeString: indent.createdAt.toString() ?? "",
                            dateFormat: 'dd/MM/yyyy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      detailRow(
                        label: "Vehicle",
                        value: indent.vehicles?.number ?? 'N/A',
                        flex: 2,
                      ),
                      const SizedBox(width: 10),
                      detailRow(
                          flex: 2,
                          label: "Fuel Type ",
                          value: indent.fuelType ?? ""),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      detailRow(
                        label: "Quantity",
                        value: "${indent.quantity ?? 0} L",
                        flex: 2,
                      ),
                      const SizedBox(width: 10),
                      detailRow(
                        flex: 2,
                        label: "Amount",
                        value:
                            "${Currency.rupee} ${getCommaSeperatedNumberDouble(number: indent.amount ?? 0.0)}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                              ),
                              onPressed: () {
                                ref.read(selectedStaffProvider.notifier).state =
                                    null;

                                ref
                                    .read(actualQuantityProvider.notifier)
                                    .state = indent.quantity?.toString() ?? '';

                                ref.read(actualAmountProvider.notifier).state =
                                    indent.amount?.toString() ?? '';
                                ref
                                    .read(selectedDraftIndentProvider.notifier)
                                    .state = indent;

                                context.push('/${AppPath.completeIndent.name}');
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Complete",
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
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            ref
                                .read(selectedDraftIndentProvider.notifier)
                                .state = indent;
                            DeleteDraftIndentConfirmPopup();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child:
                                Icon(Icons.delete_forever, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
