import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../providers/pak_tour_provider.dart';

class PakTourDetailScreen extends ConsumerStatefulWidget {
  final String urlLink;

  const PakTourDetailScreen({
    super.key,
    required this.urlLink,
  });

  @override
  ConsumerState<PakTourDetailScreen> createState() => _PakTourDetailScreenState();
}

class _PakTourDetailScreenState extends ConsumerState<PakTourDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      ref.read(pakTourDetailProvider.notifier).loadTourDetail(widget.urlLink);
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
    final detailState = ref.watch(pakTourDetailProvider);

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
            'Tour Details',
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
                  'Failed to load tour details',
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
                    ref.read(pakTourDetailProvider.notifier).loadTourDetail(widget.urlLink);
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
                  if (detail.imageUrl != null)
                    CachedNetworkImage(
                      imageUrl: detail.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildGradientBackground(),
                      errorWidget: (context, url, error) => _buildGradientBackground(),
                    )
                  else
                    _buildGradientBackground(),
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
                  Positioned(
                    left: AppSpacing.lg - 4,
                    right: AppSpacing.lg - 4,
                    bottom: AppSpacing.lg - 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (detail.durationText.isNotEmpty)
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
                                const Icon(Icons.schedule, size: AppIconSize.sm, color: Colors.white),
                                AppGap.hXs,
                                Text(
                                  detail.durationText,
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

          // Price card
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.priceLabelText.isNotEmpty
                                ? 'Price ${detail.priceLabelText}'
                                : 'Starting from',
                            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              if (detail.discountPriceValue > 0) ...[
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.discountPriceValue)}',
                                  style: AppTextStyles.priceLg.copyWith(fontSize: 20),
                                ),
                                AppGap.hSm,
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.priceValue)}',
                                  style: AppTextStyles.bodyLg.copyWith(
                                    color: AppColors.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ] else
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.priceValue)}',
                                  style: AppTextStyles.priceLg.copyWith(fontSize: 20),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Tour Info Grid
          SliverToBoxAdapter(
            child: _buildTourInfoGrid(detail),
          ),

          // Description
          if (detail.description != null && detail.description!.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection('Description', detail.description!),
            ),

          // Itinerary / Days Details
          if (detail.daysDetails != null && detail.daysDetails!.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection('Itinerary', detail.daysDetails!),
            ),

          // Includes
          if (detail.includes != null && detail.includes!.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection('Includes', detail.includes!),
            ),

          // Excludes
          if (detail.excludes != null && detail.excludes!.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection('Excludes', detail.excludes!),
            ),

          // Tour Services
          if (detail.tourServices != null && detail.tourServices!.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildSection('Tour Services', detail.tourServices!),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bottom bar with Book Now
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
                        '${detail.currencyType} ${_formatPrice(detail.discountPriceValue > 0 ? detail.discountPriceValue : detail.priceValue)}',
                        style: AppTextStyles.priceLg.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                AppGap.hLg,
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _openWhatsApp(detail),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTourInfoGrid(PakTourDetail detail) {
    final items = <_InfoItem>[];

    if (detail.durationText.isNotEmpty) {
      items.add(_InfoItem(
        icon: Icons.schedule,
        label: 'Duration',
        value: detail.durationText,
      ));
    }
    if (detail.tourAvailability != null) {
      items.add(_InfoItem(
        icon: Icons.calendar_today,
        label: 'Availability',
        value: detail.tourAvailability!,
      ));
    }
    if (detail.departureLocation != null) {
      items.add(_InfoItem(
        icon: Icons.flight_takeoff,
        label: 'Departure',
        value: detail.departureLocation!,
      ));
    }
    if (detail.destinationLocation != null) {
      items.add(_InfoItem(
        icon: Icons.location_on,
        label: 'Destination',
        value: detail.destinationLocation!,
      ));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: items.map((item) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 76) / 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(item.icon, size: AppIconSize.lg - 2, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        item.value,
                        style: AppTextStyles.labelLg.copyWith(
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, String htmlContent) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMd.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppGap.sm,
          _HtmlContent(html: htmlContent),
        ],
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
        child: Icon(Icons.landscape_rounded, size: 64, color: Colors.white38),
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

  Future<void> _openWhatsApp(PakTourDetail detail) async {
    final message = 'Hi, I am interested in the "${detail.packageTitle}" tour package. '
        'Please share more details.';
    final uri = Uri.parse(
      'https://wa.me/923001234567?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

// Simple HTML to styled widgets converter (same as visa detail)
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

    var content = html
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    final blockPattern = RegExp(
      r'<(h[1-6]|p|ul|ol)(?:\s[^>]*)?>(.*?)</\1>',
      dotAll: true,
    );

    final matches = blockPattern.allMatches(content).toList();

    if (matches.isEmpty) {
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
      } else if (tag == 'h3' || tag == 'h4' || tag == 'h5' || tag == 'h6') {
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
