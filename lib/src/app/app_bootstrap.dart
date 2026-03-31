import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/config/app_environment.dart';
import '../core/providers/bootstrap_providers.dart';
import '../features/audio/application/audio_controller.dart';
import '../features/settings/data/settings_repository.dart';
import 'baby_piano_app.dart';

Future<void> bootstrapApp(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final settingsRepository = SettingsRepository(preferences);
  final initialSettings = settingsRepository.load();
  final audioController = AudioController(initialSettings: initialSettings);

  await audioController.initialize();

  FlutterError.onError = FlutterError.presentError;

  final config = AppConfig.fromEnvironment(environment);

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            sharedPreferencesProvider.overrideWithValue(preferences),
            initialSettingsProvider.overrideWithValue(initialSettings),
            audioControllerProvider.overrideWithValue(audioController),
          ],
          child: const BabyPianoApp(),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'babypiano bootstrap',
        ),
      );
    },
  );
}
