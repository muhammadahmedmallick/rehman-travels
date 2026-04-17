import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/app_bottom_sheet.dart';
import '../../../../app/widgets/currency_selector.dart';
import '../../../currency/presentation/providers/currency_provider.dart';
import '../../data/models/visa_models.dart';
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
    final selected = _selectedVariant;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Visa Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildBreadcrumb(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_type.variants.length > 1) ...[
                    const SizedBox(height: 4),
                    _buildVariantChips(currency),
                    const SizedBox(height: 14),
                  ],
                  if (selected != null) ...[
                    _buildRequirementsCard(selected),
                    const SizedBox(height: 14),
                    _buildSelectedVariantCard(selected, currency),
                  ] else
                    _buildEmptyState(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: selected == null
          ? null
          : _buildFooter(context, currency),
    );
  }

  // ─── Breadcrumb ───────────────────────────────────────

  Widget _buildBreadcrumb(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Pakistan'),
                  const TextSpan(text: '   -   '),
                  TextSpan(
                    text: _type.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: _openChange,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.edit_outlined,
                      size: 14, color: AppColors.accent),
                  SizedBox(width: 4),
                  Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildVariantChips(Currency? currency) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _type.variants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final v = _type.variants[i];
          final isSelected = i == _selectedVariantIndex;
          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            labelPadding: EdgeInsets.zero,
            label: Text(
              v.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            selectedColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.border,
              width: isSelected ? 1.2 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (_) =>
                setState(() => _selectedVariantIndex = i),
          );
        },
      ),
    );
  }

  // ─── Requirements ─────────────────────────────────────

  Widget _buildRequirementsCard(VisaVariant variant) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: variant.rules.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
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
          : Column(
              children: [
                for (int i = 0; i < variant.rules.length; i++) ...[
                  _RuleRow(rule: variant.rules[i]),
                  if (i != variant.rules.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 0.6,
                      indent: 74,
                      endIndent: 16,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
    );
  }

  // ─── Selected variant summary ─────────────────────────

  Widget _buildSelectedVariantCard(VisaVariant variant, Currency? currency) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  variant.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                _formatPrice(variant.price, variant.currency, currency),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'If you are traveling with a child, you need to apply for '
            'an additional child visa.',
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────

  Widget _buildFooter(BuildContext context, Currency? currency) {
    final from = _type.startingFromPrice;
    final currencyCode = _type.displayCurrency;

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColors.border.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 52,
                    child: Text(
                      'E-Visa',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Starting from',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          from == null
                              ? '—'
                              : _formatPrice(from, currencyCode, currency),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(AppRoutes.visaContact, extra: {
                          'type': _type,
                          'variant': _selectedVariant,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Apply now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  /// Formats a visa amount. If a currency is selected and it differs
  /// from the variant's native currency, we still show the native
  /// amount but with the variant currency code — the API quotes visa
  /// prices in the operator's chosen currency, and auto-converting
  /// could mislead the user about what they'll actually be charged.
  String _formatPrice(double value, String native, Currency? selected) {
    if (selected != null && selected.currencyCode == native) {
      return formatCurrencyPrice(value, selected);
    }
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$native $formatted';
  }
}

/// One row in the requirements list — renders a circular Material
/// icon (mapped from the rule's FontAwesome class) plus a title and
/// rule-type subtitle.
class _RuleRow extends StatelessWidget {
  final VisaRule rule;

  const _RuleRow({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _mapIcon(rule.icon),
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rule.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (rule.ruleType.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    _formatRuleType(rule.ruleType),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRuleType(String raw) {
    final trimmed = raw.replaceAll('_', ' ').trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase() + trimmed.substring(1);
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
