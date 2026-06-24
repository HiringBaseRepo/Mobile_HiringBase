import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login Error Handling: wrong credentials should show error',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Navigate to HR Login ──
    await pumpUntil(tester, find.text('Saya Rekruter'));
    await tester.tap(find.text('Saya Rekruter'));
    await pumpUntil(tester, find.text('Sign In'));

    // ── 2. Try login with wrong password ──
    final loginFields = find.byType(TextField);
    await tester.enterText(loginFields.at(0), 'test.hr@hiringbase.com');
    await tester.enterText(loginFields.at(1), 'wrongpassword123');
    await tester.tap(find.text('Sign In'));
    await tester.pump(TestConfig.longWait);

    // ── 3. Should stay on login page ──
    expect(find.text('Sign In'), findsOneWidget,
        reason: 'Stayed on login after wrong credentials');

    // ── 4. Should not navigate to Dashboard ──
    expect(find.text('Dashboard'), findsNothing,
        reason: 'Did NOT navigate to Dashboard');
  });

  testWidgets('Login Error Handling: empty fields should show validation',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Navigate to HR Login ──
    await pumpUntil(tester, find.text('Saya Rekruter'));
    await tester.tap(find.text('Saya Rekruter'));
    await pumpUntil(tester, find.text('Sign In'));

    // ── 2. Try login with empty fields ──
    await tester.tap(find.text('Sign In'));
    await tester.pump(TestConfig.shortWait);

    // ── 3. Should stay on login page ──
    expect(find.text('Sign In'), findsOneWidget,
        reason: 'Stayed on login with empty fields');
    expect(find.text('Dashboard'), findsNothing,
        reason: 'Did NOT navigate to Dashboard with empty fields');
  });

  testWidgets('Role Selection: app starts at selection screen',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. App should start at selection screen ──
    await pumpUntil(tester, find.text('Saya Rekruter'));
    expect(find.text('Saya Rekruter'), findsOneWidget,
        reason: 'HR role option visible');
    expect(find.text('Saya Pelamar'), findsOneWidget,
        reason: 'Applicant role option visible');

    // ── 2. Not on Dashboard (not logged in) ──
    expect(find.text('Dashboard'), findsNothing,
        reason: 'Not on Dashboard before login');
    expect(find.text('Sign In'), findsNothing,
        reason: 'Not on login screen before role selection');
  });

  testWidgets('Navigation Guard: cannot access HR pages without login',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Directly try to access home route ──
    Get.offAllNamed('/home');
    await tester.pump(TestConfig.mediumWait);

    // ── 2. Should redirect to selection (auth guard) ──
    // AuthMiddleware should redirect to selection since not logged in
    final onSelection = find.text('Saya Rekruter');
    final onDashboard = find.text('Dashboard');

    if (onSelection.evaluate().isNotEmpty) {
      expect(onSelection, findsOneWidget,
          reason: 'Auth guard redirected to selection');
    } else if (onDashboard.evaluate().isNotEmpty) {
      // This should NOT happen - auth guard failed
      expect(find.text('Dashboard'), findsNothing,
          reason: 'Auth guard should have blocked direct access');
    }
  });
}
