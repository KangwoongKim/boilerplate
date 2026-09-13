import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../design/app_chrome.dart';
import '../design/palette.dart';
import '../features/explore/presentation/explore_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter createAppRouter() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  final shellNavigatorExploreKey = GlobalKey<NavigatorState>(
    debugLabel: 'explore',
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: GlassTabBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          GlassTabDestination(
            key: Key('tab-home'),
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: '홈',
          ),
          GlassTabDestination(
            key: Key('tab-explore'),
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            label: '탐색',
          ),
        ],
      ),
    );
  }
}
