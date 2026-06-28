import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';
import 'package:uifrontendmobile/app/services/scoring_service.dart';

/// Controller for the 4-step Create Job wizard.
///
/// Collects form data across 4 steps and submits each step sequentially
/// to the server via [JobService]. The job ID returned by step 1 is
/// used for all subsequent steps.
class JobsController extends GetxController {
  final _jobService = Get.find<JobService>();
  final _scoringService = Get.find<ScoringService>();

  final currentStep = 1.obs;
  final isSubmitting = false.obs;

  /// The job ID returned by step 1, used in steps 2–4.
  int? _createdJobId;

  // ─── Step 1: Job Core ────────────────────────────────────────────────────────
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final benefitsController = TextEditingController();
  final salaryMinController = TextEditingController();
  final salaryMaxController = TextEditingController();

  final department = 'Engineering'.obs;
  final employmentType = 'full_time'.obs;
  final location = 'Remote'.obs;

  // ─── Step 2: Requirements ────────────────────────────────────────────────────
  final requiredSkills = <String>[].obs;
  final preferredSkills = <String>[].obs;
  final minExperience = 'Entry Level'.obs;
  final educationMin = "Bachelor's".obs;

  // Input controllers for step 2 add fields
  final requiredSkillController = TextEditingController();
  final preferredSkillController = TextEditingController();

  // ─── Step 3: Applicant Form fields ───────────────────────────────────────────
  // Custom fields added by HR. Standard fields (Education, Work Experience, etc.)
  // are built into the public form and don't need to be listed here.
  final formFieldsPreview = <Map<String, dynamic>>[].obs;

  static const List<Map<String, String>> documentTypes = [
    {'key': 'ijazah', 'label': 'Ijazah', 'serverType': 'degree'},
    {'key': 'ktp', 'label': 'KTP', 'serverType': 'identity_card'},
    {'key': 'skck', 'label': 'SKCK', 'serverType': 'criminal_record'},
    {'key': 'surat_sehat', 'label': 'Surat Sehat', 'serverType': 'health_certificate'},
    {'key': 'sertifikat', 'label': 'Sertifikat', 'serverType': 'certificate'},
  ];

  /// Keys of currently selected document types (e.g. 'ijazah', 'ktp').
  /// All selected docs are required when publishing the job.
  final selectedDocs = <String>['ijazah', 'ktp', 'skck', 'surat_sehat', 'sertifikat'].obs;

  void toggleDoc(String key) {
    if (selectedDocs.contains(key)) {
      selectedDocs.remove(key);
    } else {
      selectedDocs.add(key);
    }
  }

  // ─── Step 4: Scoring Weights & Publish ──────────────────────────────────────
  final skillMatchWeight = 30.0.obs;
  final experienceWeight = 25.0.obs;
  final educationWeight = 15.0.obs;
  final portfolioWeight = 15.0.obs;
  final softSkillWeight = 10.0.obs;
  final administrativeWeight = 5.0.obs;

  final publishMode = 'public'.obs; // 'public' | 'private'
  final isScheduled = false.obs;
  final scheduledDate = RxnString();
  final publishedApplyCode = RxnString(); // populated after step 4 succeeds

  double get totalWeight =>
      skillMatchWeight.value +
      experienceWeight.value +
      educationWeight.value +
      portfolioWeight.value +
      softSkillWeight.value +
      administrativeWeight.value;

  // ─── Navigation ──────────────────────────────────────────────────────────────

  /// Validates the current step and advances if valid, calling the server API.
  Future<void> nextStep() async {
    switch (currentStep.value) {
      case 1:
        await _submitStep1();
        break;
      case 2:
        await _submitStep2();
        break;
      case 3:
        await _submitStep3();
        break;
      case 4:
        await _submitStep4();
        break;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) currentStep.value--;
  }

  // ─── Step Submissions ────────────────────────────────────────────────────────

  Future<void> _submitStep1() async {
    if (titleController.text.trim().isEmpty) {
      _showError('Job title is required.');
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await _jobService.createJobStep1(
        title: titleController.text.trim(),
        department: department.value,
        employmentType: employmentType.value,
        location: location.value,
        salaryMin: int.tryParse(salaryMinController.text.trim()),
        salaryMax: int.tryParse(salaryMaxController.text.trim()),
        description: descriptionController.text.trim(),
        responsibilities: responsibilitiesController.text.trim(),
        benefits: benefitsController.text.trim(),
      );

      if (response.status.hasError || response.body?['success'] != true) {
        _showError(response.body?['message']?.toString() ?? 'Failed to save job. Try again.');
        return;
      }

      _createdJobId = response.body!['data']['job_id'] as int?;
      currentStep.value = 2;
    } catch (_) {
      _showError('Connection error. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitStep2() async {
    if (_createdJobId == null) { _showError('Job ID missing. Restart the form.'); return; }

    isSubmitting.value = true;
    try {
      // Build requirements list from current skill selections
      final reqs = <Map<String, dynamic>>[];
      for (final skill in requiredSkills) {
        reqs.add({'category': 'skill', 'name': skill, 'value': skill, 'is_required': true, 'priority': 1});
      }
      for (final skill in preferredSkills) {
        reqs.add({'category': 'skill', 'name': skill, 'value': skill, 'is_required': false, 'priority': 2});
      }
      reqs.add({'category': 'experience', 'name': 'Minimum Experience', 'value': minExperience.value, 'is_required': true, 'priority': 1});
      reqs.add({'category': 'education', 'name': 'Minimum Education', 'value': educationMin.value, 'is_required': true, 'priority': 1});

      final response = await _jobService.addJobRequirements(
        jobId: _createdJobId!,
        requirements: reqs,
      );

      if (response.status.hasError || response.body?['success'] != true) {
        _showError(response.body?['message']?.toString() ?? 'Failed to save requirements.');
        return;
      }

      currentStep.value = 3;
    } catch (_) {
      _showError('Connection error. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitStep3() async {
    if (_createdJobId == null) { _showError('Job ID missing. Restart the form.'); return; }

    isSubmitting.value = true;
    try {
      // Build custom text fields
      final fields = formFieldsPreview.asMap().entries.map((e) => {
        'field_key': e.value['label'].toString().toLowerCase().replaceAll(' ', '_'),
        'field_type': 'text',
        'label': e.value['label'],
        'is_required': e.value['is_required'],
        'order_index': e.key,
      }).toList();

      // Add document fields for selected docs
      int docOrder = fields.length;
      for (final docType in documentTypes) {
        if (selectedDocs.contains(docType['key'])) {
          fields.add({
            'field_key': docType['key'],
            'field_type': 'file',
            'label': docType['label'],
            'is_required': true,
            'order_index': docOrder++,
          });
        }
      }

      // Step 3a: Submit form fields (text + document)
      final response = await _jobService.setupJobForm(
        jobId: _createdJobId!,
        fields: fields,
      );

      if (response.status.hasError || response.body?['success'] != true) {
        _showError(response.body?['message']?.toString() ?? 'Failed to save form fields.');
        return;
      }

      // Step 3b: Submit knockout rules for required documents
      final knockoutRules = <Map<String, dynamic>>[];
      for (final docType in documentTypes) {
        if (selectedDocs.contains(docType['key'])) {
          knockoutRules.add({
            'rule_name': 'Require ${docType['label']}',
            'rule_type': 'document',
            'target_value': docType['serverType'],
            'is_active': true,
          });
        }
      }

      if (knockoutRules.isNotEmpty) {
        final krResponse = await _jobService.addJobKnockoutRules(
          jobId: _createdJobId!,
          knockoutRules: knockoutRules,
        );
        if (krResponse.status.hasError || krResponse.body?['success'] != true) {
          _showError(krResponse.body?['message']?.toString() ?? 'Failed to save document rules.');
          return;
        }
      }

      currentStep.value = 4;
    } catch (_) {
      _showError('Connection error. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitStep4() async {
    if (_createdJobId == null) { _showError('Job ID missing. Restart the form.'); return; }

    if (totalWeight != 100.0) {
      _showError('Total weight must be exactly 100% to publish. Current: ${totalWeight.toInt()}%');
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await _jobService.publishJob(
        jobId: _createdJobId!,
        mode: publishMode.value,
        scheduledAt: isScheduled.value ? scheduledDate.value : null,
      );

      if (response.status.hasError || response.body?['success'] != true) {
        _showError(response.body?['message']?.toString() ?? 'Failed to publish job.');
        return;
      }

      // Capture apply_code from server response
      publishedApplyCode.value =
          response.body!['data']?['apply_code']?.toString();

      // Save scoring template (non-blocking — job already published)
      _scoringService.saveTemplate(
        jobId: _createdJobId!.toString(),
        skillMatch: skillMatchWeight.value,
        experience: experienceWeight.value,
        education: educationWeight.value,
        portfolio: portfolioWeight.value,
        softSkill: softSkillWeight.value,
        administrative: administrativeWeight.value,
      );

      // Success — go to success screen (step 5 is the success view)
      currentStep.value = 5;
    } catch (_) {
      _showError('Connection error. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  // ─── Helper actions ──────────────────────────────────────────────────────────

  void updateWeight(RxDouble weight, double value) => weight.value = value;

  void addSkill(String skill, bool isRequired) {
    if (skill.isEmpty) return;
    if (isRequired && !requiredSkills.contains(skill)) requiredSkills.add(skill);
    if (!isRequired && !preferredSkills.contains(skill)) preferredSkills.add(skill);
  }

  void removeSkill(String skill, bool isRequired) {
    if (isRequired) {
      requiredSkills.remove(skill);
    } else {
      preferredSkills.remove(skill);
    }
  }

  void toggleFieldRequired(int index) {
    if (formFieldsPreview[index]['is_required'] is bool) {
      final current = formFieldsPreview[index]['is_required'] as bool;
      formFieldsPreview[index] = {...formFieldsPreview[index], 'is_required': !current};
      formFieldsPreview.refresh();
    }
  }

  /// Navigates back to the jobs list after a successful creation.
  void goToJobsList() {
    Get.find<NavigationService>().changeTo(1);
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
      colorText: AppColors.error,
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    responsibilitiesController.dispose();
    benefitsController.dispose();
    salaryMinController.dispose();
    salaryMaxController.dispose();
    requiredSkillController.dispose();
    preferredSkillController.dispose();
    super.onClose();
  }
}
