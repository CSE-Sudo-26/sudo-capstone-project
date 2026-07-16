import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:oncare_trainer/app/router/routes.dart';
import 'package:oncare_trainer/shared/models/trainer_client.dart';
import 'package:oncare_trainer/shared/services/client_repository.dart';

import '../../helpers/pump_app.dart';

/// Loading / error / not-found handling for the client detail body.
void main() {
  testWidgets('an unknown client id shows the not-found message instead '
      'of a nameless chat', (tester) async {
    await pumpTrainerApp(tester, token: 'demo-trainer-token');

    // Deep-link to a client that doesn't exist (stale link).
    final ctx = tester.element(find.text('고객 관리'));
    GoRouter.of(ctx).push(AppRoutes.clientDetail('no-such-client'));
    await settle(tester);

    expect(find.text('고객을 찾을 수 없어요'), findsOneWidget);
    // No chat composer / sub-tabs for a client that doesn't exist.
    expect(find.byType(TextField), findsNothing);
    expect(find.text('채팅'), findsNothing);

    // The escape hatch returns to the client list.
    await tester.tap(find.text('고객 목록으로'));
    await settle(tester);
    expect(find.text('고객 관리'), findsOneWidget);
  });

  testWidgets('a provider error shows the failure message with 다시 시도', (
    tester,
  ) async {
    await pumpTrainerApp(
      tester,
      token: 'demo-trainer-token',
      extraOverrides: <Override>[
        clientsProvider.overrideWith(
          (ref) => Stream<List<TrainerClient>>.error(StateError('db down')),
        ),
      ],
    );

    final ctx = tester.element(find.byType(Scaffold).first);
    GoRouter.of(ctx).push(AppRoutes.clientDetail('seed-client-1'));
    await settle(tester);

    expect(find.text('고객 정보를 불러오지 못했어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
    // Retry re-subscribes the stream — tapping must not throw.
    await tester.tap(find.text('다시 시도'));
    await settle(tester);
    expect(tester.takeException(), isNull);
  });
}
