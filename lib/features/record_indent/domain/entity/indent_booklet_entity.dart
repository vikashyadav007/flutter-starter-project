import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

class IndentBookletEntity {
  String? id;
  String? startNumber;
  String? endNumber;
  int? usedIndents;
  int? totalIndents;
  String? status;
  String? customerId;

  IndentBookletEntity({
    this.id,
    this.startNumber,
    this.endNumber,
    this.usedIndents,
    this.totalIndents,
    this.status,
    this.customerId,
  });

  int get remianingIndents => totalIndents ?? 0 - (usedIndents ?? 0);

  @override
  String toString() {
    return "$startNumber - $endNumber (${remianingIndents} remaining) - $status";
  }
}
