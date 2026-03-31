// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Baby Piano';

  @override
  String get homeEyebrow => 'Gentle rhythm play for little hands';

  @override
  String get homeHeadline => 'A baby-friendly piano tiles game with music, memory, and no harsh fail states.';

  @override
  String get homeSubtitle => 'Start with big colorful blocks, repeat simple patterns, and let the child explore sound at a calm pace.';

  @override
  String get homeFeatureNoFail => 'No hard fail';

  @override
  String get homeFeatureBigTiles => 'Big colorful tiles';

  @override
  String get homeFeatureMemory => 'Repeat-to-remember play';

  @override
  String get homeParentNoteTitle => 'Built like a real product, softened for toddlers';

  @override
  String get homeParentNoteBody => 'The app keeps strings centralized, settings persistent, and environments separated, while the gameplay stays friendly, responsive, and low-pressure for babies and preschoolers.';

  @override
  String get settingsButtonLabel => 'Open settings';

  @override
  String get settingsTitle => 'Playback settings';

  @override
  String get settingsSubtitle => 'Keep the game calm, audible, and easy to follow on different devices.';

  @override
  String get settingsClose => 'Done';

  @override
  String get musicEnabled => 'Background music';

  @override
  String get soundEffectsEnabled => 'Piano tap sounds';

  @override
  String get laneHintsEnabled => 'Show lane hints';

  @override
  String get musicVolume => 'Music volume';

  @override
  String get soundVolume => 'Sound effects volume';

  @override
  String get speedSetting => 'Gentle speed';

  @override
  String get calmTilesTitle => 'Calm Tiles';

  @override
  String get calmTilesDescription => 'Slow falling blocks, soft speed-up, and forgiving rhythm practice inspired by classic piano tiles.';

  @override
  String get calmTilesPrimaryAction => 'Play Calm Tiles';

  @override
  String get calmTilesCoachReady => 'Tap the block when it reaches the soft glow zone.';

  @override
  String get calmTilesCoachNice => 'Nice tap. Keep following the beat.';

  @override
  String get calmTilesCoachCombo => 'Lovely rhythm. The flow is getting stronger.';

  @override
  String get calmTilesCoachMiss => 'No worries. Catch the next tile.';

  @override
  String get calmTilesHintLeft => 'Tap left lane';

  @override
  String get calmTilesHintRight => 'Tap right lane';

  @override
  String get freePlayTitle => 'Free Play';

  @override
  String get freePlayDescription => 'Large piano pads with instant sound, perfect for cause-and-effect exploration.';

  @override
  String get freePlayPrimaryAction => 'Open Free Play';

  @override
  String get freePlayHelper => 'Let the child tap any pad. Each touch gives a bright note and gentle visual feedback.';

  @override
  String get freePlayTapAny => 'Tap any colorful pad';

  @override
  String get memoryEchoTitle => 'Memory Echo';

  @override
  String get memoryEchoDescription => 'Watch a short note pattern, then tap it back from memory.';

  @override
  String get memoryEchoPrimaryAction => 'Start Memory Echo';

  @override
  String get memoryWatch => 'Watch and listen first.';

  @override
  String get memoryYourTurn => 'Now your turn. Repeat the same notes.';

  @override
  String get memoryTryAgain => 'Almost. Let\'s try the same pattern again.';

  @override
  String memorySuccess(int round) {
    return 'Round $round complete. Great memory!';
  }

  @override
  String get tapToPlay => 'Tap to play';

  @override
  String get roundLabel => 'Round';

  @override
  String get bestLabel => 'Best';

  @override
  String get scoreLabel => 'Score';

  @override
  String get comboLabel => 'Combo';

  @override
  String get pauseButtonLabel => 'Paused';

  @override
  String get pauseBody => 'Take a breath. Resume whenever the little player is ready.';

  @override
  String get resumeButtonLabel => 'Resume';

  @override
  String get replayButtonLabel => 'Replay pattern';
}
