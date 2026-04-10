import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/visa/presentation/screens/visa_services_screen.dart';
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
          VisaServicesScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: const ContactFab(),
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: bottomPad > 0 ? bottomPad : 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0, selectedTab, ref),
              _buildNavItem(Icons.description_outlined, Icons.description_rounded, 'Visa', 1, selectedTab, ref),
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
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isActive ? 24 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(isActive ? activeIcon : icon, size: 23, color: isActive ? AppColors.primary : AppColors.textHint),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
