import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/utils/simple_cache.dart';
import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';

/// Controller for the Jobs List screen.
///
/// Fetches job vacancies from the server via [JobService] and exposes
/// filtered/sorted lists to the view. Supports status filtering and
/// pull-to-refresh.
class JobsListController extends GetxController {
  final _jobService = Get.find<JobService>();

  final jobs = <Vacancy>[].obs;
  final selectedFilter = 'All'.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final int limit = 10;

  final _cache = SimpleCache<Map<String, dynamic>>(ttl: const Duration(minutes: 3));

  // ─── Filter options (maps display label → server enum value) ────────────────
  static const Map<String, String?> _filterMap = {
    'All':       null,
    'Published': 'published',
    'Draft':     'draft',
    'Closed':    'closed',
    'Scheduled': 'scheduled',
  };

  List<String> get filterOptions => _filterMap.keys.toList();

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  /// Fetches the job list from the server.
  /// Called on init and on pull-to-refresh.
  Future<void> fetchJobs({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
      _cache.invalidate();
    }

    if (!hasMore.value) return;

    final isDefaultState = selectedFilter.value == 'All';
    if (!refresh && currentPage.value == 1 && isDefaultState && _cache.isValid) {
      final cached = _cache.data!;
      jobs.assignAll(cached['items'] as List<Vacancy>);
      hasMore.value = cached['hasMore'] as bool;
      currentPage.value = 2;
      return;
    }

    try {
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = null;

      final statusFilter = _filterMap[selectedFilter.value];
      final response = await _jobService.listJobs(
        status: statusFilter,
        page: currentPage.value,
        limit: limit,
      );

      if (response.status.hasError || response.body == null) {
        _handleError(response.statusCode ?? 0, response.body);
        return;
      }

      final body = response.body!;
      if (body['success'] != true) {
        errorMessage.value = body['message']?.toString() ?? 'Failed to load jobs.';
        return;
      }

      // Server PaginatedResponse structure:
      // { success, data: { data: [...], total, page, per_page, ... } }
      final outer = body['data'];
      List<dynamic> items = [];
      int total = 0;
      if (outer is Map) {
        // Try 'data' key first (PaginatedResponse), then 'items' as fallback
        final raw = outer['data'] ?? outer['items'] ?? [];
        items = raw is List ? raw : [];
        total = (outer['total'] as int?) ?? 0;
      }

      final newJobs = items.map((j) => Vacancy.fromJson(j as Map<String, dynamic>)).toList();

      if (currentPage.value == 1) {
        jobs.assignAll(newJobs);
        if (isDefaultState) {
          _cache.set({
            'items': List<Vacancy>.from(newJobs),
            'hasMore': hasMore.value,
          });
        }
      } else {
        jobs.addAll(newJobs);
      }

      hasMore.value = jobs.length < total;
      if (newJobs.isNotEmpty) {
        currentPage.value++;
      }
    } catch (e) {
      errorMessage.value = 'Connection error. Please check your internet.';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Triggers loading more jobs when scroll reaches bottom.
  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;
    await fetchJobs();
  }

  /// Returns jobs filtered by current [selectedFilter].
  /// When filter is 'All', the server already handles filtering via query param,
  /// so we just return all fetched jobs.
  List<Vacancy> get filteredJobs => jobs;

  /// Changes the active filter and re-fetches from server.
  void setFilter(String filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    fetchJobs(refresh: true);
  }

  /// Closes a job and refreshes the list.
  Future<void> closeJob(String jobId) async {
    try {
      final response = await _jobService.closeJob(int.parse(jobId));
      if (response.status.hasError) {
        Get.snackbar(
          'Error',
          'Failed to close job. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          colorText: AppColors.error,
        );
        return;
      }
      Get.snackbar(
        'Job Closed',
        'The vacancy has been closed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
      );
      await fetchJobs();
    } catch (_) {
      Get.snackbar('Error', 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _handleError(int statusCode, Map<String, dynamic>? body) {
    final serverMsg = body?['message']?.toString();
    switch (statusCode) {
      case 401:
        errorMessage.value = 'Session expired. Please login again.';
        break;
      case 403:
        errorMessage.value = 'Access denied.';
        break;
      default:
        errorMessage.value = serverMsg?.isNotEmpty == true
            ? serverMsg!
            : 'Failed to load jobs. Please try again.';
    }
  }
}
