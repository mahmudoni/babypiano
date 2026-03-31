import 'package:go_router/go_router.dart';

import '../features/game/presentation/calm_tiles_screen.dart';
import '../features/game/presentation/free_play_screen.dart';
import '../features/game/presentation/memory_echo_screen.dart';
import '../features/home/presentation/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: HomeScreen.routePath,
  routes: <RouteBase>[
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: CalmTilesScreen.routePath,
      builder: (context, state) => const CalmTilesScreen(),
    ),
    GoRoute(
      path: FreePlayScreen.routePath,
      builder: (context, state) => const FreePlayScreen(),
    ),
    GoRoute(
      path: MemoryEchoScreen.routePath,
      builder: (context, state) => const MemoryEchoScreen(),
    ),
  ],
);
