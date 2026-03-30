import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme.dart';
import '../providers/pak_tour_provider.dart';

class PakTourListScreen extends ConsumerStatefulWidget {
  const PakTourListScreen({super.key});

  @override
  ConsumerState<PakTourListScreen> createState() => _PakTourListScreenState();
}

class _PakTourListScreenState extends ConsumerState<PakTourListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourState = ref.watch(pakTourListProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: tourState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : tourState.error != null
                      ? _buildError(tourState.error!)
                      : _buildContent(tourState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 64, 20, 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: AppIconSize.xl,
                    ),
                  ),
                ),
                AppGap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pakistan Tours',
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Explore beautiful destinations of Pakistan',
                        style: AppTextStyles.bodyLg.copyWith(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(pakTourListProvider.notifier).setSearchQuery(value);
              },
              style: TextStyle(fontSize: AppFontSize.xl),
              decoration: InputDecoration(
                hintText: 'Search tours...',
                hintStyle: TextStyle(
                  color: AppColors.textHint,
                  fontSize: AppFontSize.xl,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: AppIconSize.lg,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          ref.read(pakTourListProvider.notifier).setSearchQuery('');
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.textHint,
                          size: AppIconSize.lg - 2,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: AppPadding.section,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.textHint,
            ),
            AppGap.md,
            Text(
              'Failed to load tours',
              style: AppTextStyles.titleMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppGap.sm,
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            ElevatedButton(
              onPressed: () => ref.read(pakTourListProvider.notifier).refresh(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PakTourListState tourState) {
    final filteredTours = tourState.filteredTours;

    return RefreshIndicator(
      onRefresh: () => ref.read(pakTourListProvider.notifier).refresh(),
      color: AppColors.primary,
      child: filteredTours.isEmpty
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        AppGap.md,
                        Text(
                          'No tours found',
                          style: AppTextStyles.titleMd.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              itemCount: filteredTours.length,
              itemBuilder: (context, index) {
                final tour = filteredTours[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _TourListCard(
                    tour: tour,
                    onTap: () => context.push('/pak-tour/details', extra: tour.urlLink),
                  ),
                );
              },
            ),
    );
  }
}

class _TourListCard extends StatelessWidget {
  final PakTourService tour;
  final VoidCallback onTap;

  const _TourListCard({
    required this.tour,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              clipBehavior: Clip.antiAlias,
              child: tour.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: tour.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(),
                      errorWidget: (context, url, error) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            AppGap.hMd,

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.packageTitle,
                    style: AppTextStyles.titleMd.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppGap.xs,
                  if (tour.durationText.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: AppIconSize.sm,
                          color: AppColors.textHint,
                        ),
                        AppGap.hXs,
                        Text(
                          tour.durationText,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (tour.routeText.isNotEmpty) ...[
                          AppGap.hMd,
                          Icon(
                            Icons.location_on_outlined,
                            size: AppIconSize.sm,
                            color: AppColors.textHint,
                          ),
                          AppGap.hXs,
                          Expanded(
                            child: Text(
                              tour.routeText,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (tour.formattedPrice.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          tour.formattedPrice,
                          style: AppTextStyles.titleSm.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                          ),
                        ),
                        if (tour.priceLabelText.isNotEmpty)
                          Text(
                            ' ${tour.priceLabelText}',
                            style: AppTextStyles.caption,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: AppIconSize.sm,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.landscape_rounded,
          size: 28,
          color: Colors.white54,
        ),
      ),
    );
  }
}
