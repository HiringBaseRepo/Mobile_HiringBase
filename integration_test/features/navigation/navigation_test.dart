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

  testWidgets('Navigation Flow: bottom nav tabs and role switching',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Login as HR ──
    await loginAsHR(tester);

    // ── 2. Verify bottom nav tabs visible ──
    expect(find.text('Dashboard'), findsWidgets, reason: 'Dashboard tab visible');
    expect(find.text('Jobs'), findsWidgets, reason: 'Jobs tab visible');
    expect(find.text('Profile'), findsWidgets, reason: 'Profile tab visible');

    // ── 3. Navigate to each tab ──
    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.byIcon(Icons.add));
    expect(find.byIcon(Icons.add), findsOneWidget,
        reason: 'Jobs tab has add button');

    await navigateToTab(tester, 'Profile');
    await tester.pump(TestConfig.shortWait);
    // Profile may show user info
    expect(Get.find<AppService>().isHR, isTrue,
        reason: 'HR still logged in on profile');

    // ── 4. Navigate back to Dashboard ──
    await navigateToTab(tester, 'Dashboard');
    await pumpUntil(tester, find.text('Dashboard'));
    expect(find.text('Dashboard'), findsOneWidget,
        reason: 'Back on Dashboard');
  });
}
