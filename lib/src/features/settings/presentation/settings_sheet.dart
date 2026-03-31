import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/widgets/soft_panel.dart';
import '../application/settings_controller.dart';

class SettingsSheet extends ConsumerStatefulWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
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

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
        ),
        child: SoftPanel(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        l10n.settingsTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: l10n.settingsClose,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
          ),
        ),
      ),
    );
  }
}
