import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/localization_extension.dart';
import '../../../core/providers/bootstrap_providers.dart';
import '../../../core/widgets/soft_panel.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/presentation/settings_sheet.dart';
import '../domain/lane_spec.dart';
import 'widgets/lane_pad.dart';

class FreePlayScreen extends ConsumerStatefulWidget {
  const FreePlayScreen({super.key});

  static const String routePath = '/free-play';

  @override
  ConsumerState<FreePlayScreen> createState() => _FreePlayScreenState();
}

class _FreePlayScreenState extends ConsumerState<FreePlayScreen> {
  int? _activeLane;
  Timer? _clearHighlightTimer;

  @override
  void dispose() {
    _clearHighlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFFFAF2),
              Color(0xFFE8F6F3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                        l10n.freePlayTitle,
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
                const SizedBox(height: 22),
                SoftPanel(
                  child: Text(
                    l10n.freePlayHelper,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.45,
                    ),
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
                                helper: settings.laneHintsEnabled
                                    ? l10n.tapToPlay
                                    : l10n.freePlayTapAny,
                                color: laneSpecs[index].color,
                                isActive: _activeLane == index,
                                onTap: () => _playLane(index),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _playLane(int laneIndex) async {
    _clearHighlightTimer?.cancel();
    setState(() => _activeLane = laneIndex);
    _clearHighlightTimer = Timer(
      const Duration(milliseconds: 220),
      () {
        if (mounted) {
          setState(() => _activeLane = null);
        }
      },
    );

    await ref.read(audioControllerProvider).playLane(laneIndex);
  }
}
