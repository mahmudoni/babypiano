import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/providers/bootstrap_providers.dart';
import '../../../core/widgets/soft_panel.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../data/game_progress_repository.dart';
import '../domain/game_mode.dart';
import '../domain/lane_spec.dart';
import 'widgets/lane_pad.dart';

class MemoryEchoScreen extends ConsumerStatefulWidget {
  const MemoryEchoScreen({super.key});

  static const String routePath = '/memory-echo';

  @override
  ConsumerState<MemoryEchoScreen> createState() => _MemoryEchoScreenState();
}

class _MemoryEchoScreenState extends ConsumerState<MemoryEchoScreen> {
  final Random _random = Random();

  List<int> _sequence = <int>[];
  int _inputIndex = 0;
  int? _activeLane;
  int _bestRound = 0;
  bool _isPreviewing = true;
  String? _statusText;

  @override
  void initState() {
    super.initState();
    _bestRound = ref.read(progressRepositoryProvider).readBestScore(
      GameMode.memoryEcho,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _startRound(extendSequence: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final helperText = _statusText ??
        (_isPreviewing ? l10n.memoryWatch : l10n.memoryYourTurn);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFFFAF3),
              Color(0xFFF1F0FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        l10n.memoryEchoTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => SettingsSheet.show(context),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SoftPanel(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          helperText,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _MetricBadge(
                        label: l10n.roundLabel,
                        value: _sequence.length.toString(),
                      ),
                      const SizedBox(width: 10),
                      _MetricBadge(
                        label: l10n.bestLabel,
                        value: _bestRound.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final padWidth = constraints.maxWidth >= 720
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List<Widget>.generate(
                          laneSpecs.length,
                          (int index) => SizedBox(
                            width: padWidth,
                            child: AspectRatio(
                              aspectRatio: constraints.maxWidth >= 720 ? 1.45 : 2.1,
                              child: LanePad(
                                label: laneSpecs[index].noteLabel,
                                helper: _isPreviewing
                                    ? l10n.memoryWatch
                                    : l10n.tapToPlay,
                                color: laneSpecs[index].color,
                                isActive: _activeLane == index,
                                onTap: () => _handleUserTap(index),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isPreviewing
                        ? null
                        : () => _startRound(extendSequence: false),
                    icon: const Icon(Icons.replay_rounded),
                    label: Text(l10n.replayButtonLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUserTap(int laneIndex) async {
    if (_isPreviewing || _sequence.isEmpty) {
      return;
    }

    await _flashLane(laneIndex);

    final expected = _sequence[_inputIndex];
    if (laneIndex != expected) {
      setState(() {
        _inputIndex = 0;
        _statusText = context.l10n.memoryTryAgain;
      });
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        await _startRound(extendSequence: false);
      }
      return;
    }

    if (_inputIndex == _sequence.length - 1) {
      final round = _sequence.length;
      if (round > _bestRound) {
        _bestRound = round;
        await ref.read(progressRepositoryProvider).writeBestScore(
          GameMode.memoryEcho,
          round,
        );
      }

      await ref.read(audioControllerProvider).playCheer();
      setState(() {
        _inputIndex = 0;
        _statusText = context.l10n.memorySuccess(round);
      });
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (mounted) {
        await _startRound(extendSequence: true);
      }
      return;
    }

    setState(() {
      _inputIndex += 1;
      _statusText = context.l10n.memoryYourTurn;
    });
  }

  Future<void> _startRound({required bool extendSequence}) async {
    await ref.read(audioControllerProvider).unlockAudio();

    final nextSequence = List<int>.from(_sequence);
    if (nextSequence.isEmpty || extendSequence) {
      nextSequence.add(_random.nextInt(laneSpecs.length));
    }

    setState(() {
      _sequence = nextSequence;
      _inputIndex = 0;
      _isPreviewing = true;
      _statusText = context.l10n.memoryWatch;
    });

    for (final laneIndex in _sequence) {
      await _flashLane(laneIndex);
      await Future<void>.delayed(const Duration(milliseconds: 140));
      if (!mounted) {
        return;
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isPreviewing = false;
      _statusText = context.l10n.memoryYourTurn;
    });
  }

  Future<void> _flashLane(int laneIndex) async {
    setState(() => _activeLane = laneIndex);
    await ref.read(audioControllerProvider).playLane(laneIndex);
    await Future<void>.delayed(const Duration(milliseconds: 380));
    if (mounted) {
      setState(() => _activeLane = null);
    }
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
