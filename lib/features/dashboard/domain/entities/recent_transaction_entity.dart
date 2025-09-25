class RecentTransactionEntity {
  final String id;
  final String fuelType;
  final double amount;
  final DateTime createdAt;
  final double quantity;

  const RecentTransactionEntity({
    required this.id,
    required this.fuelType,
    required this.amount,
    required this.createdAt,
    required this.quantity,
  });
}