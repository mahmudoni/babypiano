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
              Color(0xFFFFFBF5),
              Color(0xFFF3F7FB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isWide = constraints.maxWidth >= 940;
              final horizontalPadding = constraints.maxWidth < 720 ? 20.0 : 32.0;
              final helperText = settings.laneHintsEnabled
                  ? l10n.tapToPlay
                  : l10n.freePlayTapAny;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => SettingsSheet.show(context),
                              icon: const Icon(Icons.tune_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: SoftPanel(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        l10n.freePlayHelper,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        helperText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 6,
                                child: _FreePlayPads(
                                  activeLane: _activeLane,
                                  helper: helperText,
                                  onTap: _playLane,
                                ),
                              ),
                            ],
                          )
                        else ...<Widget>[
                          SoftPanel(
                            child: Text(
                              l10n.freePlayHelper,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _FreePlayPads(
                            activeLane: _activeLane,
                            helper: helperText,
                            onTap: _playLane,
                          ),
                        ],
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

    unawaited(ref.read(audioControllerProvider).playLane(laneIndex));
  }
}

class _FreePlayPads extends StatelessWidget {
  const _FreePlayPads({
    required this.activeLane,
    required this.helper,
    required this.onTap,
  });

  final int? activeLane;
  final String helper;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: laneSpecs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.34,
        ),
        itemBuilder: (BuildContext context, int index) {
          return LanePad(
            label: laneSpecs[index].noteLabel,
            helper: helper,
            color: laneSpecs[index].color,
            isActive: activeLane == index,
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
