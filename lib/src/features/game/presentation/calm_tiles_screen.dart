import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/providers/bootstrap_providers.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/soft_panel.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../application/calm_tiles_hud_controller.dart';
import '../data/game_progress_repository.dart';
import '../engine/calm_tiles_game.dart';

class CalmTilesScreen extends ConsumerStatefulWidget {
  const CalmTilesScreen({super.key});

  static const String routePath = '/calm-tiles';

  @override
  ConsumerState<CalmTilesScreen> createState() => _CalmTilesScreenState();
}

class _CalmTilesScreenState extends ConsumerState<CalmTilesScreen> {
  late final CalmTilesHudController _hudController;
  late final CalmTilesGame _game;

  @override
  void initState() {
    super.initState();
    _hudController = CalmTilesHudController(
      repository: ref.read(progressRepositoryProvider),
    );
    _game = CalmTilesGame(
      settings: ref.read(settingsControllerProvider),
      hudController: _hudController,
      audioController: ref.read(audioControllerProvider),
    );
  }

  @override
  void dispose() {
    _hudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      settingsControllerProvider,
      (previous, next) => _game.applySettings(next),
    );

    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF102337),
              Color(0xFF18385A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isWide = constraints.maxWidth >= 1020;
              final horizontalPadding = constraints.maxWidth < 760 ? 16.0 : 24.0;

              return Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton.filledTonal(
                              onPressed: () => context.go('/'),
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.calmTilesTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: _openSettings,
                              icon: const Icon(Icons.tune_rounded),
                            ),
                            const SizedBox(width: 8),
                            AnimatedBuilder(
                              animation: _hudController,
                              builder: (BuildContext context, _) {
                                return IconButton.filled(
                                  onPressed: _togglePause,
                                  icon: Icon(
                                    _hudController.isPaused
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause_rounded,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: isWide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 320,
                                      child: _CalmTilesSidePanel(
                                        hudController: _hudController,
                                        coachText: _coachText(
                                          context,
                                          _hudController.coachState,
                                        ),
                                        laneHintsEnabled: settings.laneHintsEnabled,
                                        leftHint: l10n.calmTilesHintLeft,
                                        rightHint: l10n.calmTilesHintRight,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _GameSurface(
                                        game: _game,
                                        hudController: _hudController,
                                        settings: settings,
                                        onTogglePause: _togglePause,
                                        pauseTitle: l10n.pauseButtonLabel,
                                        pauseBody: l10n.pauseBody,
                                        resumeLabel: l10n.resumeButtonLabel,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: <Widget>[
                                    _CalmTilesTopPanel(
                                      hudController: _hudController,
                                      coachText: _coachText(
                                        context,
                                        _hudController.coachState,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: _GameSurface(
                                        game: _game,
                                        hudController: _hudController,
                                        settings: settings,
                                        onTogglePause: _togglePause,
                                        pauseTitle: l10n.pauseButtonLabel,
                                        pauseBody: l10n.pauseBody,
                                        resumeLabel: l10n.resumeButtonLabel,
                                      ),
                                    ),
                                  ],
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

  String _coachText(BuildContext context, CalmCoachState state) {
    final l10n = context.l10n;
    return switch (state) {
      CalmCoachState.ready => l10n.calmTilesCoachReady,
      CalmCoachState.nice => l10n.calmTilesCoachNice,
      CalmCoachState.combo => l10n.calmTilesCoachCombo,
      CalmCoachState.miss => l10n.calmTilesCoachMiss,
      CalmCoachState.paused => l10n.pauseBody,
    };
  }

  Future<void> _openSettings() async {
    final shouldResume = !_hudController.isPaused;
    if (shouldResume) {
      _hudController.setPaused(true);
      _game.pauseEngine();
      await ref.read(audioControllerProvider).pauseMusic();
    }

    if (!mounted) {
      return;
    }

    await SettingsSheet.show(context);

    if (!mounted || !shouldResume) {
      return;
    }

    _hudController.setPaused(false);
    _game.resumeEngine();
    await ref.read(audioControllerProvider).resumeMusic();
  }

  Future<void> _togglePause() async {
    final nextValue = !_hudController.isPaused;
    _hudController.setPaused(nextValue);
    if (nextValue) {
      _game.pauseEngine();
      await ref.read(audioControllerProvider).pauseMusic();
    } else {
      _game.resumeEngine();
      await ref.read(audioControllerProvider).resumeMusic();
    }
  }
}

class _CalmTilesTopPanel extends StatelessWidget {
  const _CalmTilesTopPanel({
    required this.hudController,
    required this.coachText,
  });

  final CalmTilesHudController hudController;
  final String coachText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: hudController,
      builder: (BuildContext context, _) {
        return Column(
          children: <Widget>[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _ScoreChip(
                  label: l10n.scoreLabel,
                  value: hudController.score.toString(),
                ),
                _ScoreChip(
                  label: l10n.comboLabel,
                  value: hudController.combo.toString(),
                ),
                _ScoreChip(
                  label: l10n.bestLabel,
                  value: hudController.bestScore.toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SoftPanel(
              color: Colors.white.withValues(alpha: 0.18),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.favorite_rounded,
                    color: AppPalette.honey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      coachText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CalmTilesSidePanel extends StatelessWidget {
  const _CalmTilesSidePanel({
    required this.hudController,
    required this.coachText,
    required this.laneHintsEnabled,
    required this.leftHint,
    required this.rightHint,
  });

  final CalmTilesHudController hudController;
  final String coachText;
  final bool laneHintsEnabled;
  final String leftHint;
  final String rightHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedBuilder(
      animation: hudController,
      builder: (BuildContext context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _ScoreChip(
                  label: l10n.scoreLabel,
                  value: hudController.score.toString(),
                ),
                _ScoreChip(
                  label: l10n.comboLabel,
                  value: hudController.combo.toString(),
                ),
                _ScoreChip(
                  label: l10n.bestLabel,
                  value: hudController.bestScore.toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SoftPanel(
              color: Colors.white.withValues(alpha: 0.18),
              child: Text(
                coachText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
            ),
            if (laneHintsEnabled) ...<Widget>[
              const SizedBox(height: 16),
              _LaneHint(
                label: leftHint,
                color: AppPalette.coral,
              ),
              const SizedBox(height: 12),
              _LaneHint(
                label: rightHint,
                color: AppPalette.teal,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _GameSurface extends StatelessWidget {
  const _GameSurface({
    required this.game,
    required this.hudController,
    required this.settings,
    required this.onTogglePause,
    required this.pauseTitle,
    required this.pauseBody,
    required this.resumeLabel,
  });

  final CalmTilesGame game;
  final CalmTilesHudController hudController;
  final AppSettings settings;
  final Future<void> Function() onTogglePause;
  final String pauseTitle;
  final String pauseBody;
  final String resumeLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          MouseRegion(
            cursor: hudController.isPaused
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (TapDownDetails details) {
                if (hudController.isPaused) {
                  return;
                }
                final lane = game.resolveLane(details.localPosition.dx);
                game.handleLaneTap(lane);
              },
              child: GameWidget<CalmTilesGame>(
                game: game,
              ),
            ),
          ),
          if (settings.laneHintsEnabled)
            Positioned(
              left: 20,
              right: 20,
              bottom: 26,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _LaneHint(
                      label: context.l10n.calmTilesHintLeft,
                      color: AppPalette.coral,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _LaneHint(
                      label: context.l10n.calmTilesHintRight,
                      color: AppPalette.teal,
                    ),
                  ),
                ],
              ),
            ),
          AnimatedBuilder(
            animation: hudController,
            builder: (BuildContext context, _) {
              if (!hudController.isPaused) {
                return const SizedBox.shrink();
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: SoftPanel(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          pauseTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pauseBody,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.45),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: onTogglePause,
                          child: Text(resumeLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LaneHint extends StatelessWidget {
  const _LaneHint({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.touch_app_rounded, color: color),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
