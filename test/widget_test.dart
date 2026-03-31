import 'package:babypiano/src/app/baby_piano_app.dart';
import 'package:babypiano/src/core/config/app_config.dart';
import 'package:babypiano/src/core/config/app_environment.dart';
import 'package:babypiano/src/core/providers/bootstrap_providers.dart';
import 'package:babypiano/src/features/audio/application/audio_controller.dart';
import 'package:babypiano/src/features/settings/domain/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home screen renders core mode titles', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig.fromEnvironment(AppEnvironment.dev),
          ),
          sharedPreferencesProvider.overrideWithValue(preferences),
          initialSettingsProvider.overrideWithValue(AppSettings.defaults),
          audioControllerProvider.overrideWithValue(
            AudioController(initialSettings: AppSettings.defaults),
          ),
        ],
        child: const BabyPianoApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Calm Tiles'), findsOneWidget);
    expect(find.text('Free Play'), findsOneWidget);
    expect(find.text('Memory Echo'), findsOneWidget);
  });
}
