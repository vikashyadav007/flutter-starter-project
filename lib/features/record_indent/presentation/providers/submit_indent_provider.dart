import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/create_consumables_transactions_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/update_consumables_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/upload_meter_reading_image_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/create_indent_success_popup.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/providers/providers.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';
import 'package:uuid/uuid.dart';

part 'submit_indent_provider.freezed.dart';

@freezed
class SubmitIndentState with _$SubmitIndentState {
  const factory SubmitIndentState.initial() = _Initial;
  const factory SubmitIndentState.submitting() = _Submitting;
  const factory SubmitIndentState.submitted(bool success) = _Submitted;
  const factory SubmitIndentState.error(String message) = _Error;
}

final submitIndentProvider =
    StateNotifierProvider<SubmitIndentNotifier, SubmitIndentState>((ref) {
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final selectedVehicle = ref.watch(selectedCustomerVehicleProvider);
  final selectedFuelType = ref.watch(selectedFuelProvider);
  final selectedIndentBooklet = ref.watch(selectedIndentBookletProvider);
  final createIndentUsecase = ref.watch(createIndentUsecaseProvider);
  final getCustomerIndentUsecase = ref.watch(getCustomerIndentUsecaseProvider);

  final createConsumablesTransactionsUsecase = ref.watch(
    createConsumablesTransactionsUsecaseProvider,
  );

  final updateConsumablesUsecase = ref.watch(updateConsumablesUsecaseProvider);

  final uploadMeterReadingImageUsecase =
      ref.watch(uploadMeterReadingImageUsecaseProvider);

  final meterReadingImage = ref.watch(meterReadingImageProvider);

  final quantity = ref.watch(quantityProvider);
  final amount = ref.watch(amountProvider);
  final indentNumber = ref.watch(indentNumberProvider);

  final indentDate = ref.watch(indentDateProvider);
  final billNumber = ref.watch(billNumberProvider);

  final selectedStaff = ref.watch(selectedActiveStaffProvider);

  final totalConsumablesCost = ref.watch(totalConsumablesCostProvider);

  final noIndentCheckbox = ref.watch(noIndentCheckboxProvider);

  final consumablesCart = ref.watch(consumablesCartProvider);

  return SubmitIndentNotifier(
    selectedFuelPump: selectedPump,
    selectedCustomer: selectedCustomer,
    selectedVehicle: selectedVehicle,
    selectedFuelType: selectedFuelType,
    selectedIndentBooklet: selectedIndentBooklet,
    createIndentUsecase: createIndentUsecase,
    getCustomerIndentUsecase: getCustomerIndentUsecase,
    uploadMeterReadingImageUsecase: uploadMeterReadingImageUsecase,
    meterReadingImage: meterReadingImage,
    quantity: quantity,
    amount: amount,
    indentNumber: indentNumber,
    selectedStaff: selectedStaff,
    indentDate: indentDate,
    billNumber: billNumber,
    totalConsumablesCost: totalConsumablesCost,
    noIndentCheckbox: noIndentCheckbox,
    createConsumablesTransactionsUsecase: createConsumablesTransactionsUsecase,
    updateConsumablesUsecase: updateConsumablesUsecase,
    consumablesCart: consumablesCart,
  );
});

class SubmitIndentNotifier extends StateNotifier<SubmitIndentState> {
  final FuelPumpEntity? selectedFuelPump;
  final CustomerEntity? selectedCustomer;
  final VehicleEntity? selectedVehicle;
  final FuelEntity? selectedFuelType;
  final IndentBookletEntity? selectedIndentBooklet;
  final CreateIndentUsecase createIndentUsecase;
  final GetCustomerIndentUsecase getCustomerIndentUsecase;
  final UploadMeterReadingImageUsecase uploadMeterReadingImageUsecase;
  final CreateConsumablesTransactionsUsecase
      createConsumablesTransactionsUsecase;

  final UpdateConsumablesUsecase updateConsumablesUsecase;
  final File? meterReadingImage;
  final String quantity;
  final String amount;
  final String indentNumber;

  final DateTime indentDate;
  final String billNumber;

  final double totalConsumablesCost;
  final bool noIndentCheckbox;

  final List<ConsumablesCart> consumablesCart;

  SubmitIndentNotifier({
    required this.selectedFuelPump,
    required this.selectedCustomer,
    required this.selectedVehicle,
    required this.selectedFuelType,
    required this.selectedIndentBooklet,
    required this.createIndentUsecase,
    required this.getCustomerIndentUsecase,
    required this.uploadMeterReadingImageUsecase,
    this.meterReadingImage,
    required this.quantity,
    required this.amount,
    required this.indentNumber,
    required this.selectedStaff,
    required this.indentDate,
    required this.billNumber,
    required this.totalConsumablesCost,
    required this.noIndentCheckbox,
    required this.createConsumablesTransactionsUsecase,
    required this.updateConsumablesUsecase,
    required this.consumablesCart,
  }) : super(const SubmitIndentState.initial());

  ActiveStaffEntity? selectedStaff;

  String publicImageUrl = "";

  Future<void> submitIndent() async {
    state = const SubmitIndentState.submitting();

    uploadMeterReadingImage();
  }

  Future<void> uploadMeterReadingImage() async {
    if (meterReadingImage != null) {
      final result = await uploadMeterReadingImageUsecase.execute(
        file: meterReadingImage!,
      );
      result.fold(
        (failure) => state = SubmitIndentState.error(failure.message),
        (publicUrl) {
          publicImageUrl = publicUrl;
          createNewIndent();
        },
      );
    } else {
      createNewIndent();
    }
  }

  String indentId = "";

  Future<void> createNewIndent() async {
    indentId = const Uuid().v4();

    var body = {
      "id": indentId,
      "customer_id": selectedCustomer?.id ?? "",
      "vehicle_id": selectedVehicle?.id ?? "",
      "fuel_type": selectedFuelType?.fuelType ?? "",
      "amount": amount,
      "quantity": quantity,
      "discount_amount": 0,
      if (!noIndentCheckbox) "indent_number": indentNumber,
      if (!noIndentCheckbox) "booklet_id": selectedIndentBooklet?.id ?? "",
      "status": "Pending Approval",
      "approval_status": "pending",
      "source": "mobile",
      "fuel_pump_id": selectedFuelPump?.id ?? "",
      "created_by_staff_id": selectedStaff?.staffId ?? "",
      "date": indentDate.toIso8601String(),
      "consumables_amount": totalConsumablesCost.toString(),
      if (publicImageUrl.isNotEmpty) "meter_reading_image": publicImageUrl,
      if (billNumber.isNotEmpty) "bill_number": billNumber,
    };

    var result = await createIndentUsecase.execute(body: body);
    result.fold(
      (failure) => state = SubmitIndentState.error(failure.message),
      (success) {
        processConsumablesTransaction();
      },
    );
  }

  Future<void> processConsumablesTransaction() async {
    var consumablesInserts = consumablesCart.map((consumable) {
      return {
        "indent_id": indentId,
        "consumable_id": consumable.consumables.id ?? "",
        "quantity_sold": consumable.quantity,
        "unit_price": consumable.consumables.pricePerUnit,
        "total_amount":
            ((consumable.consumables.pricePerUnit ?? 0) * consumable.quantity),
        "fuel_pump_id": selectedFuelPump?.id ?? "",
      };
    }).toList();

    final result = await createConsumablesTransactionsUsecase.execute(
      body: consumablesInserts,
    );
    result.fold(
      (failure) => state = SubmitIndentState.error(failure.message),
      (success) {
        processConsumables();
      },
    );
  }

  Future<void> processConsumables() async {
    int index = 0;
    for (var consumable in consumablesCart) {
      final result = await updateConsumablesUsecase.execute(
        body: {
          "quantity":
              (consumable.consumables.quantity ?? 0) - consumable.quantity
        },
        consumableId: consumable.consumables.id ?? "",
      );
      result.fold(
        (failure) => state = SubmitIndentState.error(failure.message),
        (success) {
          if (index == consumablesCart.length - 1) {
            state = const SubmitIndentState.submitted(true);
            createIndentSuccessPopup();
          
          }
        },
      );
      index++;
    }
  }

  void reset() {
    state = const SubmitIndentState.initial();
  }
}
