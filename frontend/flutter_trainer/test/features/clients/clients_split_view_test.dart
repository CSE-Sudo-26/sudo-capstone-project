import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

/// Master-detail split on wide viewports (≥ AppLayout.splitBreakpoint).
void main() {
  Future<void> openWide(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpTrainerApp(tester, token: 'demo-trainer-token');
  }

  testWidgets('wide viewport shows the list and an embedded detail panel', (
    tester,
  ) async {
    await openWide(tester);

    // List content + detail panel side by side — the first client's
    // 채팅 opens by default, with NO push (no back button).
    expect(find.text('고객 관리'), findsWidgets);
    expect(find.text('채팅'), findsOneWidget);
    expect(find.text('식단'), findsOneWidget);
    expect(find.textContaining('AI가 김민수님의'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
  });

  testWidgets('selecting another client swaps the panel in place', (
    tester,
  ) async {
    await openWide(tester);

    await tester.tap(find.text('이지수'));
    await settle(tester);

    expect(find.textContaining('AI가 이지수님의'), findsOneWidget);
    expect(find.textContaining('AI가 김민수님의'), findsNothing);
    // Still embedded — no full-screen push happened.
    expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
  });

  testWidgets('a chat draft does not leak into another client', (tester) async {
    await openWide(tester);

    await tester.enterText(find.byType(TextField), '민수님 오늘 어땠어요?');
    await tester.pump();

    await tester.tap(find.text('이지수'));
    await settle(tester);

    // The composer resets with the client — no cross-client draft.
    expect(find.text('민수님 오늘 어땠어요?'), findsNothing);
  });

  testWidgets('sub-tab selection survives switching clients', (tester) async {
    await openWide(tester);

    // Open 식단 for 김민수 (2100mg)…
    await tester.tap(find.text('식단'));
    await settle(tester);
    expect(find.text('오늘 영양 요약'), findsOneWidget);
    expect(find.text('2100'), findsOneWidget);

    // …switch to 박성호: same sub-tab, his data (2400mg).
    await tester.tap(find.text('박성호'));
    await settle(tester);
    expect(find.text('오늘 영양 요약'), findsOneWidget);
    expect(find.text('2400'), findsOneWidget);
  });
}
