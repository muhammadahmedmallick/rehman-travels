import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../app/theme.dart';
import '../providers/package_provider.dart';
import 'package_placeholder.dart';

/// Cencai-style grid tile — vertical full-bleed thumbnail with a
/// small play badge top-right (only on video packages) and an
/// `@handle` strip at the bottom-left. No rounded corners and no
/// inner padding so the 3-column grid reads as a continuous mosaic
/// of content.
class PackageGridCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onTap;

  const PackageGridCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  String _handle() {
    final raw = package.slug.split('-').take(2).join();
    final cleaned =
        raw.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    if (cleaned.isEmpty) return '@${package.packageType.toLowerCase()}';
    return '@$cleaned';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _thumbnail(),

          // Subtle bottom gradient so the @handle reads on bright
          // images. Top-right play badge has its own halo so the
          // play icon doesn't fight the image colours.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          if (package.hasVideo)
            const Positioned(
              top: 8,
              right: 8,
              child: _PlayBadge(),
            ),

          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Text(
              _handle(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 1)),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumbnail() {
    final url = package.primaryImageUrl;
    if (url == null) {
      return Container(
        color: Colors.black,
        child: PackagePlaceholder(title: package.title),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: Colors.black),
      errorWidget: (_, __, ___) => Container(
        color: Colors.black,
        child: PackagePlaceholder(title: package.title),
      ),
    );
  }
}

/// Small white circle with a play triangle, top-right corner of the
/// tile. Mirrors the Cencai grid badge.
class _PlayBadge extends StatelessWidget {
  const _PlayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.play_arrow_rounded,
        color: AppColors.primary,
        size: 16,
      ),
    );
  }
}
