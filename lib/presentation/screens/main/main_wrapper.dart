import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainWrapper extends ConsumerWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: isTablet 
        ? Row(
            children: [
              _buildSideNav(context),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: child),
            ],
          )
        : child,
      bottomNavigationBar: isTablet ? null : _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    if (location == '/matches') currentIndex = 1;
    if (location == '/profile') currentIndex = 2;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (idx) {
        if (idx == 0) context.go('/');
        if (idx == 1) context.go('/matches');
        if (idx == 2) context.go('/profile');
      },
      elevation: 4.0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite, color: Colors.pinkAccent),
          label: 'Swipe',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble, color: Colors.pinkAccent),
          label: 'Matches',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Colors.pinkAccent),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildSideNav(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = 0;
    if (location == '/matches') currentIndex = 1;
    if (location == '/profile') currentIndex = 2;

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (idx) {
        if (idx == 0) context.go('/');
        if (idx == 1) context.go('/matches');
        if (idx == 2) context.go('/profile');
      },
      extended: true,
      minExtendedWidth: 150,
      labelType: NavigationRailLabelType.none,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Icon(Icons.favorite, size: 40, color: Colors.pinkAccent.shade200),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: Text('Swipe'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: Text('Matches'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
