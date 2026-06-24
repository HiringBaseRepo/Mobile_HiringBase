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

  testWidgets(
      'Applicant Flow: access via code → apply → track status',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── 1. Login as HR and create test job ──
    await loginAsHR(tester);
    await navigateToJobs(tester);
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(tester, find.text('Job Core'));

    final applyCode = await createTestJob(tester, Get.find<JobsController>());
    debugPrint('Test job apply code: $applyCode');

    // ── 2. Switch to Applicant ──
    await switchToApplicant(tester);

    // ── 3. Access Job via Apply Code ──
    final pvc = Get.find<PublicVacancyController>();
    pvc.jobCodeController.text = applyCode;
    await pvc.accessPrivateJob();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Apply for this Position'));

    // ── 4. Open Apply Form ──
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Lanjut ke Berkas'));

    // ── 5. Fill Personal Info ──
    final formFields = find.byType(TextField);
    final n = formFields.evaluate().length;

    await tester.enterText(formFields.at(0), TestConfig.applicantName);
    await tester.enterText(formFields.at(1), TestConfig.applicantEmail);
    await tester.enterText(formFields.at(2), TestConfig.applicantPhone);
    await tester.enterText(formFields.at(3), TestConfig.applicantLinkedin);
    await tester.enterText(formFields.at(4), TestConfig.applicantEducation);

    await tester.enterText(formFields.at(5), TestConfig.applicantEducationLevel);
    await tester.enterText(formFields.at(6), TestConfig.applicantExperienceYears);
    await tester.enterText(formFields.at(7), TestConfig.applicantExperienceSummary);
    await tester.enterText(formFields.at(8), TestConfig.applicantGithub);
    await tester.enterText(formFields.at(9), TestConfig.applicantPortfolio);

    if (n > 10) {
      await tester.enterText(formFields.at(10), TestConfig.applicantProfessionalExperience);
    }

    pvc.skills.assignAll(TestConfig.jobSkills);

    // ── 6. Document Upload ──
    pvc.nextStep();
    await tester.pump(TestConfig.shortWait);
    await pumpUntil(tester, find.text('Kirim Lamaran'));

    await injectTestDocuments(pvc);
    await tester.pump(TestConfig.shortWait);

    // ── 7. Submit Application ──
    await pvc.submitApplication();
    await tester.pump(TestConfig.longWait);
    await pumpUntil(tester, find.text('Application Submitted Successfully!'));

    final ticket = pvc.generatedTicket.value;
    expect(ticket, isNotEmpty, reason: 'Ticket code generated');
    debugPrint('Test application ticket: $ticket');

    // ── 8. Track Status ──
    pvc.currentStep.value = 5;
    await tester.pump(TestConfig.shortWait);

    pvc.trackTicketController.text = ticket;
    await pvc.trackApplication();
    await tester.pump(TestConfig.mediumWait);
    await pumpUntil(tester, find.text('Application Received'));

    expect(find.text('Application Received'), findsOneWidget,
        reason: 'Track status shows correct state');
  });
}
