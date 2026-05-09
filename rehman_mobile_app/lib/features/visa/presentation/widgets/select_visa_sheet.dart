import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../data/models/visa_models.dart';
import '../providers/visa_provider.dart';

/// "Select Visa" bottom sheet — visually mirrors the flight departure
/// airport picker (`AirportSearchSheet`) so both pickers feel like the
/// same component: full-height draggable sheet, drag handle, search
/// bar, and code-chip rows.
///
/// Use `SelectVisaSheet.show(context)` to open it; it returns the
/// picked `VisaType` (or null if dismissed).
class SelectVisaSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const SelectVisaSheet({super.key, required this.scrollController});

  /// Convenience opener that wires the sheet into a full-height
  /// draggable modal — same pattern as `_showAirportSearch`.
  static Future<VisaType?> show(BuildContext context) {
    return showModalBottomSheet<VisaType>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) =>
            SelectVisaSheet(scrollController: scrollController),
      ),
    );
  }

  @override
  ConsumerState<SelectVisaSheet> createState() => _SelectVisaSheetState();
}

class _SelectVisaSheetState extends ConsumerState<SelectVisaSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VisaType> _filter(List<VisaType> all) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((t) {
      return t.title.toLowerCase().contains(q) ||
          t.subtitle.toLowerCase().contains(q) ||
          t.countryCode.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visaTypesProvider);
    final results = _filter(state.types);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search visa or country',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ],
          ),
        ),
        if (state.isLoading && state.types.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: CircularProgressIndicator(),
          )
        else if (state.error != null && state.types.isEmpty)
          _errorBlock(context, ref, state.error!)
        else if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              _query.isEmpty
                  ? 'No visas available right now'
                  : 'No visas found',
              style: AppTextStyles.hint,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final type = results[index];
                return _VisaTypeRow(type: type);
              },
            ),
          ),
      ],
    );
  }

  Widget _errorBlock(BuildContext context, WidgetRef ref, String error) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 28),
          const SizedBox(height: 8),
          const Text(
            'Could not load visas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.read(visaTypesProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _VisaTypeRow extends StatelessWidget {
  final VisaType type;

  const _VisaTypeRow({required this.type});

  @override
  Widget build(BuildContext context) {
    final code = type.countryCode.isNotEmpty
        ? type.countryCode.toUpperCase()
        : _stripTrailingVisa(type.title)
            .toUpperCase()
            .padRight(3, ' ')
            .substring(0, 3)
            .trim();
    final country = _stripTrailingVisa(type.title);
    final subtitle = type.subtitle.isNotEmpty ? type.subtitle : 'From Pakistan';

    return InkWell(
      onTap: () => Navigator.of(context).pop<VisaType>(type),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  code,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  /// Titles arrive like "UAE Visa" / "Umrah Visa" — strip the trailing
  /// " Visa" so the sheet reads as a country list, not a repetition.
  String _stripTrailingVisa(String input) {
    const suffix = ' Visa';
    if (input.toLowerCase().endsWith(suffix.toLowerCase())) {
      return input.substring(0, input.length - suffix.length).trim();
    }
    return input;
  }
}
