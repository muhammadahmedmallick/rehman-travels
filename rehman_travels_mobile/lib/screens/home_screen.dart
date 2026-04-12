import 'package:flutter/material.dart';
import '../models/menu_models.dart';
import '../widgets/umrah_dropdown.dart';

/// Home screen with Umrah navigation menu
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _handleMenuItemSelected(BuildContext context, MenuItem item) {
    if (item.type == 'calculator') {
      // Navigate to calculator screen
      Navigator.of(context).pushNamed('/calculator');
    } else {
      // Navigate to package detail screen
      final slug = item.url.split('/').last;
      Navigator.of(context).pushNamed(
        '/package-detail',
        arguments: {'slug': slug},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rehman Travels',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF1a73e8),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with branding
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1a73e8),
                    Color(0xFF1557b0),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.card_travel,
                      size: 48,
                      color: Color(0xFF1a73e8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Umrah Booking System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore packages and plan your journey',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Menu section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select an option below',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 16),
                  UmrahDropdownButtonWidget(
                    onItemSelected: (item) {
                      _handleMenuItemSelected(context, item);
                    },
                  ),
                  const SizedBox(height: 32),
                  // Quick access cards
                  _buildQuickAccessSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202124),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _QuickAccessCard(
              icon: Icons.calculate,
              title: 'Calculator',
              onTap: () {
                Navigator.of(context).pushNamed('/calculator');
              },
            ),
            _QuickAccessCard(
              icon: Icons.card_giftcard,
              title: 'Packages',
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/package-detail',
                  arguments: {'slug': 'economy'},
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickAccessCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDADCE0)),
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF8F9FA),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: const Color(0xFF1a73e8),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202124),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
