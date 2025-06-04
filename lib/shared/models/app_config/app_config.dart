import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String apiBaseUrl,
    required bool enableLogging,
    @Default(Duration(seconds: 30)) Duration timeout,
    @Default('en') String locale,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}
