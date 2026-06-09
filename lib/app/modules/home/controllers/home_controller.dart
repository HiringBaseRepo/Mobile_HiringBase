import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class HomeController extends GetxController {
  final _navService = Get.find<NavigationService>();
  final _appService = Get.find<ApplicationService>();
  final _jobService = Get.find<JobService>();

  // ── State ──────────────────────────────────────────────────────────
  final stats = <Map<String, dynamic>>[
    {'title': 'Total Applicants', 'value': '0', 'icon': 0xe491, 'color': 0xFF3B82F6},
    {'title': 'Active Listings', 'value': '0', 'icon': 0xe11e, 'color': 0xFF8B5CF6},
    {'title': 'Passed Screen', 'value': '0', 'icon': 0xe156, 'color': 0xFF10B981},
  ].obs;

  final candidates = <Candidate>[].obs;
  final isLoading = false.obs;

  // ── Getters ────────────────────────────────────────────────────────
  int get selectedNavIndex => _navService.selectedIndex.value;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // 1. Fetch recent candidates
      final appResponse = await _appService.listApplications(limit: 5);
      if (appResponse.statusCode == 200 && appResponse.body != null) {
        final outer = appResponse.body!['data'];
        List<dynamic> items = [];
        int totalApps = 0;
        if (outer is Map) {
          totalApps = (outer['total'] as int?) ?? 0;
          final raw = outer['data'] ?? outer['items'] ?? [];
          items = raw is List ? raw : [];
        }

        candidates.assignAll(
          items.map((j) => Candidate.fromListItem(j as Map<String, dynamic>)),
        );

        // Update Total Applicants stat
        stats[0] = {
          ...stats[0],
          'value': totalApps.toString(),
        };
      }

      // 2. Fetch active job listings count
      final jobResponse = await _jobService.listJobs(status: 'published');
      if (jobResponse.statusCode == 200 && jobResponse.body != null) {
        final outer = jobResponse.body!['data'];
        int totalJobs = 0;
        if (outer is Map) {
          totalJobs = (outer['total'] as int?) ?? (outer['data'] as List?)?.length ?? 0;
        }

        stats[1] = {
          ...stats[1],
          'value': totalJobs.toString(),
        };
      }

      // 3. Estimate Passed Screen (doc_check/ai_passed status)
      // Since backend doesn't have an aggregation, we count how many in the loaded candidates are review/interview/hired/ai_passed
      final screenPassedResponse = await _appService.listApplications(statusFilter: 'ai_passed');
      if (screenPassedResponse.statusCode == 200 && screenPassedResponse.body != null) {
        final outer = screenPassedResponse.body!['data'];
        int totalPassed = 0;
        if (outer is Map) {
          totalPassed = (outer['total'] as int?) ?? 0;
        }
        stats[2] = {
          ...stats[2],
          'value': totalPassed.toString(),
        };
      }
    } catch (_) {
      // Keep defaults
    } finally {
      isLoading.value = false;
    }
  }

  void changeNavIndex(int index) {
    _navService.changeTo(index);
  }
}
