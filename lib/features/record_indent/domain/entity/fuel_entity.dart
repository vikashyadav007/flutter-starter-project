import 'package:fuel_pro_360/shared/constants/app_constants.dart';

class FuelEntity {
  String? fuelType;
  double? currentPrice;

  FuelEntity({
    this.fuelType,
    this.currentPrice,
  });

  @override
  String toString() {
    return "$fuelType (${Currency.rupee}$currentPrice/L)";
  }
}
