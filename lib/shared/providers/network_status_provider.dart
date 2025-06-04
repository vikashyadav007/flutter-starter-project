// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final networkStatusProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();
  Timer? disconnectionTimer;
  bool? lastEmittedStatus;

  InternetConnection().onStatusChange.listen((status) {
    final isConnected = status == InternetStatus.connected;

    if (isConnected) {
      disconnectionTimer?.cancel();
      if (lastEmittedStatus != true) {
        lastEmittedStatus = true;
        controller.add(true);
      }
    } else {
      disconnectionTimer?.cancel();
      disconnectionTimer = Timer(const Duration(seconds: 5), () {
        if (lastEmittedStatus != false) {
          lastEmittedStatus = false;
          controller.add(false);
        }
      });
    }
  });

  ref.onDispose(() {
    disconnectionTimer?.cancel();
    controller.close();
  });

  return controller.stream;
});
