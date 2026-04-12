import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_back_button.dart';
import '../providers/umrah_provider.dart';

class UmrahDetailScreen extends ConsumerStatefulWidget {
  final String urlLink;

  const UmrahDetailScreen({super.key, required this.urlLink});

  @override
  ConsumerState<UmrahDetailScreen> createState() => _UmrahDetailScreenState();
}

class _UmrahDetailScreenState extends ConsumerState<UmrahDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      ref.read(umrahDetailProvider.notifier).loadPackageDetail(widget.urlLink);
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
    if (isCollapsed != _isCollapsed) setState(() => _isCollapsed = isCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(umrahDetailProvider);

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(backgroundColor: AppColors.primary, leading: AppBackButton(),
          title: Text('Umrah Package', style: AppTextStyles.titleMd.copyWith(color: Colors.white))),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5)),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(backgroundColor: AppColors.primary, leading: AppBackButton()),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded, size: 36, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text('Something went wrong', style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Please check your internet\nconnection and try again', textAlign: TextAlign.center, style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(umrahDetailProvider.notifier).loadPackageDetail(widget.urlLink),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
          ]),
        )),
      );
    }

    final detail = state.detail;
    if (detail == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeroAppBar(detail),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Overview sections
          if (detail.overview.isNotEmpty)
            SliverToBoxAdapter(child: _buildCard(
              icon: Icons.info_outline_rounded, iconColor: AppColors.accent,
              title: 'Package Details',
              child: _buildSections(detail.overview),
            )),

          // Description
          if (detail.description.isNotEmpty)
            SliverToBoxAdapter(child: _buildCard(
              icon: Icons.description_outlined, iconColor: AppColors.primary,
              title: 'Description',
              child: _buildSections(detail.description),
            )),

          // Includes
          if (detail.includes.isNotEmpty)
            SliverToBoxAdapter(child: _buildCard(
              icon: Icons.check_circle_outline_rounded, iconColor: AppColors.success,
              title: 'Package Includes',
              child: _buildSections(detail.includes),
            )),

          // Excludes
          if (detail.excludes.isNotEmpty)
            SliverToBoxAdapter(child: _buildCard(
              icon: Icons.cancel_outlined, iconColor: AppColors.error,
              title: 'Not Included',
              child: _buildSections(detail.excludes),
            )),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(detail),
    );
  }

  // ── Hero ──
  SliverAppBar _buildHeroAppBar(UmrahPackageDetail detail) {
    return SliverAppBar(
      expandedHeight: 280, pinned: true, backgroundColor: AppColors.primary,
      leading: AppBackButton(),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(detail.packageTitle,
          style: AppTextStyles.titleMd.copyWith(fontWeight: FontWeight.w700, color: Colors.white),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(fit: StackFit.expand, children: [
          if (detail.imageUrl != null)
            CachedNetworkImage(imageUrl: detail.imageUrl!, fit: BoxFit.cover,
              placeholder: (_, _) => _gradientBg(), errorWidget: (_, _, _) => _gradientBg())
          else _gradientBg(),
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.75)],
            stops: const [0.3, 1.0],
          ))),
          Positioned(left: 20, right: 20, bottom: 20, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.mosque_outlined, size: 14, color: Colors.white),
                  SizedBox(width: 5),
                  Text('Umrah Package', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ),
              Text(detail.packageTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2)),
              if (detail.priceValue > 0) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Text('Starting from  ', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                  Text(detail.formattedPrice, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                ]),
              ],
            ],
          )),
        ]),
      ),
    );
  }

  // ── Card wrapper ──
  Widget _buildCard({required IconData icon, required Color iconColor, required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(children: [
            Container(width: 34, height: 34,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 17, color: iconColor)),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
          ]),
        ),
        Container(height: 1, color: AppColors.divider),
        Padding(padding: const EdgeInsets.all(16), child: child),
      ]),
    );
  }

  // ── Render sections (text / heading / table) ──
  Widget _buildSections(List<ContentSection> sections) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((s) {
        switch (s.type) {
          case 'heading':
            return Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Text(s.content ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            );
          case 'table':
            return _buildNativeTable(s);
          case 'bullets':
            return _buildBulletList(s.items);
          default: // text
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(s.content ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
            );
        }
      }).toList(),
    );
  }

  // ── Native Flutter Table ──
  Widget _buildNativeTable(ContentSection section) {
    final allRows = [...section.headers, ...section.rows];
    if (allRows.isEmpty) return const SizedBox.shrink();

    final headerCount = section.headers.length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE1E6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(allRows.length, (rowIndex) {
          final cells = allRows[rowIndex];
          final isHeader = rowIndex < headerCount;
          final isFirstDataRow = rowIndex == headerCount; // first row after headers (sub-header)
          final isEvenRow = (rowIndex - headerCount) % 2 == 0;

          Color bgColor;
          if (isHeader) {
            bgColor = AppColors.primary;
          } else if (isFirstDataRow && _looksLikeSubHeader(cells)) {
            bgColor = AppColors.primary.withValues(alpha: 0.08);
          } else {
            bgColor = isEvenRow ? Colors.white : const Color(0xFFF8F9FB);
          }

          return Container(
            color: bgColor,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(cells.length, (colIndex) {
                  final isFirst = colIndex == 0;
                  final cellText = cells[colIndex];

                  TextStyle textStyle;
                  if (isHeader) {
                    textStyle = const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white);
                  } else if (isFirstDataRow && _looksLikeSubHeader(cells)) {
                    textStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary);
                  } else if (isFirst) {
                    textStyle = const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
                  } else {
                    textStyle = const TextStyle(fontSize: 11.5, color: AppColors.textPrimary);
                  }

                  return Expanded(
                    flex: (isFirst && cells.length == 2) ? 2 : 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      decoration: BoxDecoration(
                        border: Border(
                          right: colIndex < cells.length - 1
                              ? BorderSide(color: isHeader ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFDDE1E6), width: 0.5)
                              : BorderSide.none,
                          bottom: rowIndex < allRows.length - 1
                              ? BorderSide(color: const Color(0xFFDDE1E6), width: 0.5)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text(cellText, style: textStyle),
                    ),
                  );
                }),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Bullet List ──
  Widget _buildBulletList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, size: 6, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  /// Check if a row looks like a sub-header (column names like Duration, Makkah, etc.)
  bool _looksLikeSubHeader(List<String> cells) {
    if (cells.length < 3) return false;
    final keywords = ['duration', 'makkah', 'madinah', 'double', 'triple', 'quad', 'quint', 'package'];
    int matchCount = 0;
    for (final cell in cells) {
      if (keywords.contains(cell.toLowerCase().trim())) matchCount++;
    }
    return matchCount >= 2;
  }

  // ── Bottom bar ──
  Widget _buildBottomBar(UmrahPackageDetail detail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Row(children: [
          if (detail.priceValue > 0) ...[
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Price', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(detail.formattedPrice, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.secondary)),
              ],
            )),
            const SizedBox(width: 16),
          ],
          Expanded(child: ElevatedButton(
            onPressed: () => _openWhatsApp(detail),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.chat_rounded, size: 18), SizedBox(width: 8),
              Text('Book Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _gradientBg() => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.primaryDark])),
    child: const Center(child: Icon(Icons.mosque_rounded, size: 64, color: Colors.white38)),
  );

  Future<void> _openWhatsApp(UmrahPackageDetail detail) async {
    final message = 'Hi, I am interested in the "${detail.packageTitle}" Umrah package. Please share more details.';
    final uri = Uri.parse('https://wa.me/+923111786785?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
