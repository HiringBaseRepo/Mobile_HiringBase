import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import '../../../data/models/candidate_model.dart';

class RankingController extends GetxController {
  final _jobService = Get.find<JobService>();

  final candidates = <Candidate>[].obs;
  final isLoading = false.obs;
  final jobId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is String) {
        jobId.value = Get.arguments as String;
      } else {
        jobId.value = Get.arguments.toString();
      }
    }
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    final parsedJobId = int.tryParse(jobId.value);
    if (parsedJobId == null) return;

    isLoading.value = true;
    try {
      final response = await _jobService.getJobRanking(parsedJobId);
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        if (outer is Map) {
          final listRaw = outer['data'] as List?;
          if (listRaw != null) {
            final mapped = listRaw.map((item) {
              final status = (item['status'] as String? ?? 'applied').toLowerCase();
              final finalScore = ((item['final_score'] as num?) ?? 0).round();
              
              String matchText = 'Pending Screening';
              if (finalScore >= 90) {
                matchText = 'Top 5% Match';
              } else if (finalScore >= 80) {
                matchText = 'Strong Match';
              } else if (finalScore >= 70) {
                matchText = 'Good Fit';
              } else if (finalScore >= 60) {
                matchText = 'Possible Fit';
              } else if (finalScore > 0) {
                matchText = 'Low Match';
              }

              String createdStr = item['created_at'] as String? ?? '';
              String timeStr = 'Recent';
              if (createdStr.isNotEmpty) {
                try {
                  final dt = DateTime.parse(createdStr).toLocal();
                  final diff = DateTime.now().difference(dt);
                  if (diff.inMinutes < 60) {
                    timeStr = '${diff.inMinutes}m ago';
                  } else if (diff.inHours < 24) {
                    timeStr = '${diff.inHours}h ago';
                  } else if (diff.inDays < 7) {
                    timeStr = '${diff.inDays}d ago';
                  } else {
                    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                    timeStr = '${dt.day} ${months[dt.month - 1]}';
                  }
                } catch (_) {}
              }

              int statusColor = 0xFF64748B; // fallback slate
              switch (status) {
                case 'hired':
                case 'ai_passed':
                case 'offered':
                  statusColor = 0xFF10B981; // green
                  break;
                case 'interview':
                case 'under_review':
                  statusColor = 0xFF3B82F6; // blue
                  break;
                case 'applied':
                case 'doc_check':
                case 'ai_processing':
                  statusColor = 0xFFF59E0B; // orange/warning
                  break;
                case 'rejected':
                case 'doc_failed':
                case 'knockout':
                  statusColor = 0xFFEF4444; // red
                  break;
              }

              return Candidate(
                id: (item['application_id'] ?? 0).toString(),
                name: item['applicant_name'] as String? ?? 'Candidate #${item['application_id']}',
                role: 'Applicant #${item['application_id']}',
                status: status.toUpperCase(),
                score: finalScore,
                matchText: matchText,
                appliedAt: timeStr,
                imageUrl: 'https://i.pravatar.cc/150?u=${item['application_id']}',
                statusColor: statusColor,
                email: item['applicant_email'] as String?,
                jobId: parsedJobId,
                scoreBreakdown: {
                  'final_score': finalScore,
                  'breakdown': {
                    'skills': item['skill_match'] ?? 0.0,
                    'experience': item['experience'] ?? 0.0,
                    'education': item['education'] ?? 0.0,
                    'portfolio': item['portfolio'] ?? 0.0,
                  },
                  'risk_level': item['risk_level'],
                },
              );
            }).toList();

            candidates.assignAll(mapped);
            return;
          }
        }
      }
    } catch (_) {
      // Keep static or fallback if error
    } finally {
      isLoading.value = false;
    }
  }
}
