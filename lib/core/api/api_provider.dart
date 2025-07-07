import 'package:fuel_pro_360/core/api/api_client.dart';
import 'package:fuel_pro_360/core/api/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ApiClient(dio);
}
