import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/models/app_config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

@Riverpod(keepAlive: true)
class AppConfigNotifier extends _$AppConfigNotifier {
  AppConfig build() {
    return const AppConfig(
      apiBaseUrl: AppConstants.apiBaseUrl,
      enableLogging: true,
      timeout: Duration(seconds: 60),
    );
  }

  void updateApiBaseUrl(String newUrl) {
    state = state.copyWith(apiBaseUrl: newUrl);
  }
}
