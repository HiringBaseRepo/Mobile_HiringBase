import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/modules/candidate_detail/controllers/candidate_detail_controller.dart';
import '../../../data/models/candidate_model.dart';

class ScheduleInterviewController extends GetxController {
  final _appService = Get.find<ApplicationService>();

  final candidate = Rxn<Candidate>();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final linkController = TextEditingController();
  final locationController = TextEditingController();
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
      Get.snackbar(
        'Validation Error',
        'Please select date and time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        colorText: AppColors.error,
      );
      return;
    }

    final c = candidate.value;
    if (c == null) return;

    isLoading.value = true;
    try {
      // 1. Parse date and time
      final dateParts = dateController.text.split('-');
      final yr = int.parse(dateParts[0]);
      final mn = int.parse(dateParts[1]);
      final dy = int.parse(dateParts[2]);

      final timeStr = timeController.text;
      int hr = 9;
      int min = 0;
      
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        final isPM = timeStr.contains('PM');
        final cleanTime = timeStr.replaceAll(RegExp(r'[AP]M'), '').trim();
        final parts = cleanTime.split(':');
        hr = int.parse(parts[0]);
        min = int.parse(parts[1]);
        if (isPM && hr < 12) hr += 12;
        if (!isPM && hr == 12) hr = 0;
      } else {
        final parts = timeStr.split(':');
        hr = int.parse(parts[0]);
        min = int.parse(parts[1]);
      }

      final scheduledDateTime = DateTime(yr, mn, dy, hr, min);
      final scheduledAtIso = scheduledDateTime.toUtc().toIso8601String();

      // 2. Map platform to enum & meeting details
      String interviewType = 'video';
      String? meetingLink;
      String? location;

      switch (selectedPlatform.value) {
        case 'Google Meet':
        case 'Zoom':
          interviewType = 'video';
          final link = linkController.text.trim();
          if (link.isEmpty) {
            Get.snackbar(
              'Validation Error',
              'Please enter the meeting link',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              colorText: AppColors.error,
            );
            isLoading.value = false;
            return;
          }
          meetingLink = link;
          break;
        case 'WhatsApp':
          interviewType = 'phone';
          meetingLink = linkController.text.trim();
          break;
        case 'In-Person':
          interviewType = 'in_person';
          final loc = locationController.text.trim();
          if (loc.isEmpty) {
            Get.snackbar(
              'Validation Error',
              'Please enter the interview location',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.error.withValues(alpha: 0.1),
              colorText: AppColors.error,
            );
            isLoading.value = false;
            return;
          }
          location = loc;
          break;
      }

      // 3. Post to /interviews
      final response = await _appService.scheduleInterview(
        applicationId: int.parse(c.id),
        scheduledAt: scheduledAtIso,
        durationMinutes: 60,
        interviewType: interviewType,
        meetingLink: meetingLink,
        location: location,
      );

      if (response.status.hasError || response.body?['success'] != true) {
        final msg = response.body?['message']?.toString() ?? 'Failed to schedule interview.';
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          colorText: AppColors.error,
        );
        return;
      }

      // 4. Update application status to interview
      await _appService.updateApplicationStatus(c.id, 'interview');

      // 5. Success
      Get.back();
      // Try to reload candidate detail
      try {
        if (Get.isRegistered<CandidateDetailController>()) {
          final detailCtrl = Get.find<CandidateDetailController>();
          detailCtrl.refreshData();
        }
      } catch (_) {}

      Get.snackbar(
        'Success',
        'Interview scheduled and invitation sent',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        colorText: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    linkController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
