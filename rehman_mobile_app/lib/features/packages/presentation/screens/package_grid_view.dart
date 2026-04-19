import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../providers/package_provider.dart';
import '../widgets/package_grid_card.dart';

class PackageGridView extends StatelessWidget {
  final List<PackageModel> packages;
  final void Function(PackageModel) onPackageTap;
  final Future<void> Function() onRefresh;

  const PackageGridView({
    super.key,
    required this.packages,
    required this.onPackageTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: packages.isEmpty
          ? ListView(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off_rounded,
                          size: 64, color: AppColors.textHint),
                      AppGap.md,
                      Text('No packages found',
                          style: AppTextStyles.titleMd
                              .copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ])
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(16, topPad + 90, 16, 32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.66,
              ),
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final pkg = packages[index];
                return PackageGridCard(
                  key: ValueKey(pkg.slug),
                  package: pkg,
                  onTap: () => onPackageTap(pkg),
                );
              },
            ),
    );
  }
}
