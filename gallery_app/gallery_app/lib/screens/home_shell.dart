import 'package:flutter/material.dart';

import '../data/gallery_scope.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'albums_screen.dart';
import 'explore_screen.dart';
import 'photos_screen.dart';
import 'search_screen.dart';

/// Space reserved for the floating search bar and bottom navigation.
class ShellInsets {
  static double top(BuildContext c) => MediaQuery.paddingOf(c).top + 74;
  static double bottom(BuildContext c) => MediaQuery.paddingOf(c).bottom + 76;
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final repo = GalleryScope.of(context);
    final pad = MediaQuery.paddingOf(context);

    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _tab = 0);
      },
      child: Scaffold(
        body: GradientBackground(
          child: Stack(
            children: [
              if (!repo.loaded)
                const Center(child: CircularProgressIndicator())
              else
                IndexedStack(
                  index: _tab,
                  children: const [PhotosScreen(), AlbumsScreen(), ExploreScreen()],
                ),

              // Floating search bar
              Positioned(
                top: pad.top + 10,
                left: 16,
                right: 6,
                child: Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SearchScreen())),
                      child: Glass(
                        radius: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        child: Row(children: [
                          Icon(Icons.search,
                              color: GalleryColors.subtle(Theme.of(context).brightness)),
                          const SizedBox(width: 12),
                          Text('Times, places, file names…',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: GalleryColors.subtle(
                                      Theme.of(context).brightness))),
                        ]),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (v) {
                      if (v == 'refresh') repo.load();
                      if (v == 'about') {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Gallery',
                          applicationVersion: '1.0.0',
                          children: const [
                            Text('Smart tags, people and places are detected on-device. '
                                'Nothing is uploaded.'),
                          ],
                        );
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'refresh', child: Text('Refresh library')),
                      PopupMenuItem(value: 'about', child: Text('About')),
                    ],
                  ),
                ]),
              ),

              // Bottom navigation
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Glass(
                  radius: 0,
                  padding: EdgeInsets.only(bottom: pad.bottom, top: 6),
                  child: SizedBox(
                    height: 64,
                    child: Row(children: [
                      _NavItem(
                          icon: Icons.photo_outlined,
                          activeIcon: Icons.photo,
                          label: 'Photos',
                          active: _tab == 0,
                          onTap: () => setState(() => _tab = 0)),
                      _NavItem(
                          icon: Icons.photo_album_outlined,
                          activeIcon: Icons.photo_album,
                          label: 'Albums',
                          active: _tab == 1,
                          onTap: () => setState(() => _tab = 1)),
                      _NavItem(
                          icon: Icons.explore_outlined,
                          activeIcon: Icons.explore,
                          label: 'Explore',
                          active: _tab == 2,
                          onTap: () => setState(() => _tab = 2)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon, activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final color = active
        ? (b == Brightness.light ? const Color(0xFF2B2D42) : Colors.white)
        : GalleryColors.subtle(b);
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        radius: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(active ? activeIcon : icon,
                  key: ValueKey(active), color: color, size: 26),
            ),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
