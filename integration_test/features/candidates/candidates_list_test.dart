import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';

import 'package:uifrontendmobile/main.dart' as app;
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Candidates List: view all candidates under a job',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── SETUP: Create job + applicant applies ──
    await loginAsHR(tester);
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    final applyCode = await createTestJob(tester, Get.find<JobsController>());

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

    // ── TEST: HR views candidates ──
    await switchToHR(tester);

    await navigateToTab(tester, 'Jobs');
    await pumpUntil(tester, find.text('Manage Jobs'));

    await pumpUntil(tester, find.text(TestConfig.jobTitle));
    await tapVisible(tester, find.text(TestConfig.jobTitle).first);
    await pumpUntil(tester, find.text('View All Candidates'));

    // View all candidates
    await tapVisible(tester, find.text('View All Candidates'));
    await pumpUntil(tester, find.text(TestConfig.applicantName));

    // ── Verify candidate appears in list ──
    expect(find.text(TestConfig.applicantName), findsWidgets,
        reason: 'Candidate name visible in list');
  });
}
