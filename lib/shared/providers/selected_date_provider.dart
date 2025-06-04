import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) {
  return SelectedDateNotifier();
});

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now()) {
    final now = DateTime.now();
    DateTime time;
    if (now.day <= 10) {
      time = DateTime(now.year, now.month, 1);
    } else {
      time = DateTime(now.year, now.month + 1, 1);
    }
    state = time;
  }

  void setSelectedDate(DateTime date) {
    state = date;
  }
}
