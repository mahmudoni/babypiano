import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/localization_extension.dart';
import '../application/settings_controller.dart';

class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => const SettingsSheet(),
    );
  }

  @override
  ConsumerState<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<SettingsSheet> {
  late double _musicVolume;
  late double _sfxVolume;
  late double _speedMultiplier;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider);
    _musicVolume = settings.musicVolume;
    _sfxVolume = settings.sfxVolume;
    _speedMultiplier = settings.speedMultiplier;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.settingsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 20),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.musicEnabled),
            value: settings.musicEnabled,
            onChanged: controller.setMusicEnabled,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.soundEffectsEnabled),
            value: settings.sfxEnabled,
            onChanged: controller.setSfxEnabled,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.laneHintsEnabled),
            value: settings.laneHintsEnabled,
            onChanged: controller.setLaneHintsEnabled,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.musicVolume,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _musicVolume,
            onChanged: (double value) {
              setState(() => _musicVolume = value);
            },
            onChangeEnd: controller.setMusicVolume,
          ),
          Text(
            l10n.soundVolume,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _sfxVolume,
            onChanged: (double value) {
              setState(() => _sfxVolume = value);
            },
            onChangeEnd: controller.setSfxVolume,
          ),
          Text(
            l10n.speedSetting,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            min: 0.75,
            max: 1.3,
            value: _speedMultiplier,
            onChanged: (double value) {
              setState(() => _speedMultiplier = value);
            },
            onChangeEnd: controller.setSpeedMultiplier,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.settingsClose),
            ),
          ),
        ],
      ),
    );
  }
}
