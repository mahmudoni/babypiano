import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';

class LaneSpec {
  const LaneSpec({
    required this.noteLabel,
    required this.color,
  });

  final String noteLabel;
  final Color color;
}

const List<LaneSpec> laneSpecs = <LaneSpec>[
  LaneSpec(noteLabel: 'Do', color: AppPalette.coral),
  LaneSpec(noteLabel: 'Re', color: AppPalette.teal),
  LaneSpec(noteLabel: 'Mi', color: AppPalette.honey),
  LaneSpec(noteLabel: 'So', color: AppPalette.lilac),
];
