import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';

class TotalSalesCard extends ConsumerWidget {
  Widget divider() {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(thickness: 0.4, color: UiColors.gray),
    );
  }

  Widget fuelSalesRow({
    required BuildContext context,
    required PumpClosingReadings pumpClosingReading,
  }) {
    return Consumer(builder: (context, ref, child) {
      final fuletypeMap = ref.watch(fuelTypesMapProvider);

      double fuelPrice =
          fuletypeMap[pumpClosingReading.reading.fuelType]?.currentPrice ?? 0;

      double dispensed = double.tryParse(pumpClosingReading.totalLiters) ?? 0.0;
      double testing =
          double.tryParse(pumpClosingReading.testingFuelReading) ?? 0.0;
      double netSold = dispensed - testing;

      return Container(
        decoration: BoxDecoration(
          color: UiColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${pumpClosingReading.reading.fuelType}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Expanded(
                    child: Text(
                  '₹${getCommaSeperatedNumberDouble(number: (netSold) * fuelPrice).toString()}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Dispensed: ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                  ),
                ),
                Expanded(
                    child: Text(
                  '${dispensed}L',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                )),
              ],
            ),
            if (testing > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Testing: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '-${testing}L',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                  )),
                ],
              ),
            divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Net Sold:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Expanded(
                    child: Text(
                  '${netSold}L x ₹${getCommaSeperatedNumberDouble(number: fuelPrice).toString()}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                )),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pumpClosingReadings = ref.watch(pumpClosingReadingsProvider);
    final cardSales = ref.watch(cardSalesProvider);
    final upiSales = ref.watch(upiSalesProvider);
    final cashSales = ref.watch(cashSalesProvider);
    final otherSales = ref.watch(otherSalesProvider);
    final indentSales = ref.watch(indentSalesProvider);
    final fuelTypesMap = ref.watch(fuelTypesMapProvider);

    print("objects from fuelTypesMap: $fuelTypesMap");

    double totalLitersSold = 0.0;
    double totalSales = 0.0;
    for (var reading in pumpClosingReadings) {
      if (reading.closingReading.isNotEmpty) {
        totalLitersSold += double.tryParse(reading.totalLiters) ?? 0.0;
        totalLitersSold -= double.tryParse(reading.testingFuelReading) ?? 0.0;
        totalSales += (((double.tryParse(reading.totalLiters) ?? 0.0) -
                (double.tryParse(reading.testingFuelReading) ?? 0.0)) *
            (fuelTypesMap[reading.reading.fuelType]?.currentPrice ?? 0.0));
      }
    }

    double totalPayments = 0.0;
    totalPayments += double.tryParse(cardSales) ?? 0.0;
    totalPayments += double.tryParse(upiSales) ?? 0.0;
    totalPayments += double.tryParse(cashSales) ?? 0.0;
    totalPayments += double.tryParse(otherSales) ?? 0.0;
    totalPayments += double.tryParse(indentSales) ?? 0.0;

    double difference = totalSales - totalPayments;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(300),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Liters Sold:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${totalLitersSold.toStringAsFixed(2)} L',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payments:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '₹${getCommaSeperatedNumber(number: totalPayments.toInt())}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800, color: UiColors.textBluecolor),
              ),
            ],
          ),
          divider(),
          Text(
            'Fuel Sales Breakdown:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          ...pumpClosingReadings.asMap().entries.map(
                (entry) => fuelSalesRow(
                  context: context,
                  pumpClosingReading: entry.value,
                ),
              ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Expected:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${Currency.rupee} ${totalSales.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          if (difference != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Difference:',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: UiColors.red),
                ),
                Text(
                  '${Currency.rupee} ${difference.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: UiColors.red, fontWeight: FontWeight.w600),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
