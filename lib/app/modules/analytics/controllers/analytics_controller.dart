import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';

class AnalyticsController extends GetxController {
  final _jobService = Get.find<JobService>();
  final _appService = Get.find<ApplicationService>();

  // ── State ──────────────────────────────────────────────────────────
  final selectedJobId = RxnString();
  final selectedTab = 0.obs; // 0: Pelamar, 1: Rank Pelamar
  final isLoadingJobs = false.obs;
  final isLoadingCandidates = false.obs;

  final jobs = <Map<String, dynamic>>[].obs;
  final candidates = <Candidate>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobsAndAnalytics();
  }

  Future<void> fetchJobsAndAnalytics() async {
    if (isLoadingJobs.value) return;
    try {
      isLoadingJobs.value = true;
      final response = await _jobService.listJobs();
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        List<dynamic> items = [];
        if (outer is Map) {
          items = outer['data'] ?? outer['items'] ?? [];
        } else if (outer is List) {
          items = outer;
        }

        final List<Map<String, dynamic>> loadedJobs = [];
        final colors = [
          AppColors.info.toARGB32(),
          AppColors.secondary.toARGB32(),
          AppColors.success.toARGB32(),
          AppColors.warning.toARGB32(),
        ];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          final id = item['id']?.toString() ?? '';
          final title = item['title']?.toString() ?? 'Job Opportunity';
          
          // Ambil langsung applicant_count dari response item (Menghindari N+1 request)
          final applicantCount = item['applicant_count'] as int? ?? 0;

          loadedJobs.add({
            'id': id,
            'title': title,
            'applicants': applicantCount,
            'color': colors[i % colors.length],
          });
        }

        jobs.assignAll(loadedJobs);
      }
    } catch (_) {
      // Handle error gracefully
    } finally {
      isLoadingJobs.value = false;
    }
  }

  Future<void> fetchCandidatesForJob(String jobId) async {
    if (isLoadingCandidates.value) return;
    try {
      isLoadingCandidates.value = true;
      candidates.clear();
      
      final response = await _appService.listApplications(jobId: int.tryParse(jobId));
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        List<dynamic> items = [];
        if (outer is Map) {
          final raw = outer['data'] ?? outer['items'] ?? [];
          items = raw is List ? raw : [];
        }

        candidates.assignAll(
          items.map((c) => Candidate.fromListItem(c as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      // Handle error gracefully
    } finally {
      isLoadingCandidates.value = false;
    }
  }

  List<Candidate> get filteredCandidates {
    return candidates;
  }

  List<Candidate> get rankedCandidates {
    final list = List<Candidate>.from(candidates);
    list.sort((a, b) => b.score.compareTo(a.score));
    return list;
  }

  void selectJob(String? id) {
    if (selectedJobId.value == id) {
      selectedJobId.value = null;
      candidates.clear();
    } else {
      selectedJobId.value = id;
      if (id != null) {
        fetchCandidatesForJob(id);
      }
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  int get totalApplicants => jobs.fold(0, (sum, item) => sum + (item['applicants'] as int));
}
