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

  testWidgets('sub-tabs are focusable buttons (keyboard-accessible)', (
    tester,
  ) async {
    await pumpTrainerApp(tester, token: 'demo-trainer-token');
    await tester.tap(find.text('김민수'));
    await settle(tester);
    expect(find.text('채팅'), findsOneWidget);

    // Each sub-tab now sits in an InkWell (focus traversal + Enter/Space
    // activation) wrapped in Semantics(button: true), not a bare
    // GestureDetector — so it is keyboard-reachable on desktop/web.
    for (final label in <String>['채팅', '식단', '운동기록']) {
      expect(
        find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
        findsOneWidget,
        reason: '$label 탭이 포커스 가능한 InkWell 안에 있어야 함',
      );
    }

    // Activation still switches the tab (pointer path unchanged).
    await tester.tap(find.text('식단'));
    await settle(tester);
    expect(find.text('오늘 영양 요약'), findsOneWidget);
  });
}
