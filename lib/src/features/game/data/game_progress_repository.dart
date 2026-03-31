import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/bootstrap_providers.dart';
import '../domain/game_mode.dart';

final progressRepositoryProvider = Provider<GameProgressRepository>(
  (ref) => GameProgressRepository(ref.watch(sharedPreferencesProvider)),
);

class GameProgressRepository {
  GameProgressRepository(this._preferences);

  final SharedPreferences _preferences;

  int readBestScore(GameMode mode) {
    return _preferences.getInt(_scoreKey(mode)) ?? 0;
  }

  Future<void> writeBestScore(GameMode mode, int score) async {
    await _preferences.setInt(_scoreKey(mode), score);
  }

  String _scoreKey(GameMode mode) {
    return 'best_score_${mode.storageKey}';
  }
}
