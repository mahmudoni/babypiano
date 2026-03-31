import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/bootstrap_providers.dart';
import '../domain/app_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

class SettingsRepository {
  SettingsRepository(this._preferences);

  static const String _settingsKey = 'app_settings_v1';

  final SharedPreferences _preferences;

  AppSettings load() {
    final raw = _preferences.getString(_settingsKey);
    if (raw == null || raw.isEmpty) {
      return AppSettings.defaults;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return AppSettings.fromJson(decoded);
      }
      if (decoded is Map) {
        return AppSettings.fromJson(
          decoded.cast<String, dynamic>(),
        );
      }
    } catch (_) {
      return AppSettings.defaults;
    }

    return AppSettings.defaults;
  }

  Future<void> save(AppSettings settings) async {
    await _preferences.setString(
      _settingsKey,
      jsonEncode(settings.toJson()),
    );
  }
}
