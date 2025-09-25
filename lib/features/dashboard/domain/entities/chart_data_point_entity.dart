class ChartDataPointEntity {
  final String name;
  final double total;
  final Map<String, dynamic> additionalData;

  const ChartDataPointEntity({
    required this.name,
    required this.total,
    required this.additionalData,
  });
}