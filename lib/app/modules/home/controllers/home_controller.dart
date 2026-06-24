import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/data/models/dashboard_stat.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/services/navigation_service.dart';

class HomeController extends GetxController {
  final _navService = Get.find<NavigationService>();
  final _appService = Get.find<ApplicationService>();
  final _jobService = Get.find<JobService>();

  // ── State ──────────────────────────────────────────────────────────
  final stats = <DashboardStat>[
    const DashboardStat(title: 'Total Applicants', value: '0', icon: Icons.people_outline_rounded, color: AppColors.info),
    const DashboardStat(title: 'Active Listings', value: '0', icon: Icons.work_outline_rounded, color: AppColors.secondary),
    const DashboardStat(title: 'Passed Screen', value: '0', icon: Icons.fact_check_outlined, color: AppColors.success),
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
    if (isLoading.value) return;
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
        stats[0] = stats[0].copyWith(value: totalApps.toString());
      }

      // 2. Fetch active job listings count
      final jobResponse = await _jobService.listJobs(status: 'published');
      if (jobResponse.statusCode == 200 && jobResponse.body != null) {
        final outer = jobResponse.body!['data'];
        int totalJobs = 0;
        if (outer is Map) {
          totalJobs = (outer['total'] as int?) ?? (outer['data'] as List?)?.length ?? 0;
        }

        stats[1] = stats[1].copyWith(value: totalJobs.toString());
      }

      // 3. Estimate Passed Screen (doc_check/ai_passed status)
      final screenPassedResponse = await _appService.listApplications(statusFilter: 'ai_passed');
      if (screenPassedResponse.statusCode == 200 && screenPassedResponse.body != null) {
        final outer = screenPassedResponse.body!['data'];
        int totalPassed = 0;
        if (outer is Map) {
          totalPassed = (outer['total'] as int?) ?? 0;
        }
        stats[2] = stats[2].copyWith(value: totalPassed.toString());
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
