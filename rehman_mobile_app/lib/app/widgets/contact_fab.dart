import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/providers/app_config_provider.dart';
import '../theme.dart';

class ContactFab extends ConsumerStatefulWidget {
  const ContactFab({super.key});

  @override
  ConsumerState<ContactFab> createState() => _ContactFabState();
}

class _ContactFabState extends ConsumerState<ContactFab> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  Future<void> _call(String phone) async {
    _toggle();
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String whatsapp) async {
    _toggle();
    final uri = Uri.parse('https://wa.me/$whatsapp?text=Hi, I need help with my booking.');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // WhatsApp button
        ScaleTransition(
          scale: _expandAnimation,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              FadeTransition(
                opacity: _expandAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: AppShadows.soft),
                  child: const Text('WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                heroTag: 'fab_whatsapp',
                backgroundColor: const Color(0xFF25D366),
                onPressed: () => _whatsapp(config.whatsapp),
                child: const Icon(Icons.chat, color: Colors.white, size: 20),
              ),
            ]),
          ),
        ),

        // Call button
        ScaleTransition(
          scale: _expandAnimation,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              FadeTransition(
                opacity: _expandAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: AppShadows.soft),
                  child: const Text('Call Us', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                heroTag: 'fab_call',
                backgroundColor: AppColors.primary,
                onPressed: () => _call(config.phone),
                child: const Icon(Icons.phone, color: Colors.white, size: 20),
              ),
            ]),
          ),
        ),

        // Main FAB
        FloatingActionButton(
          heroTag: 'fab_main',
          backgroundColor: AppColors.primary,
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(Icons.support_agent, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}
