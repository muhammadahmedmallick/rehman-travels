import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
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
          leading: AppBackButton(),
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
          leading: AppBackButton(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wifi_off_rounded, size: 36, color: AppColors.error),
                ),
                const SizedBox(height: 20),
                Text(
                  'Something went wrong',
                  style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your internet\nconnection and try again',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(visaDetailProvider.notifier).loadVisaDetail(widget.urlLink);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
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
            leading: AppBackButton(),
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

          // Visa Types / Durations
          if (detail.visaDurations.isNotEmpty)
            SliverToBoxAdapter(child: _buildVisaTypes(detail.visaDurations)),

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

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bottom bar — Apply Now → WhatsApp
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => _openWhatsApp(detail),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_rounded, size: 20),
                SizedBox(width: 10),
                Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisaTypes(List<dynamic> durations) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.badge_outlined, size: 17, color: AppColors.accent),
              ),
              const SizedBox(width: 10),
              const Text('Available Visa Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ]),
          ),
          // Visa type cards
          ...durations.map<Widget>((d) {
            final title = d['visaTitle'] ?? '';
            final priceRaw = d['visaPrice'] ?? '';
            final currency = d['currency'] ?? 'USD';
            // Format price with commas
            final priceNum = int.tryParse(priceRaw.toString().replaceAll(',', '')) ?? 0;
            final price = priceNum > 0 ? priceNum.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') : priceRaw;
            final duration = d['duration'] ?? '';
            final validity = d['validity'] ?? '';
            final entries = d['numEntries'] ?? '';
            final visaType = d['visaType'] ?? '';
            final includesRaw = d['visaIncludes'];
            final List<String> includesList = includesRaw is List
                ? includesRaw.map<String>((e) => e.toString()).toList()
                : includesRaw is String && includesRaw.isNotEmpty
                    ? [includesRaw]
                    : [];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  // Header row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.04),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.badge_outlined, size: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              if (visaType.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(visaType, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accent)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$currency $price',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                    child: Column(
                      children: [
                        Row(children: [
                          _visaInfoChip(Icons.schedule, 'Duration', duration),
                          const SizedBox(width: 10),
                          _visaInfoChip(Icons.calendar_today_outlined, 'Validity', validity),
                          const SizedBox(width: 10),
                          _visaInfoChip(Icons.repeat, 'Entries', entries),
                        ]),
                        if (includesList.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(children: [
                                  Icon(Icons.check_circle, size: 14, color: AppColors.success),
                                  SizedBox(width: 6),
                                  Text('Includes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
                                ]),
                                const SizedBox(height: 8),
                                ...includesList.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Icon(Icons.circle, size: 5, color: AppColors.success),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(item, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _visaInfoChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(VisaDetail detail) async {
    final country = detail.displayName;
    final message = '✈️ Assalam o Alaikum!\n\n'
        'I\'m interested in *$country Visa* 🌍\n\n'
        '📋 Please share:\n'
        '• Visa requirements\n'
        '• Processing time\n'
        '• Complete fee details\n\n'
        'Looking forward to your response! 🙏';
    final uri = Uri.parse('https://wa.me/+923111786785?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
