import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme.dart';
import '../../data/models/visa_models.dart';
import '../providers/visa_provider.dart';

/// "Select Visa" bottom sheet — lists every available visa type
/// (country) from `/api/mobile/visas/types/`. Dismisses with the
/// picked type via `Navigator.pop(context, type)` so the caller can
/// route to the details screen.
class SelectVisaSheet extends ConsumerWidget {
  const SelectVisaSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(visaTypesProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Select Visa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 18,
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textSecondary, size: 22),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.isLoading && state.types.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (state.error != null && state.types.isEmpty)
            _errorBlock(context, ref, state.error!)
          else if (state.types.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No visas available right now',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state.types.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _VisaTypeRow(type: state.types[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _errorBlock(BuildContext context, WidgetRef ref, String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pop<VisaType>(type),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconForType(type),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _stripTrailingVisa(type.title),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (type.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        type.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint, size: 22),
            ],
          ),
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

  IconData _iconForType(VisaType t) {
    final title = t.title.toLowerCase();
    if (title.contains('umrah') || title.contains('hajj')) {
      return Icons.mosque_rounded;
    }
    return Icons.badge_outlined;
  }
}
