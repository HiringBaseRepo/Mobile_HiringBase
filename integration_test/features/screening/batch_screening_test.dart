import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

/// Second applicant data (different from TestConfig to avoid duplicate).
const _secondName = 'BUDI SANTOSO';
const _secondEmail = 'test.applicant2@e2e.com';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Batch Screening: HR creates job → 2 applicants apply → select all → run batch screening',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 1: HR creates a job
    // ═══════════════════════════════════════════════════════════════════════

    await loginAsHR(tester);
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    final applyCode = await createTestJob(tester, Get.find<JobsController>());
    expect(applyCode, isNotEmpty, reason: 'Got apply code');
    debugPrint('Batch test apply code: $applyCode');

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 2: First applicant applies
    // ═══════════════════════════════════════════════════════════════════════

    await switchToApplicant(tester);

    await applyForJob(tester, applyCode);
    debugPrint('First applicant applied');

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 3: Second applicant applies (different email)
    // ═══════════════════════════════════════════════════════════════════════

    // Already in applicant mode — go back to vacancy
    final pvc = Get.find<PublicVacancyController>();
    pvc.jobCodeController.text = applyCode;
    await pvc.accessPrivateJob();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Lamar Posisi Ini'));

    // Open apply form
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Lanjut ke Berkas'));

    // Fill personal info with SECOND applicant data
    final formFields = find.byType(TextField);
    await tester.enterText(formFields.at(0), _secondName);
    await tester.enterText(formFields.at(1), _secondEmail);
    await tester.enterText(formFields.at(2), TestConfig.applicantPhone);
    await tester.enterText(formFields.at(3), TestConfig.applicantLinkedin);
    await tester.enterText(formFields.at(4), TestConfig.applicantEducation);
    if (formFields.evaluate().length > 5) {
      await tester.enterText(formFields.at(5), TestConfig.applicantEducationLevel);
    }
    if (formFields.evaluate().length > 6) {
      await tester.enterText(formFields.at(6), TestConfig.applicantExperienceYears);
    }
    pvc.skills.assignAll(TestConfig.jobSkills);

    // Upload docs
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Kirim Lamaran'));

    await injectTestDocuments(pvc);
    await tester.pump(TestConfig.shortWait);

    // Submit
    await pvc.submitApplication();
    await tester.pump(TestConfig.longWait);
    await pumpUntil(tester, find.text('Lamaran Berhasil Dikirim!'));
    debugPrint('Second applicant applied');

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 4: HR enters selection mode, selects candidates, runs batch
    // ═══════════════════════════════════════════════════════════════════════

    await switchToHR(tester);
    expect(Get.find<AppService>().isHR, isTrue, reason: 'HR re-login ok');

    // Navigate to candidates list
    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.text('Manage Jobs'));
    await pumpUntil(tester, find.text(TestConfig.jobTitle));
    await tapVisible(tester, find.text(TestConfig.jobTitle).first);
    await pumpUntil(tester, find.text('View All Candidates'));
    await tapVisible(tester, find.text('View All Candidates'));
    await pumpUntil(tester, find.text(TestConfig.applicantName));

    // ── 4.1 Enter selection mode (tap checklist icon in AppBar) ──
    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pump(TestConfig.shortWait);

    final ccc = Get.find<CandidatesController>();
    expect(ccc.isSelectionMode.value, isTrue,
        reason: 'Selection mode activated');

    // ── 4.2 Select all candidates ──
    await tapVisible(tester, find.text('Select All'));
    await tester.pump(TestConfig.shortWait);

    expect(ccc.selectedIds.length, greaterThanOrEqualTo(2),
        reason: 'At least 2 candidates selected');
    debugPrint('Selected ${ccc.selectedIds.length} candidates');

    // ── 4.3 Verify batch bar is visible ──
    expect(find.textContaining('Run AI Screening'), findsOneWidget,
        reason: 'Batch action bar visible');

    // ── 4.4 Run batch screening ──
    await tapVisible(tester, find.textContaining('Run AI Screening'));
    await tester.pump(TestConfig.mediumWait);

    // Verify selection mode is exited after batch submission
    expect(ccc.isSelectionMode.value, isFalse,
        reason: 'Selection mode exited after batch submission');

    debugPrint('=== BATCH SCREENING E2E TEST PASSED ===');
  });
}
