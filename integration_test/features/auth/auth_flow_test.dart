import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/services/app_service.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('HR Login Flow: role selection → sign in → dashboard → logout',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Role Selection Screen ──
    await pumpUntil(tester, find.text('Saya Rekruter'));
    expect(find.text('Saya Pelamar'), findsOneWidget,
        reason: 'Both role options visible');

    // ── 2. Select HR → Navigate to Login ──
    await tester.tap(find.text('Saya Rekruter'));
    await pumpUntil(tester, find.text('Sign In'));
    expect(find.text('Sign In'), findsOneWidget,
        reason: 'Login screen visible');

    // ── 3. Login with valid credentials ──
    final loginFields = find.byType(TextField);
    await tester.enterText(loginFields.at(0), TestConfig.hrEmail);
    await tester.enterText(loginFields.at(1), TestConfig.hrPassword);
    await tester.tap(find.text('Sign In'));
    await pumpUntil(tester, find.text('Dashboard'));

    // ── 4. Verify Dashboard ──
    expect(Get.find<AppService>().isHR, isTrue,
        reason: 'HR role confirmed after login');
    expect(find.text('Dashboard'), findsOneWidget,
        reason: 'Dashboard screen visible');
    expect(find.text('Dashboard'), findsWidgets,
        reason: 'Dashboard tab visible');
    expect(find.text('Jobs'), findsWidgets,
        reason: 'Jobs tab visible');
    expect(find.text('Profile'), findsWidgets,
        reason: 'Profile tab visible');

    // ── 5. Logout ──
    Get.find<AppService>().logout();
    Get.offAllNamed('/selection');
    await pumpUntil(tester, find.text('Saya Rekruter'));

    expect(Get.find<AppService>().isHR, isFalse,
        reason: 'HR role cleared after logout');
    expect(find.text('Saya Rekruter'), findsOneWidget,
        reason: 'Back at role selection');
  });
}
