import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:oncare_trainer/design_system/tokens/colors.dart';
import 'package:oncare_trainer/design_system/tokens/spacing.dart';
import 'package:oncare_trainer/features/clients/data/repositories/client_repository.dart';

/// Client detail screen. The full 채팅/식단/운동기록 sub-tabs ship in
/// their own issue; for now this confirms navigation + the selected
/// client, keeping a full-screen (no bottom nav) presentation.
class ClientDetailPage extends ConsumerWidget {
  /// Creates the detail screen for the client with [clientId].
  const ClientDetailPage({super.key, required this.clientId});

  /// Id of the client being viewed (from the route path).
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider).valueOrNull ?? const [];
    // (empty fallback keeps the header rendering while data loads)
    final match = clients.where((c) => c.id == clientId);
    final name = match.isNotEmpty ? match.first.name : '고객';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            '$name님 상세(채팅·식단·운동기록) 화면은 곧 준비됩니다',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedForeground),
          ),
        ),
      ),
    );
  }
}
