class AppSettings {
  const AppSettings({
    required this.musicEnabled,
    required this.sfxEnabled,
    required this.laneHintsEnabled,
    required this.musicVolume,
    required this.sfxVolume,
    required this.speedMultiplier,
  });

  static const AppSettings defaults = AppSettings(
    musicEnabled: true,
    sfxEnabled: true,
    laneHintsEnabled: true,
    musicVolume: 0.34,
    sfxVolume: 0.72,
    speedMultiplier: 0.94,
  );

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      musicEnabled: json['musicEnabled'] as bool? ?? defaults.musicEnabled,
      sfxEnabled: json['sfxEnabled'] as bool? ?? defaults.sfxEnabled,
      laneHintsEnabled:
          json['laneHintsEnabled'] as bool? ?? defaults.laneHintsEnabled,
      musicVolume: _clampUnitDouble(
        json['musicVolume'],
        defaults.musicVolume,
      ),
      sfxVolume: _clampUnitDouble(
        json['sfxVolume'],
        defaults.sfxVolume,
      ),
      speedMultiplier: _clampRangeDouble(
        json['speedMultiplier'],
        defaults.speedMultiplier,
        min: 0.75,
        max: 1.3,
      ),
    );
  }

  final bool musicEnabled;
  final bool sfxEnabled;
  final bool laneHintsEnabled;
  final double musicVolume;
  final double sfxVolume;
  final double speedMultiplier;

  AppSettings copyWith({
    bool? musicEnabled,
    bool? sfxEnabled,
    bool? laneHintsEnabled,
    double? musicVolume,
    double? sfxVolume,
    double? speedMultiplier,
  }) {
    return AppSettings(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      laneHintsEnabled: laneHintsEnabled ?? this.laneHintsEnabled,
      musicVolume: _clampUnitDouble(
        musicVolume,
        this.musicVolume,
      ),
      sfxVolume: _clampUnitDouble(
        sfxVolume,
        this.sfxVolume,
      ),
      speedMultiplier: _clampRangeDouble(
        speedMultiplier,
        this.speedMultiplier,
        min: 0.75,
        max: 1.3,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'musicEnabled': musicEnabled,
      'sfxEnabled': sfxEnabled,
      'laneHintsEnabled': laneHintsEnabled,
      'musicVolume': musicVolume,
      'sfxVolume': sfxVolume,
      'speedMultiplier': speedMultiplier,
    };
  }

  static double _clampUnitDouble(Object? value, double fallback) {
    if (value is num) {
      return value.toDouble().clamp(0.0, 1.0);
    }

    return fallback;
  }

  static double _clampRangeDouble(
    Object? value,
    double fallback, {
    required double min,
    required double max,
  }) {
    if (value is num) {
      return value.toDouble().clamp(min, max);
    }

    return fallback;
  }
}
