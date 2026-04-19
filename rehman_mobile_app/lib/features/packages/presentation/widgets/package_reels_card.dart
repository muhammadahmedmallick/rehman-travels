import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/package_provider.dart';
import 'package_video_player.dart';
import 'package_placeholder.dart';

class PackageReelsCard extends StatelessWidget {
  final PackageModel package;
  final bool isActive;

  const PackageReelsCard({
    super.key,
    required this.package,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    if (package.hasVideo) {
      return PackageVideoPlayer(package: package, isActive: isActive);
    }
    final banner = package.fullBannerUrl;
    if (banner != null) {
      return CachedNetworkImage(
        imageUrl: banner,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(color: Colors.black),
        errorWidget: (_, _, _) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    final thumb = package.fullThumbnailUrl;
    if (thumb != null) {
      return CachedNetworkImage(
        imageUrl: thumb,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(color: Colors.black),
        errorWidget: (_, _, _) => PackagePlaceholder(title: package.title),
      );
    }
    return PackagePlaceholder(title: package.title);
  }
}
