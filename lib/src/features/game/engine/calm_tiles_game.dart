import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../audio/application/audio_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/calm_tiles_hud_controller.dart';

class CalmTilesGame extends FlameGame {
  CalmTilesGame({
    required AppSettings settings,
    required CalmTilesHudController hudController,
    required AudioController audioController,
  }) : _settings = settings,
       _hudController = hudController,
       _audioController = audioController;

  static const int laneCount = 2;

  final CalmTilesHudController _hudController;
  final AudioController _audioController;
  final List<_FallingTile> _tiles = <_FallingTile>[];
  final List<double> _laneFlash = List<double>.filled(laneCount, 0);
  final List<double> _bubbleDrift = <double>[0.0, 0.8, 1.4, 2.2];
  final math.Random _random = math.Random();
  final List<int> _pattern = <int>[0, 1, 0, 1, 1, 0, 0, 1, 0, 1];

  AppSettings _settings;
  int _patternIndex = 0;
  double _spawnTimer = 0;

  @override
  Color backgroundColor() => const Color(0xFF102135);

  void applySettings(AppSettings settings) {
    _settings = settings;
  }

  int resolveLane(double xPosition) {
    final laneWidth = _laneWidth;
    for (var lane = 0; lane < laneCount; lane++) {
      final laneLeft = _laneLeft(lane);
      if (xPosition >= laneLeft && xPosition <= laneLeft + laneWidth) {
        return lane;
      }
    }

    return xPosition < size.x / 2 ? 0 : 1;
  }

  void handleLaneTap(int lane) {
    if (lane < 0 || lane >= laneCount) {
      return;
    }

    _laneFlash[lane] = 1;
    _audioController.playLane(lane);

    _FallingTile? match;
    final zoneTop = _hitZoneTop;
    for (final tile in _tiles) {
      if (tile.lane != lane || tile.isHit) {
        continue;
      }

      final distance = (tile.y - zoneTop).abs();
      if (distance < 90 || (tile.y > zoneTop - 40 && tile.y < zoneTop + 110)) {
        match = tile;
        break;
      }
    }

    if (match != null) {
      match.isHit = true;
      _hudController.recordHit();
      if (_hudController.combo % 6 == 0) {
        _audioController.playCheer();
      }
      return;
    }

    if (_tiles.any((tile) => tile.lane == lane && !tile.isHit)) {
      _hudController.recordMiss();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (size.x == 0 || size.y == 0) {
      return;
    }

    _renderBackdrop(canvas);
    _renderLanes(canvas);
    _renderTiles(canvas);
    _renderKeys(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var index = 0; index < _laneFlash.length; index++) {
      _laneFlash[index] = math.max(0, _laneFlash[index] - (dt * 3.4));
      _bubbleDrift[index] += dt * (0.7 + (index * 0.08));
    }

    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnNextTile();
      _spawnTimer = _spawnInterval;
    }

    for (final tile in _tiles) {
      if (tile.isHit) {
        tile.hitAge += dt;
        continue;
      }

      tile.y += _fallSpeed * dt;
      if (tile.y >= _hitZoneTop + 96 && !tile.missRegistered) {
        tile.missRegistered = true;
        _hudController.recordMiss();
      }
    }

    _tiles.removeWhere(
      (_FallingTile tile) =>
          tile.hitAge >= 0.18 || tile.y >= size.y + 140,
    );
  }

  double get _fallSpeed {
    return (150 + (_hudController.score * 1.15)) * _settings.speedMultiplier;
  }

  double get _spawnInterval {
    final raw = 1.14 - (_hudController.score * 0.0024);
    return raw.clamp(0.62, 1.14) / _settings.speedMultiplier;
  }

  double get _laneWidth {
    const horizontalPadding = 24.0;
    const gap = 16.0;
    final usableWidth = size.x - (horizontalPadding * 2) - gap;
    return usableWidth / laneCount;
  }

  double get _hitZoneTop => size.y - 210;

  double _laneLeft(int lane) {
    const horizontalPadding = 24.0;
    const gap = 16.0;
    return horizontalPadding + (lane * (_laneWidth + gap));
  }

  void _spawnNextTile() {
    final lane = _pattern[_patternIndex % _pattern.length];
    _patternIndex += 1;
    final randomizedOffset = _random.nextDouble() * 8;
    _tiles.add(
      _FallingTile(
        lane: lane,
        y: -120 - randomizedOffset,
      ),
    );
  }

  void _renderBackdrop(Canvas canvas) {
    final bubblePaint = Paint();
    final glowPaint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[
          Color(0xFF1B324F),
          Color(0xFF102135),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & Size(size.x, size.y));

    canvas.drawRect(
      Offset.zero & Size(size.x, size.y),
      glowPaint,
    );

    final bubblePositions = <Offset>[
      Offset(size.x * 0.2, 90 + (math.sin(_bubbleDrift[0]) * 18)),
      Offset(size.x * 0.78, 120 + (math.sin(_bubbleDrift[1]) * 26)),
      Offset(size.x * 0.52, 210 + (math.sin(_bubbleDrift[2]) * 16)),
      Offset(size.x * 0.12, 320 + (math.sin(_bubbleDrift[3]) * 14)),
    ];

    for (var index = 0; index < bubblePositions.length; index++) {
      bubblePaint.color = AppPalette.laneColors[index].withValues(alpha: 0.14);
      canvas.drawCircle(
        bubblePositions[index],
        42 + (index * 8),
        bubblePaint,
      );
    }
  }

  void _renderKeys(Canvas canvas) {
    final keyPaint = Paint();
    final keyGlowPaint = Paint();

    for (var lane = 0; lane < laneCount; lane++) {
      final laneRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          _laneLeft(lane),
          size.y - 132,
          _laneWidth,
          94,
        ),
        const Radius.circular(26),
      );

      keyGlowPaint.color = AppPalette.laneColors[lane].withValues(
        alpha: 0.18 + (_laneFlash[lane] * 0.22),
      );
      canvas.drawRRect(laneRect.inflate(6), keyGlowPaint);

      keyPaint.color = Colors.white.withValues(alpha: 0.94);
      canvas.drawRRect(laneRect, keyPaint);
    }
  }

  void _renderLanes(Canvas canvas) {
    final lanePaint = Paint();
    final zonePaint = Paint()..color = Colors.white.withValues(alpha: 0.22);

    for (var lane = 0; lane < laneCount; lane++) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          _laneLeft(lane),
          28,
          _laneWidth,
          _hitZoneTop - 44,
        ),
        const Radius.circular(28),
      );

      lanePaint.color = Colors.white.withValues(alpha: 0.06);
      canvas.drawRRect(rect, lanePaint);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            _laneLeft(lane),
            _hitZoneTop - 8,
            _laneWidth,
            18,
          ),
          const Radius.circular(999),
        ),
        zonePaint,
      );
    }
  }

  void _renderTiles(Canvas canvas) {
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.12);
    final tilePaint = Paint();

    for (final tile in _tiles) {
      final laneColor = AppPalette.laneColors[tile.lane];
      final width = _laneWidth;
      final left = _laneLeft(tile.lane);
      final opacity = tile.isHit ? (1 - (tile.hitAge / 0.18)).clamp(0.0, 1.0) : 1.0;
      final tileRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          left,
          tile.y,
          width,
          104,
        ),
        const Radius.circular(26),
      );

      canvas.drawRRect(
        tileRect.shift(const Offset(0, 10)),
        shadowPaint,
      );

      tilePaint.color = laneColor.withValues(alpha: opacity);
      canvas.drawRRect(tileRect, tilePaint);

      tilePaint.color = Colors.white.withValues(alpha: 0.22 * opacity);
      canvas.drawRRect(tileRect.deflate(10), tilePaint);
    }
  }
}

class _FallingTile {
  _FallingTile({
    required this.lane,
    required this.y,
  });

  final int lane;
  double y;
  bool isHit = false;
  bool missRegistered = false;
  double hitAge = 0;
}
