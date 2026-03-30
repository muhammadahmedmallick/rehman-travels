import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme.dart';
import '../providers/visa_provider.dart';

class VisaServicesScreen extends ConsumerStatefulWidget {
  const VisaServicesScreen({super.key});

  @override
  ConsumerState<VisaServicesScreen> createState() => _VisaServicesScreenState();
}

class _VisaServicesScreenState extends ConsumerState<VisaServicesScreen> {
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
    final visaState = ref.watch(visaListProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: visaState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : visaState.error != null
                      ? _buildError(visaState.error!)
                      : _buildContent(visaState),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.article_rounded,
                    color: AppColors.primary,
                    size: AppIconSize.xl,
                  ),
                ),
                AppGap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visa Services',
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Easy visa processing for all countries',
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
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                ref.read(visaListProvider.notifier).setSearchQuery(value);
              },
              style: TextStyle(fontSize: AppFontSize.xl),
              decoration: InputDecoration(
                hintText: 'Search visa service...',
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
                          ref.read(visaListProvider.notifier).setSearchQuery('');
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
              'Failed to load visa services',
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
              onPressed: () => ref.read(visaListProvider.notifier).refresh(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(VisaListState visaState) {
    final filteredVisas = visaState.filteredVisas;

    return RefreshIndicator(
      onRefresh: () => ref.read(visaListProvider.notifier).refresh(),
      color: AppColors.primary,
      child: filteredVisas.isEmpty
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
                          'No visa services found',
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
              itemCount: filteredVisas.length,
              itemBuilder: (context, index) {
                final visa = filteredVisas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _VisaListCard(
                    visa: visa,
                    onTap: () => _navigateToDetails(visa),
                  ),
                );
              },
            ),
    );
  }

  void _navigateToDetails(VisaService visa) {
    context.push('/visa/details', extra: visa.urlLink);
  }
}

class _VisaListCard extends StatelessWidget {
  final VisaService visa;
  final VoidCallback onTap;

  const _VisaListCard({
    required this.visa,
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
            // Image or icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              clipBehavior: Clip.antiAlias,
              child: visa.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: visa.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: Icon(
                          Icons.article_rounded,
                          color: AppColors.primary,
                          size: AppIconSize.xl,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.article_rounded,
                          color: AppColors.primary,
                          size: AppIconSize.xl,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.article_rounded,
                        color: AppColors.primary,
                        size: AppIconSize.xl,
                      ),
                    ),
            ),
            AppGap.hMd,

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visa.packageTitle,
                    style: AppTextStyles.titleMd.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (visa.countryName != null) ...[
                    AppGap.xs,
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppIconSize.sm,
                          color: AppColors.textHint,
                        ),
                        AppGap.hXs,
                        Text(
                          visa.countryName!,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Arrow
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
}
