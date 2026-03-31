class AppAssets {
  const AppAssets._();

  static const String backgroundLoop = 'music/twinkle_lullaby_loop.wav';
  static const String laneOneNote = 'sfx/note_c.wav';
  static const String laneTwoNote = 'sfx/note_e.wav';
  static const String laneThreeNote = 'sfx/note_g.wav';
  static const String laneFourNote = 'sfx/note_a.wav';
  static const String cheer = 'sfx/cheer.wav';

  static const List<String> audioManifest = <String>[
    backgroundLoop,
    laneOneNote,
    laneTwoNote,
    laneThreeNote,
    laneFourNote,
    cheer,
  ];

  static const List<String> laneNotes = <String>[
    laneOneNote,
    laneTwoNote,
    laneThreeNote,
    laneFourNote,
  ];
}
