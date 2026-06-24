import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import 'helpers/test_helpers.dart';
import 'helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E: HR creates full job, applicant applies, AI screening passes',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ═══════════════════════════════════════════════════════════════════════
    // 1. HR LOGIN + JOB CREATION
    // ═══════════════════════════════════════════════════════════════════════

    // HR Login via UI (full E2E flow)
    await loginAsHR(tester);

    // Navigate to Jobs → Create Job
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    // Create full job with all fields, scoring weights, and publish
    final applyCode = await createTestJob(tester, Get.find<JobsController>());
    expect(applyCode, isNotEmpty, reason: 'Got apply code');
    debugPrint('Published apply code: $applyCode');

    // ═══════════════════════════════════════════════════════════════════════
    // 2. APPLICANT FLOW
    // ═══════════════════════════════════════════════════════════════════════

    // Switch to applicant
    await switchToApplicant(tester);

    // Access job via apply code
    final pvc = Get.find<PublicVacancyController>();
    pvc.jobCodeController.text = applyCode;
    await pvc.accessPrivateJob();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Apply for this Position'));

    // Fill and submit application using reusable helper
    await applyForJob(tester, applyCode);

    final ticketCode = pvc.generatedTicket.value;
    expect(ticketCode, isNotEmpty, reason: 'Got ticket code');
    debugPrint('Application ticket: $ticketCode');

    // ═══════════════════════════════════════════════════════════════════════
    // 3. HR SCREENING
    // ═══════════════════════════════════════════════════════════════════════

    // Switch back to HR
    await switchToHR(tester);
    expect(Get.find<AppService>().isHR, isTrue, reason: 'HR re-login ok');

    // Navigate to Jobs tab
    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.text('Manage Jobs'));

    // Find and tap the test job
    await pumpUntil(tester, find.text(TestConfig.jobTitle));
    await tapVisible(tester, find.text(TestConfig.jobTitle).first);
    await pumpUntil(tester, find.text('View All Candidates'));

    // View All Candidates
    await tapVisible(tester, find.text('View All Candidates'));
    await pumpUntil(tester, find.text(TestConfig.applicantName));

    // View Candidate Details
    await tapVisible(tester, find.text('View Details'));
    await pumpUntil(tester, find.text('Candidate Management'));

    // ── Run AI Screening ──
    final cdc = Get.find<CandidateDetailController>();
    final scoreBefore = cdc.candidate.value?.score ?? -1;
    debugPrint('Score before AI screening: $scoreBefore');

    await tapVisible(tester, find.text('Run AI Screening'));

    // Poll until screening completes
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

    await tester.pumpAndSettle();

    // ═══════════════════════════════════════════════════════════════════════
    // 4. VERIFY AI SCREENING PASSED
    // ═══════════════════════════════════════════════════════════════════════

    final scoreAfter = cdc.candidate.value?.score ?? -1;
    final statusAfter = cdc.candidate.value?.status ?? '';
    final matchText = cdc.candidate.value?.matchText ?? '';
    final scoreData = cdc.candidate.value?.scoreData;

    debugPrint('Score after AI screening: $scoreAfter');
    debugPrint('Status: $statusAfter');
    debugPrint('Match text: $matchText');
    debugPrint('Score data: ${scoreData?.finalScore}');

    // Core assertions
    expect(find.text('Candidate Management'), findsOneWidget,
        reason: 'Still on candidate detail after screening');
    expect(scoreAfter, greaterThanOrEqualTo(TestConfig.passingScore),
        reason: 'AI score should be >= 60 (PASS threshold)');
    expect(statusAfter.isNotEmpty, isTrue,
        reason: 'Status should be populated after screening');
    expect(matchText.isNotEmpty, isTrue,
        reason: 'Match text should be present');

    // Score breakdown verification
    expect(scoreData, isNotNull,
        reason: 'Score data should exist after screening');
    if (scoreData != null) {
      expect(scoreData.skillMatchScore, greaterThanOrEqualTo(0),
          reason: 'skill_match present in breakdown');
      expect(scoreData.finalScore, greaterThanOrEqualTo(0),
          reason: 'final_score present in breakdown');
    }

    // AI Insights UI verification
    await tester.ensureVisible(find.text('AI INSIGHTS'));
    await tester.pump();
    expect(find.text('AI INSIGHTS'), findsOneWidget,
        reason: 'AI Insights card visible');
    expect(find.text('$scoreAfter'), findsWidgets,
        reason: 'Score number displayed');
    expect(find.text('Skill Match'), findsWidgets,
        reason: 'Skill Match component visible');
    expect(find.text('Experience'), findsWidgets,
        reason: 'Experience component visible');
    expect(find.text('Education'), findsWidgets,
        reason: 'Education component visible');
    expect(find.text('Portfolio'), findsWidgets,
        reason: 'Portfolio component visible');

    debugPrint('=== E2E AI SCREENING TEST PASSED ===');
  });
}
