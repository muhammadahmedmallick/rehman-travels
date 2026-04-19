import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/package_provider.dart';
import '../providers/video_controller_provider.dart';
import '../widgets/package_reels_card.dart';

class PackageReelsView extends ConsumerStatefulWidget {
  final List<PackageModel> packages;
  final int initialIndex;

  const PackageReelsView({
    super.key,
    required this.packages,
    this.initialIndex = 0,
  });

  @override
  ConsumerState<PackageReelsView> createState() => _PackageReelsViewState();
}

class _PackageReelsViewState extends ConsumerState<PackageReelsView> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.packages.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    if (widget.packages.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ref.read(videoControllerProvider.notifier)
              .setActive(widget.packages[_currentIndex].slug);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    ref.read(videoControllerProvider.notifier).clearActive();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        ref.read(videoControllerProvider.notifier)
            .setActive(widget.packages[index].slug);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      itemCount: widget.packages.length,
      itemBuilder: (context, index) {
        final pkg = widget.packages[index];
        return PackageReelsCard(
          key: ValueKey(pkg.slug),
          package: pkg,
          isActive: index == _currentIndex,
        );
      },
    );
  }
}
