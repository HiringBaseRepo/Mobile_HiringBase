import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Job CRUD Flow: multi-step create → publish → verify apply code',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Login as HR ──
    await loginAsHR(tester);

    // ── 2. Navigate to Jobs List ──
    await navigateToJobs(tester);

    // ── 3. Start Create Job ──
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    final jc = Get.find<JobsController>();

    // ── 4. Step 1: Job Core ──
    await tester.enterText(find.byType(TextField).at(0), TestConfig.jobTitle);
    await tester.enterText(find.byType(TextField).at(3), TestConfig.jobDescription);

    await jc.nextStep();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Requirement Builder'));

    // ── 5. Step 2: Requirements ──
    await addJobSkills(tester, TestConfig.jobSkills);

    await jc.nextStep();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Applicant Form Setup'));

    // ── 6. Step 3: Form Setup ──
    jc.formFieldsPreview.addAll([
      {'label': 'Education Level', 'is_required': true},
      {'label': 'Experience Years', 'is_required': true},
      {'label': 'Experience Summary', 'is_required': false},
      {'label': 'Skills', 'is_required': false},
      {'label': 'GitHub URL', 'is_required': false},
      {'label': 'Live Project URL', 'is_required': false},
    ]);
    await tester.pump(const Duration(milliseconds: 500));

    await jc.nextStep();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Publish Control'));

    // ── 7. Step 4: Publish ──
    await jc.nextStep();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Vacancy Published Successfully!'));

    // ── 8. Verify Publish Result ──
    final applyCode = jc.publishedApplyCode.value;
    expect(applyCode, isNotEmpty, reason: 'Apply code generated on publish');
    expect(find.text('Vacancy Published Successfully!'), findsOneWidget,
        reason: 'Success message shown');
    debugPrint('Test: Created job with apply code: $applyCode');
  });
}
