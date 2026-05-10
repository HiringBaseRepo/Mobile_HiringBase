import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/candidate_model.dart';

class ScheduleInterviewController extends GetxController {
  final candidate = Rxn<Candidate>();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final selectedPlatform = 'Google Meet'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Candidate) {
      candidate.value = Get.arguments as Candidate;
    }
  }

  Future<void> submitSchedule() async {
    if (dateController.text.isEmpty || timeController.text.isEmpty) {
      Get.snackbar('Error', 'Please select date and time');
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    
    Get.back();
    Get.snackbar('Success', 'Interview scheduled and invitation sent');
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }
}
