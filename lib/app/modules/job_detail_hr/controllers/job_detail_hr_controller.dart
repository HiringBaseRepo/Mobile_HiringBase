import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/core/utils/simple_cache.dart';
import 'package:uifrontendmobile/app/data/models/vacancy_model.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';

/// Controller for the HR Job Detail screen.
///
/// Receives a [Vacancy] object from the list view arguments and fetches
/// full job details from the server. Also provides the closeJob action.
class JobDetailHrController extends GetxController {
  final _jobService = Get.find<JobService>();
  final _appService = Get.find<ApplicationService>();

  final job = Rxn<Vacancy>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  // Dynamic applicant statistics state
  final totalApplicants = 0.obs;
  final newApplicants = 0.obs;
  final inInterview = 0.obs;
  final aiScreeningProgress = 0.0.obs;
  final technicalTestProgress = 0.0.obs;

  static final _detailsCache = <int, SimpleCache<Map<String, dynamic>>>{};

  SimpleCache<Map<String, dynamic>> _getCacheForJob(int jobId) {
    return _detailsCache.putIfAbsent(
      jobId,
      () => SimpleCache<Map<String, dynamic>>(ttl: const Duration(minutes: 5)),
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Accept either a full Vacancy object or just the job ID (int/String)
    if (Get.arguments is Vacancy) {
      job.value = Get.arguments as Vacancy;
      _fetchDetails(int.parse(job.value!.id));
    } else if (Get.arguments is int) {
      _fetchDetails(Get.arguments as int);
    } else if (Get.arguments is String) {
      final id = int.tryParse(Get.arguments as String);
      if (id != null) _fetchDetails(id);
    }
  }

  /// Fetches full job detail from `GET /jobs/{id}` and updates statistics.
  Future<void> _fetchDetails(int jobId, {bool forceRefresh = false}) async {
    final cache = _getCacheForJob(jobId);

    if (forceRefresh) {
      cache.invalidate();
    }

    if (!forceRefresh && cache.isValid) {
      final cached = cache.data!;
      job.value = cached['job'] as Vacancy;
      totalApplicants.value = cached['totalApplicants'] as int;
      newApplicants.value = cached['newApplicants'] as int;
      inInterview.value = cached['inInterview'] as int;
      aiScreeningProgress.value = cached['aiScreeningProgress'] as double;
      technicalTestProgress.value = cached['technicalTestProgress'] as double;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _jobService.getJobDetail(jobId);

      if (response.status.hasError || response.body == null) {
        errorMessage.value = 'Failed to load job details.';
        return;
      }

      final body = response.body!;
      if (body['success'] != true) {
        errorMessage.value = body['message']?.toString() ?? 'Failed to load job details.';
        return;
      }

      final data = body['data'] as Map<String, dynamic>;
      
      // Update statistics by fetching applications for this job
      await _fetchApplicantStats(jobId);

      // Merge detail data with the existing list-level vacancy if available
      Vacancy updatedJob;
      if (job.value != null) {
        updatedJob = job.value!.copyWith(
          description: data['description'] as String? ?? job.value!.description,
          applyCode: data['apply_code'] as String? ?? job.value!.applyCode,
          applicantCount: totalApplicants.value,
        );
      } else {
        updatedJob = Vacancy.fromJson(data).copyWith(
          applicantCount: totalApplicants.value,
        );
      }
      job.value = updatedJob;

      cache.set({
        'job': updatedJob,
        'totalApplicants': totalApplicants.value,
        'newApplicants': newApplicants.value,
        'inInterview': inInterview.value,
        'aiScreeningProgress': aiScreeningProgress.value,
        'technicalTestProgress': technicalTestProgress.value,
      });
    } catch (_) {
      errorMessage.value = 'Connection error. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculates dynamic recruitment metrics based on actual server applicants
  Future<void> _fetchApplicantStats(int jobId) async {
    try {
      final response = await _appService.listApplications(jobId: jobId);
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        List<dynamic> items = [];
        int total = 0;
        if (outer is Map) {
          final raw = outer['data'] ?? outer['items'] ?? [];
          items = raw is List ? raw : [];
          total = (outer['total'] as int?) ?? items.length;
        }

        totalApplicants.value = total;

        int countNew = 0;
        int countInterview = 0;
        int countScreened = 0;
        int countTechTest = 0;

        for (var c in items) {
          final status = (c['status'] as String? ?? '').toLowerCase();
          
          if (status == 'applied') {
            countNew++;
          }
          if (status == 'interview' || status == 'technical_test' || status == 'offered') {
            countInterview++;
          }
          if (status != 'applied' && status != 'screening') {
            countScreened++;
          }
          if (status == 'technical_test' || status == 'interview') {
            countTechTest++;
          }
        }

        newApplicants.value = countNew;
        inInterview.value = countInterview;

        if (total > 0) {
          aiScreeningProgress.value = countScreened / total;
          technicalTestProgress.value = countTechTest / total;
        } else {
          aiScreeningProgress.value = 0.0;
          technicalTestProgress.value = 0.0;
        }
      }
    } catch (_) {
      // Fallback to zeros on error
      totalApplicants.value = 0;
      newApplicants.value = 0;
      inInterview.value = 0;
      aiScreeningProgress.value = 0.0;
      technicalTestProgress.value = 0.0;
    }
  }

  /// Closes the current job and navigates back on success.
  Future<void> closeJob() async {
    if (job.value == null) return;
    isLoading.value = true;

    try {
      final response = await _jobService.closeJob(int.parse(job.value!.id));

      if (response.status.hasError || response.body?['success'] != true) {
        Get.snackbar(
          'Error',
          response.body?['message']?.toString() ?? 'Failed to close job.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
          colorText: AppColors.error,
        );
        return;
      }

      job.value = job.value!.copyWith(status: 'closed', statusLabel: 'Closed');
      Get.snackbar(
        'Job Closed',
        'Vacancy has been closed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
      );
    } catch (_) {
      Get.snackbar('Error', 'Connection error.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes job details.
  Future<void> refresh() async {
    if (job.value != null) {
      await _fetchDetails(int.parse(job.value!.id), forceRefresh: true);
    }
  }
}
