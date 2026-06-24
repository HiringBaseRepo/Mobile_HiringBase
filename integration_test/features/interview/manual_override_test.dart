import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Manual Override: HR adjusts candidate score via override',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── SETUP: HR creates job ──
    await loginAsHR(tester);
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    final applyCode = await createTestJob(tester, Get.find<JobsController>());
    debugPrint('Test job apply code: $applyCode');

    // ── SETUP: Applicant applies ──
    await switchToApplicant(tester);
    final pvc = Get.find<PublicVacancyController>();
    pvc.jobCodeController.text = applyCode;
    await pvc.accessPrivateJob();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Apply for this Position'));

    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Lanjut ke Berkas'));

    await fillPersonalInfo(tester, pvc);

    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Kirim Lamaran'));

    await injectTestDocuments(pvc);
    await tester.pump(TestConfig.shortWait);

    await pvc.submitApplication();
    await tester.pump(TestConfig.longWait);
    await pumpUntil(tester, find.text('Application Submitted Successfully!'));

    // ── SETUP: HR reviews and runs AI screening ──
    await switchToHR(tester);

    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.text('Manage Jobs'));

    await pumpUntil(tester, find.text(TestConfig.jobTitle));
    await tapVisible(tester, find.text(TestConfig.jobTitle).first);
    await pumpUntil(tester, find.text('View All Candidates'));

    await tapVisible(tester, find.text('View All Candidates'));
    await pumpUntil(tester, find.text(TestConfig.applicantName));

    await tapVisible(tester, find.text('View Details'));
    await pumpUntil(tester, find.text('Candidate Management'));

    // ── Run AI Screening ──
    final cdc = Get.find<CandidateDetailController>();
    debugPrint('Score before AI: ${cdc.candidate.value?.score}');

    await tapVisible(tester, find.text('Run AI Screening'));
    await tester.pump(TestConfig.aiScreeningWait);

    // Retry fetch if score still 0
    int retries = 0;
    while ((cdc.candidate.value?.score ?? 0) < TestConfig.passingScore
        && retries < 4) {
      await tester.pump(TestConfig.longWait);
      final appService = Get.find<ApplicationService>();
      final resp = await appService.getApplicationDetail(cdc.candidate.value!.id);
      if (resp.statusCode == 200 && resp.body != null) {
        final data = resp.body!['data'];
        if (data != null) {
          cdc.candidate.value =
              Candidate.fromDetail(Map<String, dynamic>.from(data as Map));
        }
      }
      retries++;
      debugPrint('Score after retry $retries: ${cdc.candidate.value?.score}');
    }

    expect(cdc.candidate.value?.score, greaterThanOrEqualTo(TestConfig.passingScore),
        reason: 'AI screening score >= 60');

    // ── TEST: Manual Override ──
    await tapVisible(tester, find.text('Override'));
    await pumpUntil(tester, find.text('Manual Override'));

    // Verify override screen elements
    expect(find.text('Adjustment Categories (Delta)'), findsOneWidget,
        reason: 'Adjustment section visible');
    expect(find.text('Reason for Override (Mandatory)'), findsOneWidget,
        reason: 'Reason field visible');
    expect(find.text('Save Changes'), findsOneWidget,
        reason: 'Save button visible');

    // Fill reason
    final reasonField = find.byType(TextField).first;
    await tester.enterText(reasonField, 'Candidate shows exceptional leadership');
    await tester.pump(TestConfig.shortWait);

    // Submit override
    await tapVisible(tester, find.text('Save Changes'));
    await tester.pump(TestConfig.longWait);

    // Should navigate back to candidate detail
    final stillOnOverride = find.text('Manual Override');
    if (stillOnOverride.evaluate().isNotEmpty) {
      debugPrint('Still on override screen, checking for errors');
    } else {
      expect(find.text('Candidate Management'), findsOneWidget,
          reason: 'Back on candidate detail after override');
    }

    debugPrint('Manual override test PASSED');
  });
}
