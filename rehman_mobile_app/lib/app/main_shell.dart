import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
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
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        snakeViewColor: AppColors.primaryDark,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.textHint,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: selectedTab,
        unselectedLabelStyle:  TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
        onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article_rounded),
            label: 'Visa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
