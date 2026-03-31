import 'package:flutter/foundation.dart';

import '../data/game_progress_repository.dart';
import '../domain/game_mode.dart';

enum CalmCoachState { ready, nice, combo, miss, paused }

class CalmTilesHudController extends ChangeNotifier {
  CalmTilesHudController({required GameProgressRepository repository})
    : _repository = repository,
      _bestScore = repository.readBestScore(GameMode.calmTiles);

  final GameProgressRepository _repository;

  int _score = 0;
  int _combo = 0;
  int _bestScore;
  bool _isPaused = false;
  CalmCoachState _coachState = CalmCoachState.ready;

  int get score => _score;
  int get combo => _combo;
  int get bestScore => _bestScore;
  bool get isPaused => _isPaused;
  CalmCoachState get coachState => _coachState;

  void recordHit() {
    _combo += 1;
    _score += 12 + (_combo * 2);
    _coachState = _combo >= 5 ? CalmCoachState.combo : CalmCoachState.nice;

    if (_score > _bestScore) {
      _bestScore = _score;
      _repository.writeBestScore(GameMode.calmTiles, _bestScore);
    }

    notifyListeners();
  }

  void recordMiss() {
    _combo = 0;
    _coachState = CalmCoachState.miss;
    notifyListeners();
  }

  void setPaused(bool value) {
    _isPaused = value;
    _coachState = value ? CalmCoachState.paused : CalmCoachState.ready;
    notifyListeners();
  }

  void reset() {
    _score = 0;
    _combo = 0;
    _coachState = CalmCoachState.ready;
    notifyListeners();
  }
}
