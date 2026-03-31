import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/providers/bootstrap_providers.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/soft_panel.dart';
import '../../settings/application/settings_controller.dart';
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
              Color(0xFF11253B),
              Color(0xFF163458),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                      child: AnimatedBuilder(
                        animation: _hudController,
                        builder: (BuildContext context, _) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: <Widget>[
                              _ScoreChip(
                                label: l10n.scoreLabel,
                                value: _hudController.score.toString(),
                              ),
                              _ScoreChip(
                                label: l10n.comboLabel,
                                value: _hudController.combo.toString(),
                              ),
                              _ScoreChip(
                                label: l10n.bestLabel,
                                value: _hudController.bestScore.toString(),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
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
                AnimatedBuilder(
                  animation: _hudController,
                  builder: (BuildContext context, _) {
                    return SoftPanel(
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
                              _coachText(context, _hudController.coachState),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (TapDownDetails details) {
                            if (_hudController.isPaused) {
                              return;
                            }
                            final lane = _game.resolveLane(details.localPosition.dx);
                            _game.handleLaneTap(lane);
                          },
                          child: GameWidget<CalmTilesGame>(
                            game: _game,
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
                                    label: l10n.calmTilesHintLeft,
                                    color: AppPalette.coral,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _LaneHint(
                                    label: l10n.calmTilesHintRight,
                                    color: AppPalette.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        AnimatedBuilder(
                          animation: _hudController,
                          builder: (BuildContext context, _) {
                            if (!_hudController.isPaused) {
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
                                        l10n.pauseButtonLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.pauseBody,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(height: 1.45),
                                      ),
                                      const SizedBox(height: 18),
                                      ElevatedButton(
                                        onPressed: _togglePause,
                                        child: Text(l10n.resumeButtonLabel),
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
                  ),
                ),
              ],
            ),
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
