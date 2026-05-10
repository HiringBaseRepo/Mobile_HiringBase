import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterviewDetailController extends GetxController {
  final interviewData = {
    'candidateName': 'Sarah Jenkins',
    'role': 'Senior UI Designer',
    'date': 'Friday, 12 May 2026',
    'time': '10:00 AM - 11:00 AM',
    'platform': 'Google Meet',
    'link': 'https://meet.google.com/abc-defg-hij',
    'status': 'Scheduled',
  }.obs;

  final isLoading = false.obs;

  void cancelInterview() {
    Get.defaultDialog(
      title: 'Cancel Interview',
      middleText: 'Are you sure you want to cancel this interview? This will notify the candidate.',
      textConfirm: 'Yes, Cancel',
      textCancel: 'Dismiss',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Mock cancel
        Get.back();
        Get.back();
        Get.snackbar('Cancelled', 'Interview has been cancelled.');
      },
    );
  }
}

