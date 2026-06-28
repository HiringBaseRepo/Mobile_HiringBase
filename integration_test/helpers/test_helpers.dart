import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/modules/public_vacancy/controllers/public_vacancy_controller.dart';
import 'package:uifrontendmobile/app/modules/jobs/controllers/jobs_controller.dart';

import 'test_config.dart';

Future<void> pumpUntil(WidgetTester tester, Finder finder,
    {Duration timeout = TestConfig.pumpTimeout, bool settle = false}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) {
      if (settle) await tester.pumpAndSettle();
      return;
    }
  }
  if (settle) await tester.pumpAndSettle();
  expect(finder, findsOneWidget,
      reason: 'Timed out waiting for: $finder');
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder, warnIfMissed: false);
}

Future<void> dismissKeyboard(WidgetTester tester) async {
  await tester.tapAt(const Offset(0, 0));
  await tester.pump(const Duration(milliseconds: 500));
}

Future<void> injectTestDocuments(PublicVacancyController pvc) async {
  for (final docLabel in pvc.requiredDocLabels.toList()) {
    final filename = TestConfig.testDocuments[docLabel];
    if (filename != null) {
      final file = File('${TestConfig.testDocDir}/$filename');
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        pvc.selectedFiles[docLabel] = PlatformFile(
          name: filename,
          size: bytes.length,
          bytes: bytes,
        );
        pvc.uploadedDocs[docLabel] = true;
      }
    }
  }
}

Future<void> loginAsHR(WidgetTester tester) async {
  await pumpUntil(tester, find.text('Saya Rekruter'));
  await tester.tap(find.text('Saya Rekruter'));
  await pumpUntil(tester, find.text('Sign In'));

  final loginFields = find.byType(TextField);
  await tester.enterText(loginFields.at(0), TestConfig.hrEmail);
  await tester.enterText(loginFields.at(1), TestConfig.hrPassword);
  await tester.tap(find.text('Sign In'));
  await pumpUntil(tester, find.text('Dashboard'));

  expect(Get.find<AppService>().isHR, isTrue, reason: 'HR login ok');
}

Future<void> navigateToTab(WidgetTester tester, String tabLabel) async {
  await tester.tap(find.text(tabLabel));
  await tester.pump(TestConfig.mediumWait);
}

Future<void> navigateToJobs(WidgetTester tester) async {
  await navigateToTab(tester, 'Jobs');
  await pumpUntil(tester, find.byIcon(Icons.add));
}

Future<void> addJobSkills(WidgetTester tester, List<String> skills) async {
  final stepFields = find.byType(TextField);
  for (final skill in skills) {
    await tester.enterText(stepFields.at(0), skill);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 500));
  }
}

Future<void> fillPersonalInfo(WidgetTester tester, PublicVacancyController pvc) async {
  final formFields = find.byType(TextField);
  final n = formFields.evaluate().length;

  await tester.enterText(formFields.at(0), TestConfig.applicantName);
  await tester.enterText(formFields.at(1), TestConfig.applicantEmail);
  await tester.enterText(formFields.at(2), TestConfig.applicantPhone);
  await tester.enterText(formFields.at(3), TestConfig.applicantLinkedin);
  await tester.enterText(formFields.at(4), TestConfig.applicantEducation);

  await tester.enterText(formFields.at(5), TestConfig.applicantEducationLevel);
  await tester.enterText(formFields.at(6), TestConfig.applicantExperienceYears);
  await tester.enterText(formFields.at(7), TestConfig.applicantGithub);
  await tester.enterText(formFields.at(8), TestConfig.applicantPortfolio);

  if (n > 9) {
    await tester.enterText(formFields.at(9), TestConfig.applicantProfessionalExperience);
  }

  pvc.skills.assignAll(TestConfig.jobSkills);
}

Future<String> createTestJob(WidgetTester tester, JobsController jc) async {
  // Step 1: Job Core — fill ALL text fields
  await tester.enterText(find.byType(TextField).at(0), TestConfig.jobTitle);
  await tester.enterText(find.byType(TextField).at(1), TestConfig.salaryMin);
  await tester.enterText(find.byType(TextField).at(2), TestConfig.salaryMax);
  await tester.enterText(find.byType(TextField).at(3), TestConfig.jobDescription);
  await tester.enterText(find.byType(TextField).at(4), TestConfig.jobResponsibilities);
  await tester.enterText(find.byType(TextField).at(5), TestConfig.jobBenefits);

  // Set dropdowns via controller (faster than UI interaction)
  jc.department.value = TestConfig.department;
  jc.employmentType.value = TestConfig.employmentType;
  jc.location.value = TestConfig.location;

  await jc.nextStep();
  await tester.pump(TestConfig.mediumWait);
  await pumpUntil(tester, find.text('Requirement Builder'));

  // Step 2: Requirements — set skills directly via controller (bypasses chip input)
  jc.requiredSkills.assignAll(TestConfig.jobSkills);
  jc.preferredSkills.assignAll(TestConfig.preferredSkills);

  // Experience & education dropdowns via controller
  jc.minExperience.value = TestConfig.minExperience;
  jc.educationMin.value = TestConfig.educationMin;

  await jc.nextStep();
  await tester.pump(TestConfig.mediumWait);
  await pumpUntil(tester, find.text('Applicant Form Setup'));

  // Step 3: Form Setup — custom form fields for AI scoring parser
  // Note: Skills field is needed so backend saves skills value in ApplicationAnswer
  jc.formFieldsPreview.addAll([
    {'label': 'Education Level', 'is_required': true},
    {'label': 'Experience Years', 'is_required': true},
    {'label': 'Skills', 'is_required': false},
    {'label': 'GitHub URL', 'is_required': false},
    {'label': 'Live Project URL', 'is_required': false},
  ]);
  await tester.pump(const Duration(milliseconds: 500));

  await jc.nextStep();
  await tester.pump(TestConfig.mediumWait);
  await pumpUntil(tester, find.text('Publish Control'));

  // Step 4: Set scoring template weights via controller
  jc.skillMatchWeight.value = TestConfig.skillWeight.toDouble();
  jc.experienceWeight.value = TestConfig.experienceWeight.toDouble();
  jc.educationWeight.value = TestConfig.educationWeight.toDouble();
  jc.portfolioWeight.value = TestConfig.portfolioWeight.toDouble();
  jc.softSkillWeight.value = TestConfig.softSkillWeight.toDouble();
  jc.administrativeWeight.value = TestConfig.adminWeight.toDouble();
  jc.publishMode.value = TestConfig.publishMode;

  await jc.nextStep();
  await tester.pump(TestConfig.mediumWait);
  await pumpUntil(tester, find.text('Vacancy Published Successfully!'));

  final applyCode = jc.publishedApplyCode.value;
  expect(applyCode, isNotEmpty, reason: 'Got apply code');
  debugPrint('Published apply code: $applyCode');
  return applyCode ?? '';
}

Future<void> switchToApplicant(WidgetTester tester) async {
  Get.find<AppService>().logout();
  Get.offAllNamed('/selection');
  await pumpUntil(tester, find.text('Saya Pelamar'));

  await tester.tap(find.text('Saya Pelamar'));
  await pumpUntil(tester, find.text('Akses Lowongan Privat'));
}

Future<String> applyForJob(WidgetTester tester, String applyCode) async {
  final pvc = Get.find<PublicVacancyController>();
  pvc.jobCodeController.text = applyCode;
  await pvc.accessPrivateJob();
  await tester.pump(TestConfig.mediumWait);
  await pumpUntil(tester, find.text('Lamar Posisi Ini'));

  // Open apply form
  pvc.nextStep();
  await tester.pump(TestConfig.shortWait);
  await pumpUntil(tester, find.text('Lanjut ke Berkas'));

  // Fill personal info
  await fillPersonalInfo(tester, pvc);

  // Go to document upload
  pvc.nextStep();
  await tester.pump(TestConfig.shortWait);
  await pumpUntil(tester, find.text('Kirim Lamaran'));

  // Inject test documents
  await injectTestDocuments(pvc);
  await tester.pump(TestConfig.shortWait);

  // Submit
  await pvc.submitApplication();
  await tester.pump(TestConfig.longWait);
  await pumpUntil(tester, find.text('Lamaran Berhasil Dikirim!'));

  final ticket = pvc.generatedTicket.value;
  expect(ticket, isNotEmpty, reason: 'Got ticket code');
  return ticket;
}

Future<void> switchToHR(WidgetTester tester) async {
  Get.find<AppService>().logout();
  Get.offAllNamed('/selection');
  await pumpUntil(tester, find.text('Saya Rekruter'));

  await tester.tap(find.text('Saya Rekruter'));
  await pumpUntil(tester, find.text('Sign In'));

  final loginFields = find.byType(TextField);
  await tester.enterText(loginFields.at(0), TestConfig.hrEmail);
  await tester.enterText(loginFields.at(1), TestConfig.hrPassword);
  await tester.tap(find.text('Sign In'));
  await pumpUntil(tester, find.text('Dashboard'));

  expect(Get.find<AppService>().isHR, isTrue, reason: 'HR re-login ok');
}
