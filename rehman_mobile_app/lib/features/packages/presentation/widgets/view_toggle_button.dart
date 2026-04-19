import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/package_provider.dart';

class ViewToggleButton extends ConsumerWidget {
  const ViewToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReels = ref.watch(
      packageListProvider.select((s) => s.viewMode == PackageViewMode.reels),
    );
    return GestureDetector(
      onTap: () => ref.read(packageListProvider.notifier).toggleViewMode(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isReels
              ? const Color(0x22FFFFFF)
              : const Color(0x09000000),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isReels
                ? const Color(0x20FFFFFF)
                : const Color(0x12000000),
          ),
        ),
        child: Icon(
          isReels ? Icons.grid_view_rounded : Icons.play_circle_outline_rounded,
          color: isReels ? Colors.white : Colors.black87,
          size: 16,
        ),
      ),
    );
  }
}
