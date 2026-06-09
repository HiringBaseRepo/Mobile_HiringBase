import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';

/// HTTP client for all Job/Vacancy-related API endpoints.
///
/// Endpoints covered:
/// - `GET    /jobs`               — list jobs (paginated, filterable)
/// - `GET    /jobs/{id}`          — job detail
/// - `POST   /jobs/create-step1`  — create job step 1
/// - `POST   /jobs/{id}/step2-requirements` — add requirements
/// - `POST   /jobs/{id}/step3-form`         — setup applicant form
/// - `POST   /jobs/{id}/step4-publish`      — publish job
/// - `PATCH  /jobs/{id}/close`              — close job
class JobService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Map<String, String> get _authHeaders {
    final token = Get.find<AppService>().accessToken.value;
    return {'Authorization': 'Bearer $token'};
  }

  // ─── List & Detail ───────────────────────────────────────────────────────────

  /// Fetches a paginated list of jobs for the current HR's company.
  ///
  /// [status] — optional filter: 'draft' | 'published' | 'closed' | 'scheduled' | 'private'
  /// [q]      — optional search keyword
  /// [page]   — 1-indexed page number
  /// [limit]  — items per page
  Future<Response<Map<String, dynamic>>> listJobs({
    String? status,
    String? q,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (q != null && q.isNotEmpty) 'q': q,
    };
    return get<Map<String, dynamic>>(
      '/jobs',
      query: queryParams.map((k, v) => MapEntry(k, v.toString())),
      headers: _authHeaders,
    );
  }

  /// Fetches detailed info for a single job by its [jobId].
  Future<Response<Map<String, dynamic>>> getJobDetail(int jobId) {
    return get<Map<String, dynamic>>(
      '/jobs/$jobId',
      headers: _authHeaders,
    );
  }

  // ─── Create Job (4-step wizard) ──────────────────────────────────────────────

  /// Step 1 — Creates a new job with core information.
  Future<Response<Map<String, dynamic>>> createJobStep1({
    required String title,
    String? department,
    String employmentType = 'full_time',
    String? location,
    int? salaryMin,
    int? salaryMax,
    String description = '',
    String? responsibilities,
    String? benefits,
  }) {
    return post<Map<String, dynamic>>(
      '/jobs/create-step1',
      {
        'title': title,
        if (department != null && department.isNotEmpty) 'department': department,
        'employment_type': employmentType,
        if (location != null && location.isNotEmpty) 'location': location,
        if (salaryMin != null) 'salary_min': salaryMin,
        if (salaryMax != null) 'salary_max': salaryMax,
        'description': description,
        if (responsibilities != null && responsibilities.isNotEmpty)
          'responsibilities': responsibilities,
        if (benefits != null && benefits.isNotEmpty) 'benefits': benefits,
      },
      headers: _authHeaders,
    );
  }

  /// Step 2 — Adds requirements to an existing job draft.
  Future<Response<Map<String, dynamic>>> addJobRequirements({
    required int jobId,
    required List<Map<String, dynamic>> requirements,
  }) {
    return post<Map<String, dynamic>>(
      '/jobs/$jobId/step2-requirements',
      {'requirements': requirements},
      headers: _authHeaders,
    );
  }

  /// Step 3 — Sets up the applicant form fields for a job.
  Future<Response<Map<String, dynamic>>> setupJobForm({
    required int jobId,
    required List<Map<String, dynamic>> fields,
  }) {
    return post<Map<String, dynamic>>(
      '/jobs/$jobId/step3-form',
      {'fields': fields},
      headers: _authHeaders,
    );
  }

  /// Step 4 — Publishes a job draft.
  ///
  /// [mode] — 'public' | 'private' | 'scheduled'
  /// [scheduledAt] — ISO8601 string, required when mode is 'scheduled'
  Future<Response<Map<String, dynamic>>> publishJob({
    required int jobId,
    String mode = 'public',
    String? scheduledAt,
  }) {
    return post<Map<String, dynamic>>(
      '/jobs/$jobId/step4-publish',
      {
        'mode': mode,
        if (scheduledAt != null) 'scheduled_at': scheduledAt,
      },
      headers: _authHeaders,
    );
  }

  // ─── Status Change ───────────────────────────────────────────────────────────

  /// Closes an active job, preventing new applications.
  Future<Response<Map<String, dynamic>>> closeJob(int jobId) {
    return patch<Map<String, dynamic>>(
      '/jobs/$jobId/close',
      {},
      headers: _authHeaders,
    );
  }
}
