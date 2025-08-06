import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/popup_success_row.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';
import 'package:fuel_pro_360/shared/widgets/custom_popup.dart';

void createIndentSuccessPopup() {
  customPopup(
    context: navigatorKey!.currentState!.context,
    childWidget: Consumer(builder: (context, ref, child) {
      final indentNumber = ref.watch(indentNumberProvider);
      final customer = ref.watch(selectedCustomerProvider);
      final vehicle = ref.watch(selectedCustomerVehicleProvider);
      final selectedFuel = ref.watch(selectedFuelProvider);
      final amount = ref.watch(amountProvider);
      final quantity = ref.watch(quantityProvider);
      final noIndentCheckbox = ref.watch(noIndentCheckboxProvider);
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done,
                  color: UiColors.paidGreen,
                  size: 50,
                ),
                SizedBox(width: 10),
                Text(
                  'Indent Recorded Successfully',
                  style: TextStyle(
                    fontSize: 18,
                    color: UiColors.paidGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Text(
              'The indent has been recorded and the transaction has been created.',
              style: TextStyle(
                  fontSize: 12,
                  color: UiColors.black,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 20),
            if (!noIndentCheckbox)
              PopupSuccessRow(label: 'Indent Number', value: indentNumber),
            PopupSuccessRow(
              label: 'Customer',
              value: customer?.name ?? 'N/A',
            ),
            PopupSuccessRow(
              label: 'Vehicle',
              value: vehicle?.number ?? 'N/A',
            ),
            PopupSuccessRow(
              label: 'Fuel Type',
              value: selectedFuel?.fuelType ?? 'N/A',
            ),
            PopupSuccessRow(
              label: 'Amount',
              value: amount.isNotEmpty ? '${Currency.rupee}$amount' : 'N/A',
            ),
            PopupSuccessRow(
              label: 'Quantity',
              value: quantity.isNotEmpty ? '$quantity L' : 'N/A',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  invalidateRecordIndentProviders(ref: ref);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
