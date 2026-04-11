import 'package:flutter/material.dart';
import '../theme.dart';

/// Clean, elegant bottom sheet wrapper.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool isScrollControlled = false,
  bool isDismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    builder: (ctx) {
      final bottom = MediaQuery.of(ctx).padding.bottom;
      return Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, bottom > 0 ? bottom : 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(width: 32, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              Flexible(child: builder(ctx)),
            ],
          ),
        ),
      );
    },
  );
}

/// Elegant option tile for bottom sheets.
class SheetOption extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const SheetOption({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(children: [
          // Icon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: iconColor ?? (isSelected ? AppColors.primary : AppColors.textSecondary)),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(subtitle!, style: TextStyle(fontSize: 12, color: AppColors.textHint, height: 1.3)),
            ],
          ])),
          const SizedBox(width: 10),
          // Radio dot
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB), width: isSelected ? 0 : 1.5),
            ),
            child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ]),
      ),
    );
  }
}
