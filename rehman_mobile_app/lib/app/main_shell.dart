import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/packages/presentation/screens/packages_screen.dart';
// Visa tab is currently routed from the Home service strip (see
// `home_screen.dart`), not a dedicated bottom-nav tab. Re-import
// and re-enable VisaHomeScreen if the tab comes back.
import '../features/profile/presentation/screens/profile_screen.dart';
import 'theme.dart';
import 'widgets/contact_fab.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: const [
          HomeScreen(),
          PackagesScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: const ContactFab(),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: bottomPad > 0 ? bottomPad : 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, -2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0, selectedTab, ref),
              _buildNavItem(Icons.card_travel_outlined, Icons.card_travel, 'Packages', 1, selectedTab, ref),
              _buildNavItem(Icons.person_outline_rounded, Icons.person_rounded, 'More', 2, selectedTab, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index, int selectedTab, WidgetRef ref) {
    final isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => ref.read(selectedTabProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, size: 22, color: isActive ? AppColors.primary : AppColors.textHint),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
