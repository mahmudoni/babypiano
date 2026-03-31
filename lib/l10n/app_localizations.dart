import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Baby Piano'**
  String get appName;

  /// No description provided for @homeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Calm play for little hands'**
  String get homeEyebrow;

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Simple piano play for babies.'**
  String get homeHeadline;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap bright tiles, hear soft notes, and follow easy patterns at a calm pace.'**
  String get homeSubtitle;

  /// No description provided for @homeFeatureNoFail.
  ///
  /// In en, this message translates to:
  /// **'No hard fail'**
  String get homeFeatureNoFail;

  /// No description provided for @homeFeatureBigTiles.
  ///
  /// In en, this message translates to:
  /// **'Big colorful tiles'**
  String get homeFeatureBigTiles;

  /// No description provided for @homeFeatureMemory.
  ///
  /// In en, this message translates to:
  /// **'Repeat-to-remember play'**
  String get homeFeatureMemory;

  /// No description provided for @homeParentNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Built like a real product, softened for toddlers'**
  String get homeParentNoteTitle;

  /// No description provided for @homeParentNoteBody.
  ///
  /// In en, this message translates to:
  /// **'The app keeps strings centralized, settings persistent, and environments separated, while the gameplay stays friendly, responsive, and low-pressure for babies and preschoolers.'**
  String get homeParentNoteBody;

  /// No description provided for @settingsButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsButtonLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the game calm, audible, and easy to follow on different devices.'**
  String get settingsSubtitle;

  /// No description provided for @settingsClose.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get settingsClose;

  /// No description provided for @musicEnabled.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get musicEnabled;

  /// No description provided for @soundEffectsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Piano tap sounds'**
  String get soundEffectsEnabled;

  /// No description provided for @laneHintsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Show lane hints'**
  String get laneHintsEnabled;

  /// No description provided for @musicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music volume'**
  String get musicVolume;

  /// No description provided for @soundVolume.
  ///
  /// In en, this message translates to:
  /// **'Sound effects volume'**
  String get soundVolume;

  /// No description provided for @speedSetting.
  ///
  /// In en, this message translates to:
  /// **'Gentle speed'**
  String get speedSetting;

  /// No description provided for @calmTilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm Tiles'**
  String get calmTilesTitle;

  /// No description provided for @calmTilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Slow falling blocks, soft speed-up, and forgiving rhythm practice inspired by classic piano tiles.'**
  String get calmTilesDescription;

  /// No description provided for @calmTilesPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Play Calm Tiles'**
  String get calmTilesPrimaryAction;

  /// No description provided for @calmTilesCoachReady.
  ///
  /// In en, this message translates to:
  /// **'Tap the block when it reaches the soft glow zone.'**
  String get calmTilesCoachReady;

  /// No description provided for @calmTilesCoachNice.
  ///
  /// In en, this message translates to:
  /// **'Nice tap. Keep following the beat.'**
  String get calmTilesCoachNice;

  /// No description provided for @calmTilesCoachCombo.
  ///
  /// In en, this message translates to:
  /// **'Lovely rhythm. The flow is getting stronger.'**
  String get calmTilesCoachCombo;

  /// No description provided for @calmTilesCoachMiss.
  ///
  /// In en, this message translates to:
  /// **'No worries. Catch the next tile.'**
  String get calmTilesCoachMiss;

  /// No description provided for @calmTilesHintLeft.
  ///
  /// In en, this message translates to:
  /// **'Tap left lane'**
  String get calmTilesHintLeft;

  /// No description provided for @calmTilesHintRight.
  ///
  /// In en, this message translates to:
  /// **'Tap right lane'**
  String get calmTilesHintRight;

  /// No description provided for @freePlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Play'**
  String get freePlayTitle;

  /// No description provided for @freePlayDescription.
  ///
  /// In en, this message translates to:
  /// **'Large piano pads with instant sound, perfect for cause-and-effect exploration.'**
  String get freePlayDescription;

  /// No description provided for @freePlayPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Open Free Play'**
  String get freePlayPrimaryAction;

  /// No description provided for @freePlayHelper.
  ///
  /// In en, this message translates to:
  /// **'Let the child tap any pad. Each touch gives a bright note and gentle visual feedback.'**
  String get freePlayHelper;

  /// No description provided for @freePlayTapAny.
  ///
  /// In en, this message translates to:
  /// **'Tap any colorful pad'**
  String get freePlayTapAny;

  /// No description provided for @memoryEchoTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory Echo'**
  String get memoryEchoTitle;

  /// No description provided for @memoryEchoDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch a short note pattern, then tap it back from memory.'**
  String get memoryEchoDescription;

  /// No description provided for @memoryEchoPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Start Memory Echo'**
  String get memoryEchoPrimaryAction;

  /// No description provided for @memoryWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch and listen first.'**
  String get memoryWatch;

  /// No description provided for @memoryYourTurn.
  ///
  /// In en, this message translates to:
  /// **'Now your turn. Repeat the same notes.'**
  String get memoryYourTurn;

  /// No description provided for @memoryTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Almost. Let\'s try the same pattern again.'**
  String get memoryTryAgain;

  /// No description provided for @memorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Round {round} complete. Great memory!'**
  String memorySuccess(int round);

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to play'**
  String get tapToPlay;

  /// No description provided for @roundLabel.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get roundLabel;

  /// No description provided for @bestLabel.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestLabel;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// No description provided for @comboLabel.
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get comboLabel;

  /// No description provided for @pauseButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get pauseButtonLabel;

  /// No description provided for @pauseBody.
  ///
  /// In en, this message translates to:
  /// **'Take a breath. Resume whenever the little player is ready.'**
  String get pauseBody;

  /// No description provided for @resumeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeButtonLabel;

  /// No description provided for @replayButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Replay pattern'**
  String get replayButtonLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
