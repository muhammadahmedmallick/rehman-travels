import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme.dart';
import '../providers/package_provider.dart';
import '../widgets/package_grid_card.dart';

/// Grid view of packages with a Cencai-style profile header above —
/// brand block (logo, name, post count, tagline, contact icons) on
/// top, then a 3-column grid of vertical thumbnails. Tapping a tile
/// opens the reels view at that index.
class PackageGridView extends StatelessWidget {
  final List<PackageModel> packages;
  final void Function(PackageModel) onPackageTap;
  final Future<void> Function() onRefresh;

  const PackageGridView({
    super.key,
    required this.packages,
    required this.onPackageTap,
    required this.onRefresh,
  });

  static const String _brandWhatsapp = '923345488801';
  static const String _brandWebsite = 'https://www.rehmantravel.com';
  static const String _brandEmail = 'info@rehmantravel.com';

  Future<void> _open(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Brand profile header — sits above the grid, not pinned.
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 16),
              child: _BrandHeader(
                postCount: packages.length,
                onWebsite: () => _open(Uri.parse(_brandWebsite)),
                onWhatsApp: () => _open(Uri.parse(
                    'https://wa.me/$_brandWhatsapp?text=${Uri.encodeComponent('Hi Rehman Travels! I am interested in your packages.')}')),
                onEmail: () => _open(Uri.parse(
                    'mailto:$_brandEmail?subject=Package%20enquiry')),
              ),
            ),
          ),

          // Empty state — surfaces inside the same scroll view so
          // pull-to-refresh keeps working.
          if (packages.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded,
                        size: 64, color: AppColors.textHint),
                    AppGap.md,
                    Text(
                      'No packages found',
                      style: AppTextStyles.titleMd
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.62, // tall portrait tiles
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final pkg = packages[index];
                    return PackageGridCard(
                      key: ValueKey(pkg.slug),
                      package: pkg,
                      onTap: () => onPackageTap(pkg),
                    );
                  },
                  childCount: packages.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Profile-style brand header for the grid: logo + name + post
/// count, tagline beneath, and a row of round contact icons (web,
/// WhatsApp, email).
class _BrandHeader extends StatelessWidget {
  final int postCount;
  final VoidCallback onWebsite;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const _BrandHeader({
    required this.postCount,
    required this.onWebsite,
    required this.onWhatsApp,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Brand logo — same `assets/icons/logo.png` shown on the
            // reels card avatar so the side-by-side identity stays
            // consistent across the packages feature.
            Container(
              width: 78,
              height: 78,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.flight_takeoff_rounded,
                        color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rehman Travels',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$postCount ${postCount == 1 ? 'Package' : 'Packages'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Discover travel packages across destinations.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        
      ],
    );
  }
}

class _ContactCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? tint;
  final Color? iconColor;

  const _ContactCircle({
    required this.icon,
    required this.onTap,
    this.tint,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = tint ?? AppColors.primary.withValues(alpha: 0.08);
    final fg = iconColor ?? AppColors.primary;
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: fg, size: 18),
        ),
      ),
    );
  }
}
