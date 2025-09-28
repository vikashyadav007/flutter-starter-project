import 'package:intl/intl.dart';

class DashboardUtils {
  static String formatDate(DateTime date, [String pattern = 'yyyy-MM-dd']) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateRange(DateTime date, [String pattern = 'dd MMM']) {
    return DateFormat(pattern).format(date);
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static bool isValidDate(DateTime? date) {
    return date != null;
  }

  static double parseFormattedVolume(String volume) {
    // Remove 'L' and commas, then parse
    final cleanVolume = volume.replaceAll('L', '').replaceAll(',', '').trim();
    return double.tryParse(cleanVolume) ?? 0.0;
  }

  static double parseFormattedAmount(String amount) {
    // Remove '₹' symbol and commas, then parse
    final cleanAmount = amount.replaceAll('₹', '').replaceAll(',', '').trim();
    return double.tryParse(cleanAmount) ?? 0.0;
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  static String formatVolume(double volume) {
    final formatter = NumberFormat('#,##0', 'en_IN');
    return '${formatter.format(volume.round())} L';
  }

  static String normalizeFuelType(String fuelType) {
    return fuelType.toLowerCase().trim();
  }

  static String? matchFuelType(
      String readingFuelType, List<String> configuredTypes) {
    // Exact match first
    for (String configuredType in configuredTypes) {
      if (configuredType == readingFuelType) {
        return configuredType;
      }
    }

    // Normalized matching
    final normalizedReading = normalizeFuelType(readingFuelType);
    for (String configuredType in configuredTypes) {
      if (normalizeFuelType(configuredType) == normalizedReading) {
        return configuredType;
      }
    }

    // Contains matching for common fuel types
    if (normalizedReading.contains('petrol')) {
      for (String configuredType in configuredTypes) {
        if (normalizeFuelType(configuredType).contains('petrol')) {
          return configuredType;
        }
      }
    } else if (normalizedReading.contains('diesel')) {
      for (String configuredType in configuredTypes) {
        if (normalizeFuelType(configuredType).contains('diesel')) {
          return configuredType;
        }
      }
    }

    return null; // No match found
  }

  static DateTime getPreviousPeriodStart(DateTime startDate, DateTime endDate) {
    final daysDiff = endDate.difference(startDate).inDays;
    return startDate.subtract(Duration(days: daysDiff + 1));
  }

  static DateTime getPreviousPeriodEnd(DateTime startDate, DateTime endDate) {
    final daysDiff = endDate.difference(startDate).inDays;
    return endDate.subtract(Duration(days: daysDiff + 1));
  }

  static double calculateGrowthPercentage(double current, double previous) {
    if (previous <= 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  static String formatGrowthPercentage(double growthPercentage) {
    final sign = growthPercentage > 0 ? '+' : '';
    return '$sign${growthPercentage.toStringAsFixed(1)}%';
  }
}
