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
