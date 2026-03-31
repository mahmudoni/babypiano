enum GameMode { calmTiles, freePlay, memoryEcho }

extension GameModeStorage on GameMode {
  String get storageKey => switch (this) {
    GameMode.calmTiles => 'calm_tiles',
    GameMode.freePlay => 'free_play',
    GameMode.memoryEcho => 'memory_echo',
  };
}
