import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/audio/application/audio_controller.dart';
import '../../features/settings/domain/app_settings.dart';
import '../config/app_config.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider must be overridden'),
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

final initialSettingsProvider = Provider<AppSettings>(
  (ref) => AppSettings.defaults,
);

final audioControllerProvider = Provider<AudioController>(
  (ref) => throw UnimplementedError('audioControllerProvider must be overridden'),
);
