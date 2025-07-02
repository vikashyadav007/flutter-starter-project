import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/utils/utils.dart';

class ActiveShifts extends ConsumerWidget {
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
    final shifts = ref.watch(readingsProvider);

    return shifts.when(
      data: (shifts) {
        if (shifts.isEmpty) {
          return const Center(
            child: Text('No active shifts'),
          );
        }
        return Container(
            child: Column(
          children: shifts
              .map<Widget>(
                (shift) => Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(bottom: 10),
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
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              shift.staff?.name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "ID: ${shift.staff?.staffNumericId ?? ""}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            detailRow(
                              flex: 2,
                              label: "Date: ",
                              value: formatDate(
                                  dateTimeString:
                                      shift.startTime.toString() ?? "",
                                  dateFormat: 'dd/MM/yyyy'),
                            ),
                            detailRow(
                              flex: 1,
                              label: "Started: ",
                              value: formatDate(
                                  dateTimeString:
                                      shift.startTime.toString() ?? "",
                                  dateFormat: 'hh:mm a'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            detailRow(
                              flex: 2,
                              label: "Pump ID: ",
                              value: shift.reading?.pumpId ?? "",
                            ),
                            detailRow(
                              flex: 1,
                              label: "Opening\nReading: ",
                              value: "${shift.reading?.openingReading ?? "0"}",
                            ),
                          ],
                        ),
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
                                    ref
                                        .read(selectedShiftProvider.notifier)
                                        .state = shift;
                                    context.push('/${AppPath.endShift.name}');
                                  },
                                  child:

                                      //  recordIndentState.maybeWhen(
                                      //   orElse: () =>

                                      const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.note_add_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "End Shift",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // loading: () => const SizedBox(
                                  //   height: 30,
                                  //   width: 30,
                                  //   child: Padding(
                                  //     padding: EdgeInsets.all(8.0),
                                  //     child: CircularProgressIndicator(
                                  //       color: Colors.white,
                                  //       strokeWidth: 2,
                                  //     ),
                                  //   ),
                                  // ),
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(Icons.clear),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ));
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
