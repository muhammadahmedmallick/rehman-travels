import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_bottom_sheet.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../../flights/presentation/widgets/flight_route_header.dart';
import '../../data/models/visa_models.dart';
import '../providers/visa_provider.dart';
import '../widgets/select_visa_sheet.dart';

/// Visa details screen.
///
/// Takes a [VisaType] (picked from the home screen's "Select Visa"
/// sheet) and walks through:
///
///   1. Breadcrumb "Pakistan → {country} Visa" with a Change link
///      that reopens the picker.
///   2. Variant chips — switching a chip swaps the requirements list
///      because rules are carried per-variant on the API response.
///   3. Requirements list — one row per VisaRule with a Material
///      icon picked from the rule's FontAwesome class.
///   4. Selected variant summary card above the sticky footer.
///   5. Footer with "Starting from" (min variant price), an E-Visa
///      chip, and the Apply Now CTA that routes to the contact form.
class VisaDetailsScreen extends ConsumerStatefulWidget {
  final VisaType visa;

  const VisaDetailsScreen({super.key, required this.visa});

  @override
  ConsumerState<VisaDetailsScreen> createState() =>
      _VisaDetailsScreenState();
}

class _VisaDetailsScreenState extends ConsumerState<VisaDetailsScreen> {
  late VisaType _type;
  int _selectedVariantIndex = 0;

  @override
  void initState() {
    super.initState();
    _type = widget.visa;
  }

  VisaVariant? get _selectedVariant => _type.variants.isEmpty
      ? null
      : _type.variants[_selectedVariantIndex.clamp(0, _type.variants.length - 1)];

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider).selected;

    // Fetch full detail (per-variant rules only come from the detail
    // endpoint). Swap into _type once loaded; the passed-in VisaType
    // acts as an instant placeholder while the network call resolves.
    // Keyed on the current _type.id so picking a different country from
    // the "Change" sheet refetches for that id.
    ref.listen<AsyncValue<VisaType>>(
      visaTypeDetailProvider(_type.id),
      (prev, next) {
        next.whenData((fresh) {
          if (!mounted) return;
          if (fresh.id != _type.id) return;
          if (identical(_type, fresh)) return;
          setState(() {
            _type = fresh;
            _selectedVariantIndex = _selectedVariantIndex.clamp(
              0,
              fresh.variants.isEmpty ? 0 : fresh.variants.length - 1,
            );
          });
        });
      },
    );
    // Subscribe so the FutureProvider actually fires; ref.listen above
    // is what reacts to the resolved data.
    ref.watch(visaTypeDetailProvider(_type.id));
    final selected = _selectedVariant;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // Same dark-gradient sliver header the flight screens use,
          // so the visa flow reads as part of the booking flow visually.
          FlightRouteHeader(
            title: _type.title,
            subtitle: 'Pakistan',
            params: null,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildChangeCountryRow(),
                const SizedBox(height: 14),
                if (_type.variants.length > 1) ...[
                  _buildVariantChips(currency),
                  const SizedBox(height: 16),
                ],
                if (selected != null) ...[
                  _buildRequirementsCard(selected),
                  const SizedBox(height: 14),
                  _buildSelectedVariantCard(selected, currency),
                ] else
                  _buildEmptyState(),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: selected == null
          ? null
          : _buildFooter(context, currency),
    );
  }

  /// Elegant breadcrumb pill — sits just below the dark header and
  /// doubles as the entry point for swapping the visa country.
  /// Replaces the old giant "Modify" button that the FlightRouteHeader
  /// action row used to render; this reads as a quiet travel-style
  /// waypoint instead of a heavy secondary CTA.
  Widget _buildChangeCountryRow() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _openChange,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          ),
          child: Row(
            children: [
              Icon(Icons.flag_circle_rounded,
                  size: 18, color: AppColors.primary.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              const Text(
                'Pakistan',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded,
                  size: 13, color: AppColors.textHint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _type.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.edit_outlined,
                        size: 11, color: AppColors.accent),
                    SizedBox(width: 3),
                    Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openChange() async {
    final picked = await showAppBottomSheet<VisaType>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SelectVisaSheet(),
    );
    if (picked == null) return;
    setState(() {
      _type = picked;
      _selectedVariantIndex = 0;
    });
  }

  // ─── Variant chips ────────────────────────────────────

  /// Variant selector — horizontal stack of rich pill cards. Each
  /// shows the duration title + a compact price, so the user can
  /// scan visa options like menu items instead of a flat chip row.
  Widget _buildVariantChips(Currency? currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 1.2,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 8),
            const Text(
              'CHOOSE DURATION',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.textSecondary,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 62,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: _type.variants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final v = _type.variants[i];
              final isSelected = i == _selectedVariantIndex;
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () =>
                      setState(() => _selectedVariantIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border.withValues(alpha: 0.7),
                        width: isSelected ? 1.4 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.title,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatPrice(
                              v.price, v.currency, currency),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Requirements ─────────────────────────────────────

  /// Requirements list — an elegant white card with a subtle warm
  /// gradient and a small section eyebrow. Each rule row uses an
  /// accent-tinted icon tile and a thin dashed divider (airline
  /// ticket feel) instead of a heavy solid rule.
  Widget _buildRequirementsCard(VisaVariant variant) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.surfaceLight.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section eyebrow — hairline + tracked caps label.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 1.2,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'WHAT YOU\'LL NEED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.4,
                  ),
                ),
                const Spacer(),
                Text(
                  '${variant.rules.length} items',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          if (variant.rules.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No specific requirements listed',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                for (int i = 0; i < variant.rules.length; i++) ...[
                  _RuleRow(rule: variant.rules[i]),
                  if (i != variant.rules.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 56),
                      child: _RuleDivider(),
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  // ─── Selected variant summary ─────────────────────────

  /// Selected-variant summary — a ticket-style card: navy gradient,
  /// notched feel via a dashed divider, selected variant title and
  /// price on one line, processing note below. Reads like a
  /// boarding pass stub, which fits the travel mood better than a
  /// flat light-blue box.
  Widget _buildSelectedVariantCard(VisaVariant variant, Currency? currency) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F1035),
            Color(0xFF1A1B4B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 1.2,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              const Text(
                'YOUR SELECTION',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  variant.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _formatPrice(variant.price, variant.currency, currency),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFFD976),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TicketDashedLine(
            color: Colors.white.withValues(alpha: 0.22),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13,
                color: Colors.white.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Traveling with a child? An additional child visa is required.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────

  /// Bottom price bar — mirrors the booking / payment screens'
  /// `_buildBottomBar` style: white surface, top shadow, price on
  /// the left, golden CTA on the right. Keeps the visa flow visually
  /// aligned with the rest of the booking-like flows in the app.
  Widget _buildFooter(BuildContext context, Currency? currency) {
    final from = _type.startingFromPrice;
    final currencyCode = _type.displayCurrency;

    return Container(
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
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left — stacked layout so the price and the E-Visa stamp
            // never fight for the same row (which overflowed on long
            // currency codes / large amounts).
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Starting from',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            width: 0.6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.bolt_rounded,
                                size: 9, color: AppColors.accent),
                            SizedBox(width: 2),
                            Text(
                              'E-Visa',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: AppColors.accent,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      from == null
                          ? '—'
                          : _formatPrice(from, currencyCode, currency),
                      style: AppTextStyles.priceLg,
                    ),
                  ),
                ],
              ),
            ),
            AppGap.hMd,
            // Right — CTA gets a wider flex than the price column so
            // "Apply now →" stays one comfortable line on small
            // screens without the price crushing it.
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.visaContact, extra: {
                    'type': _type,
                    'variant': _selectedVariant,
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Apply now'),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty ────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      alignment: Alignment.center,
      child: const Text(
        'No variants available for this visa yet',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // ─── Utils ────────────────────────────────────────────

  /// Formats a visa amount, respecting the user's selected display
  /// currency. Visa prices from the API are quoted in PKR (native)
  /// and the shared `formatCurrencyPrice` helper converts PKR → the
  /// selected currency via `currencyRate`. If the native currency
  /// isn't PKR (future-proofing for multi-currency quotes), we show
  /// it as-is rather than guessing a conversion rate we don't have.
  String _formatPrice(double value, String native, Currency? selected) {
    if (native.toUpperCase() == 'PKR') {
      return formatCurrencyPrice(value, selected);
    }
    // Non-PKR native — no cross-rate available. Display in native
    // currency so the user sees the actual quoted amount.
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$native $formatted';
  }
}

/// One row in the requirements list — gradient-tinted rounded icon
/// tile (instead of a flat circle) + a title / rule-type subtitle.
/// A soft green check at the right hints that the item is known /
/// accounted-for, adding a collectible checklist feel.
class _RuleRow extends StatelessWidget {
  final VisaRule rule;

  const _RuleRow({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.accent.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _mapIcon(rule.icon),
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rule.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                if (rule.displaySubtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    rule.displaySubtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: AppColors.success.withValues(alpha: 0.55),
          ),
        ],
      ),
    );
  }

  /// Best-effort map from a FontAwesome class (e.g. "fa-passport") to
  /// a Material icon. Falls back to a generic checklist icon so the
  /// row never renders without a glyph.
  IconData _mapIcon(String faClass) {
    final key = faClass.toLowerCase().replaceFirst('fa-', '').trim();
    switch (key) {
      case 'passport':
        return Icons.book_rounded;
      case 'id-card':
      case 'address-card':
      case 'card':
        return Icons.badge_outlined;
      case 'camera':
      case 'image':
      case 'picture':
      case 'user':
        return Icons.person_outline_rounded;
      case 'phone':
      case 'phone-alt':
        return Icons.phone_rounded;
      case 'ticket':
      case 'ticket-alt':
      case 'plane':
        return Icons.confirmation_number_outlined;
      case 'users':
      case 'family':
        return Icons.people_outline_rounded;
      case 'bank':
      case 'university':
      case 'landmark':
        return Icons.account_balance_outlined;
      case 'file':
      case 'file-alt':
      case 'document':
        return Icons.description_outlined;
      case 'briefcase':
        return Icons.work_outline_rounded;
      case 'money':
      case 'money-bill':
      case 'dollar-sign':
        return Icons.payments_outlined;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}

/// Thin dashed divider used between rule rows — airline-ticket feel.
class _RuleDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      _TicketDashedLine(color: AppColors.border);
}

/// Dashed horizontal line rendered as tiny spaced segments. Kept as
/// a standalone widget so the details screen can reuse the same
/// dash rhythm on both the light requirements card and the dark
/// selected-variant "ticket stub" (just swap the [color]).
class _TicketDashedLine extends StatelessWidget {
  final Color color;

  const _TicketDashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        const double dashW = 3;
        const double gapW = 3;
        final int count = (c.maxWidth / (dashW + gapW)).floor();
        return Row(
          children: List.generate(
            count.clamp(2, 200),
            (_) => Container(
              width: dashW,
              height: 1,
              margin: const EdgeInsets.only(right: gapW),
              color: color,
            ),
          ),
        );
      },
    );
  }
}
