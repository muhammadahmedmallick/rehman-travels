import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme.dart';
import '../providers/package_provider.dart';
import '../widgets/view_toggle_button.dart';
import 'package_reels_view.dart';
import 'package_grid_view.dart';

class PackagesScreen extends ConsumerWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(packageListProvider);
    final isReels = state.viewMode == PackageViewMode.reels;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isReels ? Colors.black : AppColors.scaffoldBg,
      body: Stack(
        children: [
          _buildBody(context, ref, state),
          // Top bar only in grid mode — editorial header
          if (!isReels)
            Positioned(
              top: topPad + 16,
              left: 20,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  const ViewToggleButton(),
                ],
              ),
            ),
          // In reels: only a tiny toggle top-right
          if (isReels)
            Positioned(
              top: topPad + 10,
              right: 14,
              child: const ViewToggleButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PackageListState state) {
    if (state.isLoading) {
      final isReels = state.viewMode == PackageViewMode.reels;
      return _LoadingState(isReels: isReels);
    }

    if (state.error != null && state.packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textHint),
            AppGap.md,
            Text('Could not load packages',
                style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w600)),
            AppGap.sm,
            Text('Check your connection and try again',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary)),
            AppGap.lg,
            ElevatedButton(
              onPressed: () => ref.read(packageListProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final packages = state.filteredPackages;

    if (packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_travel_rounded, size: 64, color: AppColors.textHint),
            AppGap.md,
            Text('No packages yet',
                style: AppTextStyles.titleMd.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    if (state.viewMode == PackageViewMode.reels) {
      final initial = ref.read(initialReelIndexProvider);
      // Leave space for the bottom nav bar so video isn't clipped under it
      final navBarSpace = MediaQuery.of(context).padding.bottom + 0;
      return Padding(
        padding: EdgeInsets.only(bottom: navBarSpace),
        child: PackageReelsView(packages: packages, initialIndex: initial),
      );
    }

    return PackageGridView(
      packages: packages,
      onPackageTap: (pkg) {
        final idx = packages.indexWhere((p) => p.slug == pkg.slug);
        ref.read(initialReelIndexProvider.notifier).state = idx < 0 ? 0 : idx;
        ref.read(packageListProvider.notifier).toggleViewMode();
      },
      onRefresh: () => ref.read(packageListProvider.notifier).refresh(),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final bool isReels;
  const _LoadingState({required this.isReels});

  @override
  Widget build(BuildContext context) {
    if (isReels) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: SizedBox(
            width: 26, height: 26,
            child: CircularProgressIndicator(
              color: Colors.white38,
              strokeWidth: 1.8,
            ),
          ),
        ),
      );
    }

    final topPad = MediaQuery.of(context).padding.top;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, topPad + 90, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemCount: 6,
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: const Color(0xFFEDEEF2),
        highlightColor: const Color(0xFFF8F9FB),
        period: const Duration(milliseconds: 1400),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(width: 36, height: 6, color: Colors.white),
                const SizedBox(height: 10),
                Container(width: double.infinity, height: 10, color: Colors.white),
                const SizedBox(height: 6),
                Container(width: 80, height: 10, color: Colors.white),
                const SizedBox(height: 14),
                Container(width: 70, height: 10, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
