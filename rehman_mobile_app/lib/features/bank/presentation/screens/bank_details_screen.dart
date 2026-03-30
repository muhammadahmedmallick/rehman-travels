import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../providers/bank_provider.dart';

class BankDetailsScreen extends ConsumerWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankState = ref.watch(bankProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(AppRadius.sm + 2),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: AppIconSize.lg - 2,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        title: Text(
          'Bank Details',
          style: AppTextStyles.titleLg,
        ),
        centerTitle: true,
      ),
      body: bankState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            )
          : bankState.error != null
              ? _buildError(ref, bankState.error!)
              : _buildContent(context, bankState.accounts),
    );
  }

  Widget _buildError(WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.textHint,
            ),
            AppGap.md,
            Text(
              'Failed to load bank details',
              style: AppTextStyles.titleMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppGap.sm,
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLg.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppGap.lg,
            ElevatedButton(
              onPressed: () => ref.read(bankProvider.notifier).refresh(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<BankAccount> accounts) {
    return SingleChildScrollView(
      padding: AppPadding.cardLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info
          _buildInfoCard(),

          AppGap.lg,

          // Section Title
          Text(
            'Our Bank Accounts',
            style: AppTextStyles.titleLg,
          ),
          AppGap.xs,
          Text(
            'Tap on any field to copy',
            style: AppTextStyles.bodyLg.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          AppGap.md,

          // Bank Cards
          ...accounts.map((account) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _BankCard(account: account),
              )),

          AppGap.sm,

          // Note
          _buildNote(),

          AppGap.md,
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: AppPadding.cardLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: AppPadding.card,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              color: Colors.white,
              size: AppIconSize.xl,
            ),
          ),
          AppGap.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Bank Transfer',
                  style: AppTextStyles.titleMd.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                AppGap.xs,
                Text(
                  'Transfer to any of our verified accounts below',
                  style: AppTextStyles.bodyLg.copyWith(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: const Color(0xFFFFE082),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFF9A825),
            size: AppIconSize.lg,
          ),
          AppGap.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important',
                  style: AppTextStyles.titleSm.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF57F17),
                  ),
                ),
                AppGap.xs,
                Text(
                  'Please share the payment receipt via WhatsApp after completing your transfer for quick confirmation.',
                  style: AppTextStyles.bodyLg.copyWith(
                    fontSize: 13,
                    color: const Color(0xFFF57F17).withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final BankAccount account;

  const _BankCard({required this.account});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: AppIconSize.lg - 2),
            const SizedBox(width: 10),
            Text('$label copied'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: AppPadding.cardLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(account.colorValue);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Bank Header
          Container(
            padding: AppPadding.cardLg,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
                topRight: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      account.bankLogo,
                      style: AppTextStyles.titleSm.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                AppGap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: AppTextStyles.titleMd.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        account.contactNo,
                        style: AppTextStyles.bodyLg.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: AppPadding.chip,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Text(
                    account.branchCode,
                    style: AppTextStyles.bodyMd.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Account Details
          Padding(
            padding: AppPadding.cardLg,
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  icon: Icons.person_outline,
                  label: 'Account Title',
                  value: account.accountTitle,
                  canCopy: true,
                ),
                AppGap.md,
                _buildDetailRow(
                  context,
                  icon: Icons.credit_card_outlined,
                  label: 'Account Number',
                  value: account.accountNumber,
                  canCopy: true,
                  isHighlighted: true,
                ),
                AppGap.md,
                _buildDetailRow(
                  context,
                  icon: Icons.numbers,
                  label: 'IBAN',
                  value: account.iban,
                  canCopy: true,
                  isHighlighted: true,
                ),
                if (account.swiftCode.isNotEmpty) ...[
                  AppGap.md,
                  _buildDetailRow(
                    context,
                    icon: Icons.public_outlined,
                    label: 'SWIFT Code',
                    value: account.swiftCode,
                    canCopy: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool canCopy = false,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: canCopy ? () => _copyToClipboard(context, value, label) : null,
      child: Container(
        padding: AppPadding.card,
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.primary.withValues(alpha: 0.04)
              : AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          border: isHighlighted
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.1))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppIconSize.lg - 2,
              color: AppColors.textHint,
            ),
            AppGap.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: isHighlighted ? 0.5 : 0,
                    ),
                  ),
                ],
              ),
            ),
            if (canCopy)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.copy_rounded,
                  size: AppIconSize.sm,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
