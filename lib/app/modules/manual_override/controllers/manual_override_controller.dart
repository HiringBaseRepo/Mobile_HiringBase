import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/candidate_model.dart';

class ManualOverrideController extends GetxController {
  final candidate = Rxn<Candidate>();
  final reasonController = TextEditingController();
  final isLoading = false.obs;

  // Adjustments (Delta)
  final skillAdj = 0.0.obs;
  final expAdj = 0.0.obs;
  final eduAdj = 0.0.obs;
  final portAdj = 0.0.obs;
  final softAdj = 0.0.obs;
  final adminAdj = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Candidate) {
      candidate.value = Get.arguments as Candidate;
    }
  }

  double get previewScore {
    double base = candidate.value?.score.toDouble() ?? 0.0;
    return (base + skillAdj.value + expAdj.value + eduAdj.value + portAdj.value + softAdj.value + adminAdj.value).clamp(0.0, 100.0);
  }

  Future<void> submitOverride() async {
    if (reasonController.text.isEmpty) {
      Get.snackbar('Error', 'Reason for override is mandatory');
      return;
    }

    isLoading.value = true;
    
    // API logic: POST /api/v1/manual-override/{id}
    // Content-Type: application/x-www-form-urlencoded (Query Params)
    // Params: skill_adjustment, experience_adjustment, etc.
    
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    // Update local state for immediate feedback
    if (candidate.value != null) {
      candidate.value = candidate.value!.copyWith(
        score: previewScore.toInt(),
        isManualOverride: true,
      );
    }
    
    Get.back(result: true);
    Get.snackbar('Success', '⚡ Manual Override applied successfully');
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
