import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../providers/package_provider.dart';

class PackageDetailScreen extends StatefulWidget {
  final PackageModel package;
  const PackageDetailScreen({super.key, required this.package});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final _scrollController = ScrollController();
  bool _isCollapsed = false;

  PackageModel get pkg => widget.package;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final collapsed = _scrollController.offset > 220;
      if (collapsed != _isCollapsed) setState(() => _isCollapsed = collapsed);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // YouTube packages get a full-screen vertical Shorts-style layout
    if (pkg.isYouTube && pkg.youtubeVideoId != null) {
      return _buildShortsLayout(context);
    }
    return _buildStandardLayout(context);
  }

  // ── YouTube / Shorts layout ────────────────────────────────────────────────

  Widget _buildShortsLayout(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Full-screen video section
          SliverToBoxAdapter(
            child: SizedBox(
              height: screenH,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // YouTube Shorts inline player
                  _ShortsWebPlayer(videoId: pkg.youtubeVideoId!),
                  // Back button
                  Positioned(
                    top: topPad + 8,
                    left: 4,
                    child: AppBackButton(),
                  ),
                  // Gradient + info at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildShortsOverlay(context),
                  ),
                ],
              ),
            ),
          ),
          // Details section below the video
          _buildPriceCard(),
          if (pkg.location?.isNotEmpty == true || pkg.packageTypeLabel.isNotEmpty)
            _buildInfoGrid(context),
          if (pkg.description?.isNotEmpty == true)
            _buildSection('Description', pkg.description!),
          if (pkg.informationalMessage?.isNotEmpty == true)
            _buildInfoMessage(),
          if (pkg.tagsList.isNotEmpty) _buildTags(),
          _buildContactSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomNavigationBar: _buildBookNowBar(),
    );
  }

  Widget _buildShortsOverlay(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Color(0xDD000000)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 40, 20, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pkg.packageTypeLabel.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pkg.packageTypeLabel.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8),
              ),
            ),
          Text(
            pkg.title,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (pkg.location?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 13, color: Colors.white60),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(pkg.location!,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
          if (pkg.displayPrice.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(pkg.displayPrice,
                style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 20),
              const SizedBox(width: 6),
              Text('Scroll for details',
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Standard layout (image hero + details) ────────────────────────────────

  Widget _buildStandardLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeroAppBar(),
          if (pkg.displayPrice.isNotEmpty) _buildPriceCard(),
          if (pkg.location?.isNotEmpty == true || pkg.packageTypeLabel.isNotEmpty)
            _buildInfoGrid(context),
          if (pkg.description?.isNotEmpty == true)
            _buildSection('Description', pkg.description!),
          if (pkg.informationalMessage?.isNotEmpty == true)
            _buildInfoMessage(),
          if (pkg.tagsList.isNotEmpty) _buildTags(),
          _buildContactSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildBookNowBar(),
    );
  }

  SliverAppBar _buildHeroAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: AppBackButton(),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(pkg.title,
            style: AppTextStyles.titleMd
                .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildHeroMedia(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pkg.packageTypeLabel.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(pkg.packageTypeLabel.toUpperCase(),
                          style: AppTextStyles.labelLg.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800)),
                    ),
                  Text(pkg.title,
                      style: AppTextStyles.h1.copyWith(fontSize: 24, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroMedia() {
    final url = pkg.primaryImageUrl;
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, _) => _gradientBg(),
        errorWidget: (_, _, _) => _gradientBg(),
      );
    }
    return _gradientBg();
  }

  Widget _gradientBg() => Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: const Center(
            child: Icon(Icons.card_travel_rounded, size: 64, color: Colors.white24)),
      );

  // ── Detail sliver sections ────────────────────────────────────────────────

  SliverToBoxAdapter _buildPriceCard() {
    if (pkg.displayPrice.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: Container(
        margin: AppPadding.cardLg,
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm + 2),
              ),
              child: const Icon(Icons.payments_outlined, color: AppColors.secondary, size: 22),
            ),
            AppGap.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.formattedStartingFrom != null ? 'Starting from' : 'Price',
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(pkg.displayPrice,
                      style: AppTextStyles.priceLg.copyWith(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoGrid(BuildContext context) {
    final items = <_InfoItem>[];
    if (pkg.packageTypeLabel.isNotEmpty) {
      items.add(_InfoItem(Icons.category_outlined, 'Type', pkg.packageTypeLabel));
    }
    if (pkg.location?.isNotEmpty == true) {
      items.add(_InfoItem(Icons.location_on_outlined, 'Location', pkg.location!));
    }
    if (pkg.currency.isNotEmpty) {
      items.add(_InfoItem(Icons.currency_exchange, 'Currency', pkg.currency));
    }
    if (pkg.isFeatured) {
      items.add(const _InfoItem(Icons.star_outline_rounded, 'Status', 'Featured'));
    }
    if (items.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: items
              .map((item) => SizedBox(
                    width: (MediaQuery.of(context).size.width - 76) / 2,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(item.icon,
                              size: AppIconSize.lg - 2, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.label, style: AppTextStyles.caption),
                              Text(item.value,
                                  style: AppTextStyles.labelLg.copyWith(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSection(String title, String content) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTextStyles.titleMd
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
            AppGap.sm,
            _HtmlContent(html: content),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoMessage() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
            AppGap.hSm,
            Expanded(
              child: Text(pkg.informationalMessage!,
                  style: AppTextStyles.bodyLg
                      .copyWith(color: AppColors.textSecondary, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildTags() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pkg.tagsList
              .map((tag) => Container(
                    padding: AppPadding.chip,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Text(tag,
                        style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ))
              .toList(),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContactSection() {
    final hasContact = pkg.contactNo?.isNotEmpty == true ||
        pkg.whatsappNo?.isNotEmpty == true;
    if (!hasContact) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        padding: AppPadding.cardLg,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact',
                style: AppTextStyles.titleMd
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
            AppGap.md,
            Row(
              children: [
                if (pkg.contactNo?.isNotEmpty == true)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launch('tel:${pkg.contactNo}'),
                      icon: const Icon(Icons.phone_outlined, size: 18),
                      label: const Text('Call'),
                    ),
                  ),
                if (pkg.contactNo?.isNotEmpty == true &&
                    pkg.whatsappNo?.isNotEmpty == true)
                  AppGap.hMd,
                if (pkg.whatsappNo?.isNotEmpty == true)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _openWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.chat_outlined, size: 18),
                      label: const Text('WhatsApp'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowBar() {
    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (pkg.displayPrice.isNotEmpty) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price',
                        style: AppTextStyles.bodyLg
                            .copyWith(fontSize: 12, color: AppColors.textSecondary)),
                    Text(pkg.displayPrice,
                        style: AppTextStyles.priceLg.copyWith(fontSize: 18)),
                  ],
                ),
              ),
              AppGap.hLg,
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: _openWhatsApp,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52)),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWhatsApp() async {
    final number = pkg.whatsappNo ?? pkg.contactNo;
    if (number == null) return;
    final clean = number.replaceAll(RegExp(r'[^\d+]'), '');
    final msg = Uri.encodeComponent(
        'Hi, I am interested in "${pkg.title}". Please share more details.');
    await _launch('https://wa.me/$clean?text=$msg');
  }
}

// ── Full-screen YouTube Shorts WebView player ─────────────────────────────

class _ShortsWebPlayer extends StatefulWidget {
  final String videoId;
  const _ShortsWebPlayer({required this.videoId});

  @override
  State<_ShortsWebPlayer> createState() => _ShortsWebPlayerState();
}

class _ShortsWebPlayerState extends State<_ShortsWebPlayer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setUserAgent(
          'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) '
          'Version/17.0 Mobile/15E148 Safari/604.1')
      ..loadHtmlString(_html(widget.videoId));
  }

  String _html(String id) => '''<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:100%;height:100%;background:#000;overflow:hidden}
iframe{position:fixed;top:0;left:0;width:100%;height:100%;border:none}
</style>
</head>
<body>
<iframe
  src="https://www.youtube.com/embed/$id?autoplay=1&controls=1&playsinline=1&rel=0&modestbranding=1&loop=1&playlist=$id"
  allow="autoplay;encrypted-media;fullscreen"
  allowfullscreen>
</iframe>
</body>
</html>''';

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}

// ── Helpers ───────────────────────────────────────────────────────────────

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}

class _HtmlContent extends StatelessWidget {
  final String html;
  const _HtmlContent({required this.html});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _parse(html),
      );

  List<Widget> _parse(String html) {
    final widgets = <Widget>[];
    final content = html
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');

    final blockRe =
        RegExp(r'<(h[1-6]|p|ul|ol)(?:\s[^>]*)?>(.*?)</\1>', dotAll: true);
    final matches = blockRe.allMatches(content).toList();

    if (matches.isEmpty) {
      final text = _strip(content).trim();
      if (text.isNotEmpty) {
        widgets.add(Text(text,
            style: AppTextStyles.bodyLg
                .copyWith(color: AppColors.textSecondary, height: 1.6)));
      }
      return widgets;
    }

    for (final m in matches) {
      final tag = m.group(1)!.toLowerCase();
      final inner = m.group(2)!;
      if (tag == 'h1' || tag == 'h2') {
        final t = _strip(inner).trim();
        if (t.isNotEmpty) {
          widgets.add(Padding(
            padding:
                const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: Text(t, style: AppTextStyles.titleLg),
          ));
        }
      } else if (tag.startsWith('h')) {
        final t = _strip(inner).trim();
        if (t.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.sm, bottom: AppSpacing.xs),
            child:
                Text(t, style: AppTextStyles.titleMd.copyWith(fontSize: 15)),
          ));
        }
      } else if (tag == 'p') {
        final t = _strip(inner).trim();
        if (t.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(t,
                style: AppTextStyles.bodyLg
                    .copyWith(color: AppColors.textSecondary, height: 1.6)),
          ));
        }
      } else if (tag == 'ul' || tag == 'ol') {
        final liRe =
            RegExp(r'<li(?:\s[^>]*)?>(.*?)</li>', dotAll: true);
        final items = liRe.allMatches(inner).toList();
        for (var i = 0; i < items.length; i++) {
          final t = _strip(items[i].group(1)!).trim();
          if (t.isNotEmpty) {
            widgets.add(Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(tag == 'ol' ? '${i + 1}.' : '\u2022',
                        style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    child: Text(t,
                        style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.textSecondary, height: 1.5)),
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

  String _strip(String h) => h.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
