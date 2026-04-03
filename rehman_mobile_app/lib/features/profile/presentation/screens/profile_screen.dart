import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../app/routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppGap.lg,

              // Profile Header
              Padding(
                padding: AppPadding.screenHLg,
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Center(
                        child: authState.isAuthenticated
                            ? Text(
                                authState.username?.substring(0, 1).toUpperCase() ?? 'U',
                                style: AppTextStyles.h1.copyWith(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: AppIconSize.xxl,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    AppGap.hLg,
                    // Name & Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.isAuthenticated
                                ? authState.username ?? 'User'
                                : 'Guest User',
                            style: AppTextStyles.h3,
                          ),
                          if (authState.isAuthenticated && authState.email != null)
                            Text(
                              authState.email!,
                              style: AppTextStyles.bodyLg.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            )
                          else
                            Text(
                              'Sign in to access all features',
                              style: AppTextStyles.bodyLg.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppGap.xl,

              // Menu Items
              Padding(
                padding: AppPadding.screenH,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.account_balance_outlined,
                        title: 'Bank Details',
                        onTap: () => context.push(AppRoutes.bankDetails),
                      ),
                      const _MenuDivider(),
                      _MenuItem(
                        icon: Icons.support_agent_outlined,
                        title: 'Contact Us',
                        onTap: () => context.push(AppRoutes.contact),
                      ),
                      const _MenuDivider(),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        onTap: () {},
                      ),
                      const _MenuDivider(),
                      _MenuItem(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        onTap: () => context.push(AppRoutes.aboutUs),
                      ),
                    ],
                  ),
                ),
              ),

              AppGap.lg,

              // Sign In / Sign Out Button
              Padding(
                padding: AppPadding.screenH,
                child: authState.isAuthenticated
                    ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(authStateProvider.notifier).signOut();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.logout, size: AppIconSize.lg),
                          label: const Text('Sign Out'),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push(AppRoutes.login),
                          icon: const Icon(Icons.login, size: AppIconSize.lg),
                          label: const Text('Sign In'),
                        ),
                      ),
              ),

              AppGap.md,

              // App Version
              Text(
                'Version 1.0.0',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textHint,
                ),
              ),

              AppGap.xl,
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textSecondary,
            ),
            AppGap.hMd,
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.titleMd.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: AppIconSize.lg,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 52),
      color: AppColors.divider,
    );
  }
}
