import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../core/network/exalted_api_client.dart';
import '../../../flights/data/models/debug_pnr_record.dart';
import '../../../flights/presentation/providers/debug_pnr_provider.dart';

/// Debug-only Settings → Debug PNRs screen. Lists every PNR Exalted
/// has handed back during the current install + lets the developer
/// cancel them one at a time via `/orderCancel`. Hidden from release
/// builds (entry on Profile is gated on `kDebugMode`, screen itself
/// shows an empty state if somehow opened in release).
class DebugPnrsScreen extends ConsumerStatefulWidget {
  const DebugPnrsScreen({super.key});

  @override
  ConsumerState<DebugPnrsScreen> createState() => _DebugPnrsScreenState();
}

class _DebugPnrsScreenState extends ConsumerState<DebugPnrsScreen> {
  final Set<String> _cancelling = <String>{};

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(debugPnrsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Debug PNRs',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          if (records.isNotEmpty)
            TextButton(
              onPressed: _confirmClearAll,
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: !kDebugMode
          ? const _EmptyState(message: 'Debug PNRs are only tracked in debug builds.')
          : records.isEmpty
              ? const _EmptyState(
                  message:
                      'No PNRs tracked yet. Create a booking and the PNR will show up here.')
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _PnrTile(
                    record: records[i],
                    isCancelling: _cancelling.contains(records[i].pnr),
                    onCancel: () => _cancelPnr(records[i]),
                  ),
                ),
    );
  }

  Future<void> _cancelPnr(DebugPnrRecord r) async {
    if (_cancelling.contains(r.pnr)) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this PNR?'),
        content: Text(
            'Calls /orderCancel on Exalted for ${r.pnr} (${r.airType}). This is irreversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel PNR'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancelling.add(r.pnr));

    final payload = {
      'airType': r.airType,
      'pnr': r.pnr,
      'reference': r.reference,
      'echoToken': r.echoToken,
      'jSessionId': r.jSessionId,
      'vCarrier': r.vCarrier,
      'currencyRate': '1',
      'currencyCode': 'PKR',
      'receivableAccount': ' Mobile App',
      'debitAccount': ' Mobile App',
      'paymentAmount': r.amount.ceil().toString(),
    };

    if (kDebugMode) {
      print('═══════════════════════════════════════════════════════');
      print('║ ORDER CANCEL — manual (Settings)');
      print('║ payload: ${jsonEncode(payload)}');
      print('═══════════════════════════════════════════════════════');
    }

    String resultMessage;
    bool success = false;
    try {
      final client = ref.read(exaltedApiClientProvider);
      final resp = await client.post('/orderCancel', data: payload);
      if (kDebugMode) {
        print('=== ORDER CANCEL response: ${resp.statusCode} → ${resp.data}');
      }
      success = resp.statusCode == 200;
      resultMessage = success
          ? 'PNR ${r.pnr} cancelled.'
          : 'Cancel returned ${resp.statusCode}: ${resp.data}';
    } catch (e) {
      resultMessage = 'Cancel failed: $e';
    } finally {
      if (mounted) setState(() => _cancelling.remove(r.pnr));
    }

    if (success) {
      // Drop the row from the local tracker — agent backend already
      // confirmed the PNR no longer exists.
      await ref.read(debugPnrsProvider.notifier).remove(r.pnr);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(resultMessage),
      backgroundColor: success ? AppColors.success : AppColors.error,
    ));
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear local PNR list?'),
        content: const Text(
            'Removes all entries from the local tracker. Does NOT call /orderCancel — PNRs in the agent account stay live.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Keep')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(debugPnrsProvider.notifier).clearAll();
  }
}

class _PnrTile extends StatelessWidget {
  final DebugPnrRecord record;
  final bool isCancelling;
  final VoidCallback onCancel;

  const _PnrTile({
    required this.record,
    required this.isCancelling,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final age = DateFormat('dd MMM, HH:mm').format(record.createdAt.toLocal());
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      record.pnr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.4,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        record.airType,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (record.routeLabel.isNotEmpty)
                  Text(
                    record.routeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (record.passengerLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      record.passengerLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'PKR ${record.amount.ceil()}  ·  $age',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isCancelling
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: onCancel,
                  tooltip: 'Cancel PNR via API',
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 22,
                  ),
                ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 48,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
