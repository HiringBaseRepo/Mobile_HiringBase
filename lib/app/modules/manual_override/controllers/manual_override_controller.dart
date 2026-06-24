import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/scoring_service.dart';
import '../../../data/models/candidate_model.dart';
import '../../candidate_detail/controllers/candidate_detail_controller.dart';

class ManualOverrideController extends GetxController {
  final candidate = Rxn<Candidate>();
  final reasonController = TextEditingController();
  final isLoading = false.obs;

  /// Default weights — used as fallback if no scoring template exists for the job.
  static const _defaultWeights = {
    'skill': 40.0,
    'experience': 20.0,
    'education': 10.0,
    'portfolio': 10.0,
    'soft_skill': 10.0,
    'administrative': 10.0,
  };

  /// Live weights fetched from the job's scoring template.
  final _weights = Map<String, double>.from(_defaultWeights).obs;

  // Target sub-scores (replacement mode)
  final skillVal = 0.0.obs;
  final expVal = 0.0.obs;
  final eduVal = 0.0.obs;
  final portVal = 0.0.obs;
  final softVal = 0.0.obs;
  final adminVal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Candidate) {
      candidate.value = Get.arguments as Candidate;
      _initScoresFromBreakdown();
      _fetchTemplateWeights();
    }
  }

  Future<void> _fetchTemplateWeights() async {
    final jobId = candidate.value?.jobId;
    if (jobId == null) return;

    try {
      final response = await Get.find<ScoringService>().getTemplate(jobId.toString());
      if (response.statusCode == 200 && response.body?['success'] == true) {
        final data = response.body!['data'];
        if (data is Map && data['weights'] is Map) {
          final w = data['weights'] as Map;
          _weights['skill'] = (w['skill_match'] as num?)?.toDouble() ?? _defaultWeights['skill']!;
          _weights['experience'] = (w['experience'] as num?)?.toDouble() ?? _defaultWeights['experience']!;
          _weights['education'] = (w['education'] as num?)?.toDouble() ?? _defaultWeights['education']!;
          _weights['portfolio'] = (w['portfolio'] as num?)?.toDouble() ?? _defaultWeights['portfolio']!;
          _weights['soft_skill'] = (w['soft_skill'] as num?)?.toDouble() ?? _defaultWeights['soft_skill']!;
          _weights['administrative'] = (w['administrative'] as num?)?.toDouble() ?? _defaultWeights['administrative']!;
        }
      }
    } catch (_) {
      // Silently fall back to default weights
    }
  }

  void _initScoresFromBreakdown() {
    final sd = candidate.value?.scoreData;
    if (sd == null) return;
    skillVal.value = sd.skillMatchScore;
    expVal.value = sd.experienceScore;
    eduVal.value = sd.educationScore;
    portVal.value = sd.portfolioScore;
    softVal.value = sd.softSkillScore;
    adminVal.value = sd.administrativeScore;
  }

  double get previewScore {
    final w = _weights;
    final raw = (
      skillVal.value * w['skill']! +
      expVal.value * w['experience']! +
      eduVal.value * w['education']! +
      portVal.value * w['portfolio']! +
      softVal.value * w['soft_skill']! +
      adminVal.value * w['administrative']!
    ) / 100.0;
    return raw.clamp(0.0, 100.0);
  }

  Future<void> submitOverride() async {
    if (reasonController.text.isEmpty) {
      Get.snackbar('Error', 'Reason for override is mandatory');
      return;
    }

    if (candidate.value == null) {
      Get.snackbar('Error', 'Candidate data is missing');
      return;
    }

    final appId = int.tryParse(candidate.value!.id);
    if (appId == null) {
      Get.snackbar('Error', 'Invalid application ID');
      return;
    }

    isLoading.value = true;

    try {
      final response = await Get.find<ScoringService>().manualOverride(
        applicationId: appId,
        skillMatchScore: skillVal.value.clamp(0.0, 100.0),
        experienceScore: expVal.value.clamp(0.0, 100.0),
        educationScore: eduVal.value.clamp(0.0, 100.0),
        portfolioScore: portVal.value.clamp(0.0, 100.0),
        softSkillScore: softVal.value.clamp(0.0, 100.0),
        administrativeScore: adminVal.value.clamp(0.0, 100.0),
        reason: reasonController.text,
      );

      isLoading.value = false;

      if (response.statusCode == 200 && response.body != null && response.body['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Manual Override applied successfully');
        try {
          Get.find<CandidateDetailController>().refreshData();
        } catch (_) {}
      } else {
        final errorMsg = response.body?['message'] ?? 'Failed to apply manual override';
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
