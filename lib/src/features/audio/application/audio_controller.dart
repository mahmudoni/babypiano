import 'package:flame_audio/flame_audio.dart';

import '../../../core/constants/app_assets.dart';
import '../../settings/domain/app_settings.dart';

class AudioController {
  AudioController({required AppSettings initialSettings})
    : _settings = initialSettings;

  final Map<int, AudioPool> _lanePools = <int, AudioPool>{};
  AudioPool? _cheerPool;

  AppSettings _settings;
  bool _initialized = false;
  bool _unlocked = false;
  bool _backgroundLoopStarted = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await FlameAudio.audioCache.loadAll(AppAssets.audioManifest);
    await FlameAudio.bgm.initialize();

    for (var index = 0; index < AppAssets.laneNotes.length; index++) {
      _lanePools[index] = await FlameAudio.createPool(
        AppAssets.laneNotes[index],
        maxPlayers: 5,
        minPlayers: 2,
      );
    }

    _cheerPool = await FlameAudio.createPool(
      AppAssets.cheer,
      maxPlayers: 2,
      minPlayers: 1,
    );

    _initialized = true;
  }

  Future<void> unlockAudio() async {
    _unlocked = true;
    await _syncBackgroundMusic();
  }

  Future<void> applySettings(AppSettings settings) async {
    _settings = settings;
    await _syncBackgroundMusic();
  }

  Future<void> playLane(int laneIndex) async {
    await unlockAudio();
    if (!_settings.sfxEnabled) {
      return;
    }

    final pool = _lanePools[laneIndex % AppAssets.laneNotes.length];
    await pool?.start(volume: _sfxVolume);
  }

  Future<void> playCheer() async {
    await unlockAudio();
    if (!_settings.sfxEnabled) {
      return;
    }

    await _cheerPool?.start(volume: (_sfxVolume * 0.9).clamp(0.0, 1.0));
  }

  Future<void> pauseMusic() async {
    await FlameAudio.bgm.pause();
  }

  Future<void> resumeMusic() async {
    await _syncBackgroundMusic();
    if (_backgroundLoopStarted && FlameAudio.bgm.audioPlayer.state == PlayerState.paused) {
      await FlameAudio.bgm.resume();
    }
  }

  Future<void> dispose() async {
    await Future.wait<void>(<Future<void>>[
      FlameAudio.bgm.dispose(),
      ..._lanePools.values.map((AudioPool pool) => pool.dispose()),
      if (_cheerPool != null) _cheerPool!.dispose(),
    ]);
  }

  double get _musicVolume => (_settings.musicVolume * 0.42).clamp(0.0, 1.0);
  double get _sfxVolume => _settings.sfxVolume.clamp(0.0, 1.0);

  Future<void> _syncBackgroundMusic() async {
    if (!_initialized) {
      return;
    }

    if (!_unlocked || !_settings.musicEnabled) {
      if (_backgroundLoopStarted) {
        await FlameAudio.bgm.stop();
        _backgroundLoopStarted = false;
      }
      return;
    }

    if (_backgroundLoopStarted) {
      await FlameAudio.bgm.audioPlayer.setVolume(_musicVolume);
      return;
    }

    await FlameAudio.bgm.play(
      AppAssets.backgroundLoop,
      volume: _musicVolume,
    );
    _backgroundLoopStarted = true;
  }
}
