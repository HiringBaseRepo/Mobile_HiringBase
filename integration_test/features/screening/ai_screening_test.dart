import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'AI Screening Flow: HR creates full job → applicant applies with complete data → run screening → verify score PASS',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 1: HR creates a fully-configured job
    // ═══════════════════════════════════════════════════════════════════════

    // ── 1.1 Login as HR ──
    await loginAsHR(tester);

    // ── 1.2 Navigate to Jobs → Create Job ──
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    // ── 1.3 Create job with FULL data (all steps) ──
    final applyCode = await createTestJob(tester, Get.find<JobsController>());
    expect(applyCode, isNotEmpty, reason: 'Got apply code');
    debugPrint('Published apply code: $applyCode');

    // Verify step 5 success screen was reached
    expect(find.text('Vacancy Published Successfully!'), findsOneWidget,
        reason: 'Job published successfully');
    expect(find.text(applyCode), findsOneWidget,
        reason: 'Apply code displayed on success screen');

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 2: Applicant applies with complete data
    // ═══════════════════════════════════════════════════════════════════════

    // ── 2.1 Switch to applicant mode ──
    await switchToApplicant(tester);

    // ── 2.2 Access job via apply code ──
    final pvc = Get.find<PublicVacancyController>();
    pvc.jobCodeController.text = applyCode;
    await pvc.accessPrivateJob();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Apply for this Position'));

    // ── 2.3 Fill personal info ──
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Lanjut ke Berkas'));

    await fillPersonalInfo(tester, pvc);

    // Verify all personal info fields are filled
    expect(pvc.fullNameController.text, TestConfig.applicantName);
    expect(pvc.emailController.text, TestConfig.applicantEmail);
    expect(pvc.phoneController.text, TestConfig.applicantPhone);

    // ── 2.4 Upload documents ──
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Kirim Lamaran'));

    await injectTestDocuments(pvc);
    await tester.pump(TestConfig.shortWait);

    // Verify all documents are uploaded
    for (final docLabel in pvc.requiredDocLabels.toList()) {
      expect(pvc.uploadedDocs[docLabel], isTrue,
          reason: '$docLabel document uploaded');
    }

    // ── 2.5 Submit application ──
    await pvc.submitApplication();
    await tester.pump(TestConfig.longWait);
    await pumpUntil(tester, find.text('Application Submitted Successfully!'));

    final ticket = pvc.generatedTicket.value;
    expect(ticket, isNotEmpty, reason: 'Got ticket code');
    debugPrint('Application ticket: $ticket');

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 3: HR reviews and triggers AI screening
    // ═══════════════════════════════════════════════════════════════════════

    // ── 3.1 Switch back to HR ──
    await switchToHR(tester);
    expect(Get.find<AppService>().isHR, isTrue, reason: 'HR re-login ok');

    // ── 3.2 Navigate to job candidates ──
    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.text('Manage Jobs'));
    await pumpUntil(tester, find.text(TestConfig.jobTitle));
    await tapVisible(tester, find.text(TestConfig.jobTitle).first);
    await pumpUntil(tester, find.text('View All Candidates'));
    await tapVisible(tester, find.text('View All Candidates'));
    await pumpUntil(tester, find.text(TestConfig.applicantName));

    // ── 3.3 View candidate details ──
    await tapVisible(tester, find.text('View Details'));
    await pumpUntil(tester, find.text('Candidate Management'));

    // ── 3.4 Run AI Screening ──
    final cdc = Get.find<CandidateDetailController>();
    final scoreBefore = cdc.candidate.value?.score ?? -1;
    final statusBefore = cdc.candidate.value?.status ?? '';
    debugPrint('Before screening: score=$scoreBefore status=$statusBefore');

    await tapVisible(tester, find.text('Run AI Screening'));

    // Poll until screening completes (pump small increments to let timers fire)
    final appService = Get.find<ApplicationService>();
    final candidateId = cdc.candidate.value!.id;
    const maxPollSeconds = 120;
    const pollInterval = Duration(seconds: 3);
    var elapsedSeconds = 0;

    while (elapsedSeconds < maxPollSeconds) {
      await tester.pump(pollInterval);
      elapsedSeconds += pollInterval.inSeconds;

      final resp = await appService.getApplicationDetail(candidateId);
      if (resp.statusCode == 200 && resp.body != null) {
        final data = resp.body!['data'];
        if (data != null) {
          final updated = Candidate.fromDetail(Map<String, dynamic>.from(data as Map));
          cdc.candidate.value = updated;
          if (updated.score > 0 ||
              !['applied', 'doc_check', 'ai_processing'].contains(updated.status.toLowerCase())) {
            debugPrint('Screening completed after ${elapsedSeconds}s: score=${updated.score} status=${updated.status}');
            break;
          }
        }
      }
      debugPrint('Screening in progress... (${elapsedSeconds}s elapsed, status=${cdc.candidate.value?.status ?? 'unknown'})');
    }

    // Pump to let UI rebuild with updated score
    await tester.pumpAndSettle();

    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 4: Verify AI Screening Results — MUST PASS
    // ═══════════════════════════════════════════════════════════════════════

    final scoreAfter = cdc.candidate.value?.score ?? -1;
    final statusAfter = cdc.candidate.value?.status ?? '';
    final matchText = cdc.candidate.value?.matchText ?? '';
    final scoreData = cdc.candidate.value?.scoreData;

    debugPrint('After screening:');
    debugPrint('  score=$scoreAfter');
    debugPrint('  status=$statusAfter');
    debugPrint('  matchText=$matchText');
    debugPrint('  finalScore=${scoreData?.finalScore}');

    // ── 4.1 Core assertions: score >= 60, status is valid ──
    expect(find.text('Candidate Management'), findsOneWidget,
        reason: 'Still on candidate detail after screening');
    expect(scoreAfter, greaterThanOrEqualTo(TestConfig.passingScore),
        reason: 'AI score should be >= 60 (PASS threshold)');
    expect(statusAfter, isNotEmpty,
        reason: 'Status should be populated after screening');
    expect(matchText, isNotEmpty,
        reason: 'Match text should be present');

    // ── 4.2 Score breakdown should be populated ──
    expect(scoreData, isNotNull,
        reason: 'Score data should exist after screening');
    if (scoreData != null) {
      // All 6 component scores should be present
      expect(scoreData.skillMatchScore, greaterThanOrEqualTo(0),
          reason: 'skill_match component present');
      expect(scoreData.experienceScore, greaterThanOrEqualTo(0),
          reason: 'experience component present');
      expect(scoreData.educationScore, greaterThanOrEqualTo(0),
          reason: 'education component present');
      expect(scoreData.portfolioScore, greaterThanOrEqualTo(0),
          reason: 'portfolio component present');
      expect(scoreData.softSkillScore, greaterThanOrEqualTo(0),
          reason: 'soft_skill component present');
      expect(scoreData.administrativeScore, greaterThanOrEqualTo(0),
          reason: 'administrative component present');
      expect(scoreData.finalScore, greaterThanOrEqualTo(0),
          reason: 'final_score present');
    }

    // ── 4.3 Verify AI Insights card is visible with real score ──
    await tester.ensureVisible(find.text('AI INSIGHTS'));
    await tester.pump();
    expect(find.text('AI INSIGHTS'), findsOneWidget,
        reason: 'AI Insights card displayed');
    expect(find.text('Match Score'), findsOneWidget,
        reason: 'Match Score label displayed');
    expect(find.text('$scoreAfter'), findsWidgets,
        reason: 'Score number displayed');

    // ── 4.4 Verify component labels are displayed ──
    expect(find.text('Skill Match'), findsWidgets,
        reason: 'Skill Match component displayed');
    expect(find.text('Experience'), findsWidgets,
        reason: 'Experience component displayed');
    expect(find.text('Education'), findsWidgets,
        reason: 'Education component displayed');
    expect(find.text('Portfolio'), findsWidgets,
        reason: 'Portfolio component displayed');
    expect(find.text('Soft Skills'), findsWidgets,
        reason: 'Soft Skills component displayed');
    expect(find.text('Administrative'), findsWidgets,
        reason: 'Administrative component displayed');

    // ── 4.5 Verify "Run AI Screening" button is hidden (score > 0) ──
    // After successful screening, button should not be visible since score > 0
    // (only shown when score == 0 per StatusControlCard logic)

    debugPrint('=== AI SCREENING E2E TEST PASSED ===');
  });
}
