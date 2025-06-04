import 'package:starter_project/core/api/api_client.dart';
import 'package:starter_project/core/api/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ApiClient(dio);
}
