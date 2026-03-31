import 'package:babypiano/src/core/config/app_config.dart';
import 'package:babypiano/src/core/config/app_environment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dev config shows environment ribbon', () {
    final config = AppConfig.fromEnvironment(AppEnvironment.dev);

    expect(config.appName, 'Baby Piano Dev');
    expect(config.showEnvironmentRibbon, isTrue);
    expect(config.isProduction, isFalse);
  });

  test('prod config hides environment ribbon', () {
    final config = AppConfig.fromEnvironment(AppEnvironment.prod);

    expect(config.appName, 'Baby Piano');
    expect(config.showEnvironmentRibbon, isFalse);
    expect(config.isProduction, isTrue);
  });
}
