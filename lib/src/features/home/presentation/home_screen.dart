import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/providers/bootstrap_providers.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/soft_panel.dart';
import '../../game/presentation/calm_tiles_screen.dart';
import '../../game/presentation/free_play_screen.dart';
import '../../game/presentation/memory_echo_screen.dart';
import '../../game/presentation/widgets/game_mode_card.dart';
import '../../settings/presentation/settings_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final config = ref.watch(appConfigProvider);
    final audioController = ref.read(audioControllerProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFFFCF7),
              Color(0xFFF4F7FB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isCompact = constraints.maxWidth < 760;
              final isWide = constraints.maxWidth >= 1080;
              final horizontalPadding = isCompact ? 20.0 : 32.0;
              final contentWidth = constraints.maxWidth - (horizontalPadding * 2);
              final cardWidth = contentWidth >= 720
                  ? (contentWidth - 20) / 2
                  : contentWidth;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    l10n.appName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  if (!config.isProduction) ...<Widget>[
                                    const SizedBox(width: 12),
                                    Chip(
                                      label: Text(config.environmentLabel),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => SettingsSheet.show(context),
                              tooltip: l10n.settingsButtonLabel,
                              icon: const Icon(Icons.tune_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SoftPanel(
                          padding: EdgeInsets.all(isCompact ? 24 : 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                l10n.homeEyebrow,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppPalette.teal,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.homeHeadline,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.homeSubtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(height: 1.45),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: <Widget>[
                                  _FeatureChip(label: l10n.homeFeatureNoFail),
                                  _FeatureChip(label: l10n.homeFeatureBigTiles),
                                  _FeatureChip(label: l10n.homeFeatureMemory),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (isWide)
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Expanded(
                                  child: GameModeCard(
                                    title: l10n.calmTilesTitle,
                                    description: l10n.calmTilesDescription,
                                    buttonLabel: l10n.calmTilesPrimaryAction,
                                    icon: Icons.view_stream_rounded,
                                    accentColor: AppPalette.coral,
                                    onPressed: () async {
                                      await audioController.unlockAudio();
                                      if (!context.mounted) {
                                        return;
                                      }
                                      context.go(CalmTilesScreen.routePath);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: GameModeCard(
                                    title: l10n.freePlayTitle,
                                    description: l10n.freePlayDescription,
                                    buttonLabel: l10n.freePlayPrimaryAction,
                                    icon: Icons.piano_rounded,
                                    accentColor: AppPalette.teal,
                                    onPressed: () async {
                                      await audioController.unlockAudio();
                                      if (!context.mounted) {
                                        return;
                                      }
                                      context.go(FreePlayScreen.routePath);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: GameModeCard(
                                    title: l10n.memoryEchoTitle,
                                    description: l10n.memoryEchoDescription,
                                    buttonLabel: l10n.memoryEchoPrimaryAction,
                                    icon: Icons.psychology_alt_rounded,
                                    accentColor: AppPalette.honey,
                                    onPressed: () async {
                                      await audioController.unlockAudio();
                                      if (!context.mounted) {
                                        return;
                                      }
                                      context.go(MemoryEchoScreen.routePath);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: <Widget>[
                              SizedBox(
                                width: cardWidth,
                                child: GameModeCard(
                                  title: l10n.calmTilesTitle,
                                  description: l10n.calmTilesDescription,
                                  buttonLabel: l10n.calmTilesPrimaryAction,
                                  icon: Icons.view_stream_rounded,
                                  accentColor: AppPalette.coral,
                                  onPressed: () async {
                                    await audioController.unlockAudio();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    context.go(CalmTilesScreen.routePath);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: GameModeCard(
                                  title: l10n.freePlayTitle,
                                  description: l10n.freePlayDescription,
                                  buttonLabel: l10n.freePlayPrimaryAction,
                                  icon: Icons.piano_rounded,
                                  accentColor: AppPalette.teal,
                                  onPressed: () async {
                                    await audioController.unlockAudio();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    context.go(FreePlayScreen.routePath);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: cardWidth,
                                child: GameModeCard(
                                  title: l10n.memoryEchoTitle,
                                  description: l10n.memoryEchoDescription,
                                  buttonLabel: l10n.memoryEchoPrimaryAction,
                                  icon: Icons.psychology_alt_rounded,
                                  accentColor: AppPalette.honey,
                                  onPressed: () async {
                                    await audioController.unlockAudio();
                                    if (!context.mounted) {
                                      return;
                                    }
                                    context.go(MemoryEchoScreen.routePath);
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            l10n.homeParentNoteBody,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF607080),
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7EBF1)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
      ),
    );
  }
}
