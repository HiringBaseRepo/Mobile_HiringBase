class TestConfig {
  TestConfig._();

  // HR Credentials
  static const String hrEmail = 'test.hr@hiringbase.com';
  static const String hrPassword = 'password123';

  // ─── Job Creation: Step 1 — Job Core ────────────────────────────────────
  static const String jobTitle = 'Senior Flutter Developer E2E';
  static const String jobDescription =
      'Senior Flutter Developer role requiring Flutter, Dart, REST API, and Firebase skills. '
      'Must have 3+ years of cross-platform mobile development experience. '
      'Responsible for building and maintaining production mobile applications.';
  static const String jobResponsibilities =
      '• Lead Flutter application architecture and development\n'
      '• Write clean, testable code with proper state management\n'
      '• Integrate REST APIs and Firebase services\n'
      '• Perform code reviews and mentor junior developers\n'
      '• Collaborate with design and product teams';
  static const String jobBenefits =
      '• Competitive salary (Rp 15M - 25M)\n'
      '• Remote work flexibility (hybrid schedule)\n'
      '• Health insurance (BPJS Kesehatan)\n'
      '• Annual training budget\n'
      '• Stock options for senior roles';
  static const String department = 'Engineering';
  static const String employmentType = 'full_time';
  static const String location = 'Remote';
  static const String salaryMin = '15000000';
  static const String salaryMax = '25000000';

  // ─── Job Creation: Step 2 — Requirements ────────────────────────────────
  static const List<String> jobSkills = ['Flutter', 'Dart', 'REST API', 'Firebase'];
  static const List<String> preferredSkills = ['GetX', 'CI/CD', 'Git'];
  static const String minExperience = '3-5 Years';
  static const String educationMin = "Bachelor's";

  // ─── Job Creation: Step 4 — Scoring Template Weights ────────────────────
  static const int skillWeight = 40;
  static const int experienceWeight = 20;
  static const int educationWeight = 10;
  static const int portfolioWeight = 10;
  static const int softSkillWeight = 10;
  static const int adminWeight = 10;
  static const String publishMode = 'public';

  // ─── Applicant: Personal Info ───────────────────────────────────────────
  static const String applicantName = 'AHMAD RIZKY PRATAMA';
  static const String applicantEmail = 'test.applicant@e2e.com';
  static const String applicantPhone = '081234567890';
  static const String applicantLinkedin = 'https://linkedin.com/in/testapplicant';
  static const String applicantEducation = 'S1 Teknik Informatika';
  static const String applicantEducationLevel = 'S1';
  static const String applicantExperienceYears = '5';
  static const String applicantExperienceSummary =
      '5 years building cross-platform mobile apps with Flutter and Dart. '
      'Led development of 3 production applications with 100K+ downloads. '
      'Expertise in REST API integration, Firebase services, state management, and CI/CD pipelines. '
      'Experience with agile methodologies and cross-functional team collaboration.';
  static const String applicantGithub = 'https://github.com/testapplicant';
  static const String applicantPortfolio = 'https://testapplicant.dev';
  static const String applicantProfessionalExperience =
      'Senior Flutter Developer with 5+ years of experience building cross-platform '
      'mobile applications. Led teams of 3-5 developers. Expertise in Flutter, Dart, '
      'REST APIs, Firebase (Auth, Firestore, Cloud Messaging), state management (Riverpod, Bloc, GetX). '
      'Delivered 5+ apps to production on App Store and Google Play with 99.9% crash-free rate. '
      'Strong problem-solving, teamwork, communication, and leadership skills. '
      'Contributed to open-source Flutter packages with 500+ GitHub stars.';

  // ─── Test Documents ─────────────────────────────────────────────────────
  static const String testDocDir = '/data/local/tmp/test_docs';
  static const Map<String, String> testDocuments = {
    'Ijazah': 'ijazah.pdf',
    'KTP': 'ktp.pdf',
    'SKCK': 'skck.pdf',
    'Surat Sehat': 'surat_sehat.pdf',
    'Sertifikat': 'sertifikat.pdf',
  };

  // ─── Test Timeouts ──────────────────────────────────────────────────────
  static const Duration pumpTimeout = Duration(seconds: 45);
  static const Duration shortWait = Duration(seconds: 2);
  static const Duration mediumWait = Duration(seconds: 3);
  static const Duration longWait = Duration(seconds: 5);
  static const Duration aiScreeningWait = Duration(seconds: 120);

  // ─── Score Threshold ────────────────────────────────────────────────────
  static const int passingScore = 60;
}
