import 'package:babypiano/src/features/settings/data/settings_repository.dart';
import 'package:babypiano/src/features/settings/domain/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('repository persists and restores settings', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final repository = SettingsRepository(preferences);

    const savedSettings = AppSettings(
      musicEnabled: false,
      sfxEnabled: true,
      laneHintsEnabled: false,
      musicVolume: 0.2,
      sfxVolume: 0.6,
      speedMultiplier: 1.1,
    );

    await repository.save(savedSettings);
    final restored = repository.load();

    expect(restored.musicEnabled, isFalse);
    expect(restored.sfxEnabled, isTrue);
    expect(restored.laneHintsEnabled, isFalse);
    expect(restored.musicVolume, 0.2);
    expect(restored.sfxVolume, 0.6);
    expect(restored.speedMultiplier, 1.1);
  });

  test('settings clamp unsupported values to safe ranges', () {
    final settings = AppSettings.fromJson(<String, Object>{
      'musicVolume': 8,
      'sfxVolume': -2,
      'speedMultiplier': 99,
    });

    expect(settings.musicVolume, 1);
    expect(settings.sfxVolume, 0);
    expect(settings.speedMultiplier, 1.3);
  });
}
