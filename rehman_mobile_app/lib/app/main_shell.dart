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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        iconSize: 22,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home_outlined, size: 22)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.home_rounded, size: 22)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.description_outlined, size: 22)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.description_rounded, size: 22)),
            label: 'Visa',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.person_outline, size: 22)),
            activeIcon: Padding(padding: EdgeInsets.only(bottom: 2), child: Icon(Icons.person, size: 22)),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
