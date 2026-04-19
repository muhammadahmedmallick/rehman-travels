import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/package_provider.dart';

class PackageInfoOverlay extends StatelessWidget {
  final PackageModel package;
  const PackageInfoOverlay({super.key, required this.package});

  Future<void> _enquire() async {
    final n = package.whatsappNo ?? package.contactNo;
    if (n == null || n.isEmpty) return;
    final clean = n.split('').where((c) =>
        c == '+' || (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57)).join();
    final uri = Uri.parse(
        'https://wa.me/$clean?text=${Uri.encodeComponent('Hi, interested in "${package.title}". Please share details.')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final b = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0x66000000),
            Color(0xEE000000),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.fromLTRB(28, 96, 28, b + 96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title — regular weight (400), negative tracking → editorial feel
          Text(
            package.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
              height: 1.08,
              letterSpacing: -0.9,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if (package.location?.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(
              package.location!,
              style: const TextStyle(
                color: Color(0x80FFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 32),

          // Price + glass CTA
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (package.displayPrice.isNotEmpty)
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FROM',
                        style: TextStyle(
                          color: Color(0x55FFFFFF),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        package.displayPrice,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),

              // Glassmorphism CTA
              GestureDetector(
                onTap: _enquire,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                            width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Enquire',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_outward_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
