import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _expandAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
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
        // WhatsApp
        _buildMiniAction(
          label: 'WhatsApp',
          child: SvgPicture.asset('assets/icons/whatsapp.svg', width: 20, height: 20),
          color: const Color(0xFF25D366),
          onTap: () => _whatsapp(config.whatsapp),
        ),

        // Call
        _buildMiniAction(
          label: 'Call Us',
          child: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
          color: AppColors.primary,
          onTap: () => _call(config.phone),
        ),

        // Main FAB
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              // Open state stays red (close affordance); closed state
              // now matches the home hero / journey header gradient
              // so the FAB reads as part of the same visual system.
              gradient: _isOpen
                  ? const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : AppColors.heroGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (_isOpen ? const Color(0xFFEF4444) : AppColors.primary).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(_isOpen ? Icons.close_rounded : Icons.support_agent_rounded, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniAction({
    required String label,
    required Widget child,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ScaleTransition(
      scale: _expandAnimation,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: onTap,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            FadeTransition(
              opacity: _expandAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 2))],
                ),
                child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Center(child: child),
            ),
          ]),
        ),
      ),
    );
  }
}
