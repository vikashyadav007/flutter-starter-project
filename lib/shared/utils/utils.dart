import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

Future<void> launchUrlString(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

String generateRandomString() {
  return const Uuid().v4();
}

String formatDate(
    {required String dateTimeString, String dateFormat = 'yyyy-MM-dd'}) {
  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();

  return DateFormat(dateFormat).format(dateTime);
}

String getCommaSeperatedNumber({required int number}) {
  return NumberFormat("#,##0").format(number);
}

String getCommaSeperatedNumberDouble({required double number}) {
  return NumberFormat("#,##0.##").format(number);
}

Future<XFile> compressAndGetImageFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 50,
  );

  return result!;
}

// Helper: check if a string is numeric
bool isNumeric(String s) => int.tryParse(s) != null;

// Helper: parse alphanumeric string into prefix and numeric suffix
Map<String, dynamic>? parseAlphanumeric(String str) {
  final regex = RegExp(r'^([A-Za-z]*)(\d+)$');
  final match = regex.firstMatch(str);
  if (match != null) {
    return {
      'prefix': match.group(1),
      'number': int.parse(match.group(2)!),
    };
  }
  return null;
}

bool isInRange(
    {required String value, required String start, required String end}) {
  // Numeric comparison
  if (isNumeric(value) && isNumeric(start) && isNumeric(end)) {
    final val = int.parse(value);
    final startVal = int.parse(start);
    final endVal = int.parse(end);
    return val >= startVal && val <= endVal;
  }

  // Alphanumeric comparison
  final valueParts = parseAlphanumeric(value);
  final startParts = parseAlphanumeric(start);
  final endParts = parseAlphanumeric(end);

  if (valueParts != null && startParts != null && endParts != null) {
    final prefix = valueParts['prefix'];
    if (prefix == startParts['prefix'] && prefix == endParts['prefix']) {
      final valNum = valueParts['number'];
      final startNum = startParts['number'];
      final endNum = endParts['number'];
      return valNum >= startNum && valNum <= endNum;
    }
  }

  // Fallback to lexicographic comparison
  return value.compareTo(start) >= 0 && value.compareTo(end) <= 0;
}
