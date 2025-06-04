import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'l10n.g.dart';

@riverpod
Locale locale(Ref ref) {
  return const Locale('en');
}
