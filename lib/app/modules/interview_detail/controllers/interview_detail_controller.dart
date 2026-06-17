import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import '../../../data/models/candidate_model.dart';

class InterviewDetailController extends GetxController {
  final _appService = Get.find<ApplicationService>();

  final candidate = Rxn<Candidate>();
  final interviewData = <String, String>{
    'candidateName': 'Sarah Jenkins',
    'role': 'Senior UI Designer',
    'date': 'Friday, 12 May 2026',
    'time': '10:00 AM - 11:00 AM',
    'platform': 'Google Meet',
    'link': 'https://meet.google.com/abc-defg-hij',
    'status': 'Scheduled',
  }.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Candidate) {
      candidate.value = Get.arguments as Candidate;
      _fetchInterviewDetail();
    }
  }

  Future<void> _fetchInterviewDetail() async {
    final c = candidate.value;
    if (c == null) return;

    isLoading.value = true;
    try {
      final response = await _appService.getInterview(int.parse(c.id));
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body!['data'];
        if (data != null) {
          final scheduledAtStr = data['scheduled_at'] as String?;
          String dateStr = '-';
          String timeStr = '-';
          if (scheduledAtStr != null && scheduledAtStr.isNotEmpty) {
            final dt = DateTime.parse(scheduledAtStr).toLocal();
            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
            timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
          }

          interviewData.assignAll({
            'candidateName': c.name,
            'role': c.role,
            'date': dateStr,
            'time': '$timeStr (${data['duration']} mins)',
            'platform': data['location'] != null && data['location'].isNotEmpty ? data['location'] : 'Online (Video)',
            'link': data['meeting_link'] ?? '-',
            'status': data['result'] ?? 'Scheduled',
          });
        }
      }
    } catch (_) {
      // Fallback to initial mock if error
    } finally {
      isLoading.value = false;
    }
  }

  void cancelInterview() {
    Get.defaultDialog(
      title: 'Cancel Interview',
      middleText: 'Are you sure you want to cancel this interview? This will notify the candidate.',
      textConfirm: 'Yes, Cancel',
      textCancel: 'Dismiss',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.back();
        Get.snackbar('Cancelled', 'Interview has been cancelled.');
      },
    );
  }
}

