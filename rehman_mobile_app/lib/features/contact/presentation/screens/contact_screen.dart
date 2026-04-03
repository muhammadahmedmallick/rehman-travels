import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../../../../core/providers/app_config_provider.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: AppBackButton(),
        title: Text('Contact Us', style: AppTextStyles.titleLg.copyWith(fontWeight: FontWeight.w700, color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset('assets/icons/logo.png', width: 60, height: 60, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text('Rehman Travels', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 6),
              Text('We\'re here to help you 24/7', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7))),
            ]),
          ),

          const SizedBox(height: 20),

          // Contact Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              _ContactCard(
                icon: Icons.chat_rounded,
                iconColor: const Color(0xFF25D366),
                title: 'WhatsApp',
                subtitle: 'Chat with us instantly',
                detail: config.phone,
                onTap: () => _launchUrl('https://wa.me/${config.whatsapp}?text=Hi, I need help with my booking.'),
              ),
              const SizedBox(height: 12),
              _ContactCard(
                icon: Icons.phone_rounded,
                iconColor: AppColors.primary,
                title: 'Call Us',
                subtitle: 'Speak to our travel experts',
                detail: config.phone,
                onTap: () => _launchUrl('tel:${config.phone}'),
              ),
              const SizedBox(height: 12),
              _ContactCard(
                icon: Icons.email_rounded,
                iconColor: AppColors.accent,
                title: 'Email',
                subtitle: 'Send us your queries',
                detail: config.email,
                onTap: () => _launchUrl('mailto:${config.email}?subject=Inquiry from Rehman Travel App'),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // Social Media
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Column(children: [
                Text('Follow Us', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _socialButton(Icons.facebook, const Color(0xFF1877F2), () => _launchUrl(config.facebook)),
                  const SizedBox(width: 16),
                  _socialButton(Icons.camera_alt_outlined, const Color(0xFFE4405F), () => _launchUrl(config.instagram)),
                  const SizedBox(width: 16),
                  _socialButtonText('X', Colors.black, () => _launchUrl(config.twitter)),
                  const SizedBox(width: 16),
                  _socialButton(Icons.play_circle_outline, const Color(0xFFFF0000), () => _launchUrl(config.youtube)),
                ]),
              ]),
            ),
          ),

          const SizedBox(height: 16),

          // Office Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.location_on_rounded, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Head Office', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
                const SizedBox(height: 10),
                Text(
                  '${config.officeName}\n${config.officeAddress}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Icon(Icons.access_time_rounded, size: 16, color: AppColors.textHint),
                  const SizedBox(width: 6),
                  Text(config.officeHours, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]),
              ]),
            ),
          ),

          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _socialButtonText(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Center(child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color))),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String detail;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.soft,
        ),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(detail, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: iconColor)),
          ])),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.arrow_forward_rounded, color: iconColor, size: 18),
          ),
        ]),
      ),
    );
  }
}
