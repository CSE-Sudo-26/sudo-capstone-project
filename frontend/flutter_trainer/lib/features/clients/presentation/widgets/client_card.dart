import 'package:flutter/material.dart';

import 'package:oncare_trainer/design_system/tokens/colors.dart';
import 'package:oncare_trainer/design_system/tokens/radius.dart';
import 'package:oncare_trainer/design_system/tokens/spacing.dart';
import 'package:oncare_trainer/features/clients/domain/entities/trainer_client.dart';

/// A client row on the 고객 관리 list: avatar + active dot, name, goal,
/// last message, and a quick-metric footer (칼로리 / 나트륨 / 마지막 루틴).
class ClientCard extends StatelessWidget {
  /// Creates a card for [client]; [onTap] opens the detail screen.
  const ClientCard({super.key, required this.client, required this.onTap});

  /// The client to render.
  final TrainerClient client;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: const BorderRadius.all(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _Avatar(label: client.avatar, active: client.active),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                client.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.foreground,
                                ),
                              ),
                            ),
                            Text(
                              client.lastTime,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.disabledForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          client.goal,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.subtleForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          client.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.disabledForeground,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(height: 1, color: AppColors.borderStrong),
              ),
              Row(
                children: <Widget>[
                  _Metric(label: '칼로리', value: '${client.calories}kcal'),
                  _Metric(
                    label: '나트륨',
                    value: '${client.sodiumMg}mg',
                    warn: client.sodiumOverBudget,
                  ),
                  _Metric(label: '마지막 루틴', value: client.lastRoutine),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColors.accent, AppColors.accentDark],
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.accentForeground,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? AppColors.success : AppColors.disabledForeground,
                border: Border.all(color: AppColors.card, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.warn = false});

  final String label;
  final String value;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.subtleForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: warn ? AppColors.warning : AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
