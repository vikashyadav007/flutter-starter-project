class FuelTypeSalesEntity {
  final String volume;
  final String amount;
  final int count;

  const FuelTypeSalesEntity({
    required this.volume,
    required this.amount,
    required this.count,
  });
}

class TransactionSummaryEntity {
  final FuelTypeSalesEntity indentSales;
  final FuelTypeSalesEntity consumablesSales;
  final Map<String, FuelTypeSalesEntity> fuelTypeSales;
  final FuelTypeSalesEntity total;

  const TransactionSummaryEntity({
    required this.indentSales,
    required this.consumablesSales,
    required this.fuelTypeSales,
    required this.total,
  });
}