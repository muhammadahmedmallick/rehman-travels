import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/widgets/currency_selector.dart';

/// Elegant dark-gradient flight results header.
///
/// Renders as a `SliverAppBar(pinned: true)` with a custom
/// `flexibleSpace` painted with the app's deep navy gradient.
///
/// Layout (top → bottom):
/// 1. Top row — back button + route (`ISB ● ╌╌╌ ✈ ╌╌╌ ● KHI`)
///    with currency pill + edit icon on the right.
/// 2. Info chip row — date range, cabin, passenger count.
/// 3. Bottom — two full-width glass-morphism Filter / Sort buttons
///    (only shown when [onFilter] / [onSort] are provided).
class FlightRouteHeader extends StatelessWidget {
  /// Fallback title used when [params] is null (no route).
  final String title;

  /// Optional caption when the caller wants to add extra context
  /// beyond the auto-generated chips.
  final String? subtitle;

  /// Bottom line text (e.g. "100 flights found"). Rendered as a chip.
  final String? bottomText;

  /// Search params Map: `departureCode`, `departureName`, `arrivalCode`,
  /// `arrivalName`, `outboundDate`, `inboundDate`, `cabin`,
  /// `adultsCount`, `childrenCount`, `infantsCount`.
  final Map<String, dynamic>? params;

  final bool showCurrency;
  final VoidCallback? onModify;
  final VoidCallback? onSort;
  final VoidCallback? onFilter;
  final bool filterActive;
  final bool actionsDisabled;

  const FlightRouteHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.bottomText,
    this.params,
    this.showCurrency = true,
    this.onModify,
    this.onSort,
    this.onFilter,
    this.filterActive = false,
    this.actionsDisabled = false,
  });

  // ---------- Palette ----------
  static const _bgStart = Color(0xFF1A1A2E);
  static const _bgEnd = Color(0xFF16213E);
  static const _accent = Color(0xFF10B981); // green airplane

  @override
  Widget build(BuildContext context) {
    final hasRoute = params != null;
    final showChipRow =
        onFilter != null || onSort != null || onModify != null;

    // Single-container header — everything lives inside the flexibleSpace
    // so the gradient is one seamless surface (no seam between toolbar
    // and `bottom`). Heights below match the content exactly.
    const double routeRowHeight = 44;
    const double chipRowHeight = 26;
    const double actionRowHeight = 44;
    const double topSafePadding = 6;
    const double bottomPadding = 10;

    double contentHeight = topSafePadding + routeRowHeight + bottomPadding;
    if (hasRoute) contentHeight += 10 + chipRowHeight;
    if (showChipRow) contentHeight += 10 + actionRowHeight;

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      expandedHeight: contentHeight,
      toolbarHeight: contentHeight,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bgStart, _bgEnd],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                8, topSafePadding, 12, bottomPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: routeRowHeight,
                  child: hasRoute ? _topRow(context) : _plainTitleRow(),
                ),
                if (hasRoute) ...[
                  const SizedBox(height: 10),
                  SizedBox(height: chipRowHeight, child: _infoChipsRow()),
                ],
                if (showChipRow) ...[
                  const SizedBox(height: 10),
                  SizedBox(height: actionRowHeight, child: _actionRow()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionRow() {
    return Row(
      children: [
        if (onFilter != null)
          Expanded(
            child: _filterSortBtn(
              icon: Icons.tune_rounded,
              label: 'Filter',
              onTap: onFilter,
              activeDot: filterActive,
            ),
          ),
        if (onFilter != null && (onSort != null || onModify != null))
          const SizedBox(width: 10),
        if (onSort != null)
          Expanded(
            child: _filterSortBtn(
              icon: Icons.swap_vert_rounded,
              label: 'Sort',
              onTap: onSort,
            ),
          ),
        if (onSort != null && onModify != null) const SizedBox(width: 10),
        if (onModify != null)
          Expanded(
            child: _filterSortBtn(
              icon: Icons.edit_outlined,
              label: 'Modify',
              onTap: onModify,
              showChevron: false,
            ),
          ),
      ],
    );
  }

  // ---------- Content ----------

  Widget _plainTitleRow() {
    // Title is centered by absolutely-positioning it behind the
    // leading / trailing action clusters, so screens like the visa
    // details / contact / multi-city review read as a clean centered
    // header regardless of how many actions are on the right.
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 72),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            _backButton(),
            const Spacer(),
            if (showCurrency) ...[
              _disable(child: const CurrencySelector()),
              const SizedBox(width: 4),
            ],
            if (onModify != null) _iconAction(Icons.edit_outlined, onModify),
          ],
        ),
      ],
    );
  }

  Widget _topRow(BuildContext context) {
    final depCode = (params?['departureCode'] ?? '---').toString();
    final arrCode = (params?['arrivalCode'] ?? '---').toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _backButton(),
        const SizedBox(width: 6),
        Expanded(child: _routeBlock(depCode: depCode, arrCode: arrCode)),
        if (showCurrency) _disable(child: const CurrencySelector()),
      ],
    );
  }

  Widget _routeBlock({required String depCode, required String arrCode}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            depCode,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        // Dashed line + centered plane icon, with end dots
        Expanded(
          child: SizedBox(
            height: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _dot(filled: false),
                Expanded(child: _dash()),
                const Icon(Icons.flight_takeoff_rounded,
                    size: 16, color: _accent),
                Expanded(child: _dash()),
                _dot(filled: true),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            arrCode,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _infoChipsRow() {
    // Build the chip strings. Priority: caller-provided [subtitle]
    // (already `·`-joined) — otherwise auto-compose from [params].
    final List<String> labels;
    if ((subtitle ?? '').isNotEmpty) {
      labels = subtitle!
          .split(RegExp(r'\s*·\s*'))
          .where((s) => s.trim().isNotEmpty)
          .toList();
    } else {
      labels = <String>[];
      final dateLabel = _dateRangeLabel();
      if (dateLabel.isNotEmpty) labels.add(dateLabel);
      labels.add(_cabinLabel((params?['cabin'] ?? 'Y').toString()));
      final paxLabel = _paxLabel();
      if (paxLabel.isNotEmpty) labels.add(paxLabel);
    }
    if ((bottomText ?? '').isNotEmpty) labels.add(bottomText!);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: labels.map(_infoChip).toList(),
      ),
    );
  }

  // ---------- Buttons ----------

  Widget _backButton() {
    return Builder(
      builder: (ctx) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(ctx).maybePop(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _iconAction(IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null && !actionsDisabled;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 0.5,
            ),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _disable({required Widget child}) {
    if (!actionsDisabled) return child;
    return IgnorePointer(child: Opacity(opacity: 0.4, child: child));
  }

  // ---------- Helper widgets (spec) ----------

  Widget _dot({required bool filled}) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white, width: 1.4),
      ),
    );
  }

  /// Thin dashed horizontal line painted with individual segments.
  /// Uses a LayoutBuilder + Row so it scales to whatever width is given.
  Widget _dash() {
    return LayoutBuilder(
      builder: (_, c) {
        const double dashW = 3;
        const double gapW = 3;
        final int count = (c.maxWidth / (dashW + gapW)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            count.clamp(2, 200),
            (_) => Container(
              width: dashW,
              height: 1,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _filterSortBtn({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool activeDot = false,
    bool showChevron = true,
  }) {
    final enabled = onTap != null && !actionsDisabled;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: Colors.white.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.18),
            width: 0.6,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 17),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                if (activeDot) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                if (showChevron) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Formatters ----------

  String _dateRangeLabel() {
    final outbound = (params?['outboundDate'] ?? '').toString();
    final inbound = (params?['inboundDate'] ?? '').toString();
    if (outbound.isEmpty) return '';
    try {
      final out = _parse(outbound);
      if (inbound.isEmpty) {
        return DateFormat('d MMM yyyy').format(out);
      }
      final inb = _parse(inbound);
      final sameMonth = out.month == inb.month && out.year == inb.year;
      if (sameMonth) {
        return '${out.day}–${inb.day} ${DateFormat('MMM yyyy').format(inb)}';
      }
      return '${DateFormat('d MMM').format(out)} – ${DateFormat('d MMM yyyy').format(inb)}';
    } catch (_) {
      return outbound;
    }
  }

  DateTime _parse(String s) {
    if (s.contains('-') && s.indexOf('-') == 2) {
      return DateFormat('dd-MM-yyyy').parseStrict(s);
    }
    return DateFormat('yyyy-MM-dd').parseStrict(s);
  }

  String _cabinLabel(String code) {
    final c = code.toUpperCase().trim();
    if (c == 'C' || c == 'J' || c == 'BUSINESS') return 'Business';
    if (c == 'F' || c == 'FIRST') return 'First';
    if (c == 'W' || c == 'PREMIUM' || c == 'PREMIUM ECONOMY') return 'Premium';
    return 'Economy';
  }

  String _paxLabel() {
    final a = (params?['adultsCount'] as int?) ?? 1;
    final c = (params?['childrenCount'] as int?) ?? 0;
    final i = (params?['infantsCount'] as int?) ?? 0;
    final total = a + c + i;
    if (total <= 0) return '';
    return '$total ${total == 1 ? 'Adult' : 'Pax'}';
  }
}
