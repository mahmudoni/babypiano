import 'app_environment.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.environmentLabel,
    required this.showEnvironmentRibbon,
    required this.apiBaseUrl,
  });

  factory AppConfig.fromEnvironment(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.dev => const AppConfig(
        environment: AppEnvironment.dev,
        appName: 'Baby Piano Dev',
        environmentLabel: 'DEV',
        showEnvironmentRibbon: true,
        apiBaseUrl: null,
      ),
      AppEnvironment.prod => const AppConfig(
        environment: AppEnvironment.prod,
        appName: 'Baby Piano',
        environmentLabel: 'PROD',
        showEnvironmentRibbon: false,
        apiBaseUrl: null,
      ),
    };
  }

  final AppEnvironment environment;
  final String appName;
  final String environmentLabel;
  final bool showEnvironmentRibbon;
  final String? apiBaseUrl;

  bool get isProduction => environment == AppEnvironment.prod;
}
