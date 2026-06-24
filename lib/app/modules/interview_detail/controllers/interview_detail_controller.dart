import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/data/models/interview_model.dart';
import '../../../data/models/candidate_model.dart';

class InterviewDetailController extends GetxController {
  final _appService = Get.find<ApplicationService>();

  final candidate = Rxn<Candidate>();
  final interviewData = Rx<Interview>(Interview.empty());
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Candidate) {
      candidate.value = Get.arguments as Candidate;
      interviewData.value = Interview.fromCandidate(candidate.value);
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

          interviewData.value = interviewData.value.copyWith(
            candidateName: c.name,
            role: c.role,
            date: dateStr,
            time: '$timeStr (${data['duration']} mins)',
            platform: data['location'] != null && data['location'].isNotEmpty ? data['location'] : 'Online (Video)',
            link: data['meeting_link'] ?? '-',
            status: data['result'] ?? 'Scheduled',
          );
        }
      }
    } catch (_) {
      // Keep name/role if fetch fails
    } finally {
      isLoading.value = false;
    }
  }
}
