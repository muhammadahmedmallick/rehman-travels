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
          title: const Text(
            'Tour Details',
            style: TextStyle(color: Colors.white, fontSize: 16),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load tour details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  detailState.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isCollapsed
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => context.pop(),
            ),
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                detail.packageTitle,
                style: const TextStyle(
                  fontSize: 15,
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
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (detail.durationText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  detail.durationText,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Text(
                          detail.packageTitle,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
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
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.priceLabelText.isNotEmpty
                                ? 'Price ${detail.priceLabelText}'
                                : 'Starting from',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              if (detail.discountPriceValue > 0) ...[
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.discountPriceValue)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.priceValue)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ] else
                                Text(
                                  '${detail.currencyType} ${_formatPrice(detail.priceValue)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.secondary,
                                  ),
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
        padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Price',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${detail.currencyType} ${_formatPrice(detail.discountPriceValue > 0 ? detail.discountPriceValue : detail.priceValue)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((item) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 76) / 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
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
          style: const TextStyle(
            fontSize: 14,
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
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ));
        }
      } else if (tag == 'h3' || tag == 'h4' || tag == 'h5' || tag == 'h6') {
        final text = _stripTags(inner).trim();
        if (text.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ));
        }
      } else if (tag == 'p') {
        final text = _stripTags(inner).trim();
        if (text.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
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
              padding: const EdgeInsets.only(left: 8, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(
                      bullet,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      itemText,
                      style: const TextStyle(
                        fontSize: 14,
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
