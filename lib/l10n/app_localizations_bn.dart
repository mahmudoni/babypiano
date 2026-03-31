// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'বেবি পিয়ানো';

  @override
  String get homeEyebrow => 'ছোট্ট হাতের জন্য নরম ছন্দের খেলা';

  @override
  String get homeHeadline => 'মিউজিক, মেমরি আর একদম soft gameplay-সহ baby-friendly piano tiles game.';

  @override
  String get homeSubtitle => 'বড় colourful block, repeat হওয়া pattern, আর শান্ত speed দিয়ে বাচ্চাকে sound explore করতে দাও।';

  @override
  String get homeFeatureNoFail => 'কঠিন game over নেই';

  @override
  String get homeFeatureBigTiles => 'বড় colourful tiles';

  @override
  String get homeFeatureMemory => 'repeat করে মনে রাখা';

  @override
  String get homeParentNoteTitle => 'Toddler-friendly feel, product-level structure';

  @override
  String get homeParentNoteBody => 'এই app-এ strings, settings, responsive layout, আর environment handling clean রাখা হয়েছে, কিন্তু gameplay রাখা হয়েছে baby-friendly, forgiving, আর low-pressure।';

  @override
  String get settingsButtonLabel => 'সেটিংস খোলো';

  @override
  String get settingsTitle => 'Play settings';

  @override
  String get settingsSubtitle => 'যে device-এই চলুক, game টাকে calm, clear, আর easy-to-follow রাখো।';

  @override
  String get settingsClose => 'ঠিক আছে';

  @override
  String get musicEnabled => 'Background music';

  @override
  String get soundEffectsEnabled => 'Piano tap sound';

  @override
  String get laneHintsEnabled => 'Lane hint দেখাও';

  @override
  String get musicVolume => 'Music volume';

  @override
  String get soundVolume => 'Sound effect volume';

  @override
  String get speedSetting => 'Gentle speed';

  @override
  String get calmTilesTitle => 'Calm Tiles';

  @override
  String get calmTilesDescription => 'Classic piano tiles idea, but slow block, soft speed-up, আর forgiving rhythm practice.';

  @override
  String get calmTilesPrimaryAction => 'Calm Tiles খেলো';

  @override
  String get calmTilesCoachReady => 'Soft glow zone-এ এলে block-এ tap করো।';

  @override
  String get calmTilesCoachNice => 'ভালো tap। Beat follow করতে থাকো।';

  @override
  String get calmTilesCoachCombo => 'দারুণ rhythm। Flow আরো smooth হচ্ছে।';

  @override
  String get calmTilesCoachMiss => 'কোন সমস্যা না। পরের tile ধরো।';

  @override
  String get calmTilesHintLeft => 'বাম lane-এ tap';

  @override
  String get calmTilesHintRight => 'ডান lane-এ tap';

  @override
  String get freePlayTitle => 'Free Play';

  @override
  String get freePlayDescription => 'বড় piano pad আর সাথে সাথে sound, cause-and-effect explore করার জন্য perfect.';

  @override
  String get freePlayPrimaryAction => 'Free Play খোলো';

  @override
  String get freePlayHelper => 'বাচ্চা যে pad-এই tap করুক, সাথে সাথে note আর soft feedback পাবে।';

  @override
  String get freePlayTapAny => 'যে কোন colorful pad-এ tap করো';

  @override
  String get memoryEchoTitle => 'Memory Echo';

  @override
  String get memoryEchoDescription => 'আগে ছোট note pattern দেখো, তারপর মনে রেখে একইটা tap করো।';

  @override
  String get memoryEchoPrimaryAction => 'Memory Echo শুরু করো';

  @override
  String get memoryWatch => 'আগে দেখো আর শোনো।';

  @override
  String get memoryYourTurn => 'এখন তোমার পালা। একই note repeat করো।';

  @override
  String get memoryTryAgain => 'হয়েই যাচ্ছে। একই pattern আরেকবার করি।';

  @override
  String memorySuccess(int round) {
    return 'Round $round complete। Memory খুব ভালো!';
  }

  @override
  String get tapToPlay => 'tap করে বাজাও';

  @override
  String get roundLabel => 'Round';

  @override
  String get bestLabel => 'Best';

  @override
  String get scoreLabel => 'Score';

  @override
  String get comboLabel => 'Combo';

  @override
  String get pauseButtonLabel => 'Pause';

  @override
  String get pauseBody => 'একটু বিরতি নাও। বাচ্চা ready হলেই আবার শুরু করো।';

  @override
  String get resumeButtonLabel => 'আবার শুরু';

  @override
  String get replayButtonLabel => 'Pattern আবার দেখাও';
}
