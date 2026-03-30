import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme.dart';
import '../providers/visa_provider.dart';

class VisaDetailsScreen extends ConsumerStatefulWidget {
  final String urlLink;

  const VisaDetailsScreen({
    super.key,
    required this.urlLink,
  });

  @override
  ConsumerState<VisaDetailsScreen> createState() => _VisaDetailsScreenState();
}

class _VisaDetailsScreenState extends ConsumerState<VisaDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      ref.read(visaDetailProvider.notifier).loadVisaDetail(widget.urlLink);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isCollapsed = _scrollController.offset > 200;
    if (isCollapsed != _isCollapsed) {
      setState(() {
        _isCollapsed = isCollapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(visaDetailProvider);

    if (detailState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Visa Details',
            style: AppTextStyles.titleMd.copyWith(color: Colors.white),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (detailState.error != null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: AppColors.textHint),
                AppGap.md,
                Text(
                  'Failed to load visa details',
                  style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w600),
                ),
                AppGap.sm,
                Text(
                  detailState.error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary),
                ),
                AppGap.lg,
                ElevatedButton(
                  onPressed: () {
                    ref.read(visaDetailProvider.notifier).loadVisaDetail(widget.urlLink);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final detail = detailState.detail;
    if (detail == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _isCollapsed
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: AppIconSize.lg),
              ),
              onPressed: () => context.pop(),
            ),
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                detail.packageTitle,
                style: AppTextStyles.titleMd.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image or Gradient
                  if (detail.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: detail.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildGradientBackground(),
                      errorWidget: (context, url, error) => _buildGradientBackground(),
                    )
                  else
                    _buildGradientBackground(),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),

                  // Title Overlay
                  Positioned(
                    left: AppSpacing.lg - 4,
                    right: AppSpacing.lg - 4,
                    bottom: AppSpacing.lg - 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (detail.countryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, size: AppIconSize.sm, color: Colors.white),
                                AppGap.hXs,
                                Text(
                                  detail.countryName!,
                                  style: AppTextStyles.labelLg.copyWith(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          detail.packageTitle,
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Price card (if price > 0)
          if (detail.priceValue > 0)
            SliverToBoxAdapter(
              child: Container(
                margin: AppPadding.cardLg,
                padding: AppPadding.cardLg,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    ),
                    AppGap.hMd,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting from',
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PKR ${_formatPrice(detail.priceValue)}',
                          style: AppTextStyles.priceLg.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Description (HTML content rendered as styled text)
          if (detail.description != null && detail.description!.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                padding: AppPadding.cardLg,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: _HtmlContent(html: detail.description!),
              ),
            ),

          // Related Tour Package
          if (detail.packageUrl != null)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                padding: AppPadding.cardLg,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    AppGap.hMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${detail.displayName} Tour Package',
                            style: AppTextStyles.titleSm,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Explore tour packages',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: AppIconSize.sm,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bottom bar with Apply Now
      bottomNavigationBar: Container(
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (detail.priceValue > 0) ...[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: AppTextStyles.bodyLg.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'PKR ${_formatPrice(detail.priceValue)}',
                        style: AppTextStyles.priceLg.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                AppGap.hLg,
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to visa application
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Apply Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: const Center(
        child: Icon(Icons.article_rounded, size: 64, color: Colors.white38),
      ),
    );
  }

  String _formatPrice(double price) {
    final intPrice = price.toInt();
    return intPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// Simple HTML to styled widgets converter
class _HtmlContent extends StatelessWidget {
  final String html;

  const _HtmlContent({required this.html});

  @override
  Widget build(BuildContext context) {
    final elements = _parseHtml(html);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements,
    );
  }

  List<Widget> _parseHtml(String html) {
    final widgets = <Widget>[];

    // Remove &nbsp; and normalize whitespace
    var content = html
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    // Split by major block tags
    final blockPattern = RegExp(
      r'<(h[1-6]|p|ul|ol|h4|h3|h2|h1)(?:\s[^>]*)?>(.*?)</\1>',
      dotAll: true,
    );

    final matches = blockPattern.allMatches(content).toList();

    if (matches.isEmpty) {
      // No block tags found, just strip all tags and show as text
      final stripped = _stripTags(content).trim();
      if (stripped.isNotEmpty) {
        widgets.add(Text(
          stripped,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ));
      }
      return widgets;
    }

    for (final match in matches) {
      final tag = match.group(1)!.toLowerCase();
      final inner = match.group(2)!;

      if (tag == 'h1' || tag == 'h2') {
        final text = _stripTags(inner).trim();
        if (text.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: Text(
              text,
              style: AppTextStyles.titleLg,
            ),
          ));
        }
      } else if (tag == 'h3' || tag == 'h4') {
        final text = _stripTags(inner).trim();
        if (text.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md - 4, bottom: 6),
            child: Text(
              text,
              style: AppTextStyles.titleMd.copyWith(
                fontSize: 16,
              ),
            ),
          ));
        }
      } else if (tag == 'p') {
        final text = _stripTags(inner).trim();
        if (text.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              text,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ));
        }
      } else if (tag == 'ul' || tag == 'ol') {
        final liPattern = RegExp(r'<li(?:\s[^>]*)?>(.*?)</li>', dotAll: true);
        final items = liPattern.allMatches(inner).toList();
        for (var i = 0; i < items.length; i++) {
          final itemText = _stripTags(items[i].group(1)!).trim();
          if (itemText.isNotEmpty) {
            final bullet = tag == 'ol' ? '${i + 1}.' : '\u2022';
            widgets.add(Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      bullet,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      itemText,
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ));
          }
        }
      }
    }

    return widgets;
  }

  String _stripTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
