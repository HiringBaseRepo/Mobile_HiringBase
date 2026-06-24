import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';

/// HTTP client for the Applications and Ticket Tracking endpoints.
///
/// Base: /api/v1/applications
/// Auth: Bearer token from [AppService].
class ApplicationService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      if (!request.url.path.contains('public/apply') && !request.headers.containsKey('Content-Type')) {
        request.headers['Content-Type'] = 'application/json';
      }
      return request;
    });
    super.onInit();
  }

  // ─── HR endpoints ──────────────────────────────────────────────────────────

  /// GET /applications — list applications for HR's company.
  ///
  /// Optional filters: [jobId], [statusFilter], [q] (search), [page], [limit].
  Future<Response> listApplications({
    int? jobId,
    String? statusFilter,
    String? q,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (jobId != null) 'job_id': jobId,
      if (statusFilter != null && statusFilter != 'all') 'status_filter': statusFilter,
      if (q != null && q.isNotEmpty) 'q': q,
    };
    return get('/applications', query: params.map((k, v) => MapEntry(k, v.toString())));
  }

  /// GET /applications/{id} — full application detail including score.
  Future<Response> getApplicationDetail(String applicationId) =>
      get('/applications/$applicationId');

  /// PATCH /applications/{id}/status — update application status.
  ///
  /// [newStatus] must be one of the server ApplicationStatus enum values.
  Future<Response> updateApplicationStatus(
    String applicationId,
    String newStatus, {
    String? reason,
  }) {
    final params = <String, String>{
      'new_status': newStatus,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    };
    return patch(
      '/applications/$applicationId/status',
      {},
      query: params,
    );
  }

  // ─── Public Applicant endpoints ─────────────────────────────────────────────

  /// GET /applications/public/jobs — list public jobs.
  Future<Response> publicListJobs({
    String? q,
    String? location,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (q != null && q.isNotEmpty) 'q': q,
      if (location != null && location.isNotEmpty) 'location': location,
    };
    return get('/applications/public/jobs', query: params.map((k, v) => MapEntry(k, v.toString())));
  }

  /// GET /applications/public/jobs/{jobId} — get public job details.
  Future<Response> publicJobDetail(int jobId) {
    return get('/applications/public/jobs/$jobId');
  }

  /// POST /applications/public/apply — submit application form.
  ///
  /// Expects multi-part FormData.
  Future<Response> publicApply(FormData formData) {
    return post(
      '/applications/public/apply',
      formData,
    );
  }

  /// GET /tickets/track/{ticketCode} — track ticket status.
  Future<Response> trackTicket(String ticketCode) {
    return get('/tickets/track/$ticketCode');
  }

  // ─── Interview Endpoints ───────────────────────────────────────────────────

  /// POST /interviews — schedule a new interview
  Future<Response> scheduleInterview({
    required int applicationId,
    required String scheduledAt, // ISO string
    int durationMinutes = 60,
    String? location,
    String? meetingLink,
    String interviewType = 'video',
    List<int>? interviewerIds,
  }) {
    final body = {
      'application_id': applicationId,
      'scheduled_at': scheduledAt,
      'duration_minutes': durationMinutes,
      'location': location,
      'meeting_link': meetingLink,
      'interview_type': interviewType,
      'interviewer_ids': interviewerIds ?? [],
    };
    return post('/interviews', body);
  }

  /// GET /interviews/application/{applicationId} — retrieve interview details
  Future<Response> getInterview(int applicationId) {
    return get('/interviews/application/$applicationId');
  }

  /// POST /screening/applications/{applicationId}/run — run AI screening manually
  Future<Response> runScreening(String applicationId) {
    return post('/screening/applications/$applicationId/run', {});
  }

  /// POST /screening/batch/run — run AI screening for multiple applications.
  Future<Response> runBatchScreening(List<String> applicationIds) {
    final ids = applicationIds.map(int.parse).toList();
    return post('/screening/batch/run', {'application_ids': ids});
  }
}
