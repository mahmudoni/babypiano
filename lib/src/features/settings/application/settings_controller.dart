import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/bootstrap_providers.dart';
import '../../audio/application/audio_controller.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

class SettingsController extends Notifier<AppSettings> {
  late final SettingsRepository _repository =
      ref.read(settingsRepositoryProvider);
  late final AudioController _audioController =
      ref.read(audioControllerProvider);

  @override
  AppSettings build() {
    return ref.watch(initialSettingsProvider);
  }

  Future<void> setMusicEnabled(bool value) async {
    await _save(state.copyWith(musicEnabled: value));
  }

  Future<void> setSfxEnabled(bool value) async {
    await _save(state.copyWith(sfxEnabled: value));
  }

  Future<void> setLaneHintsEnabled(bool value) async {
    await _save(state.copyWith(laneHintsEnabled: value));
  }

  Future<void> setMusicVolume(double value) async {
    await _save(state.copyWith(musicVolume: value));
  }

  Future<void> setSfxVolume(double value) async {
    await _save(state.copyWith(sfxVolume: value));
  }

  Future<void> setSpeedMultiplier(double value) async {
    await _save(state.copyWith(speedMultiplier: value));
  }

  Future<void> _save(AppSettings nextState) async {
    state = nextState;
    await _repository.save(nextState);
    await _audioController.applySettings(nextState);
  }
}
