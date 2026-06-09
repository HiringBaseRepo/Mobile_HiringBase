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
    httpClient.baseUrl = "${dotenv.env['API_BASE_URL']}/applications";
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
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
    return get('', query: params.map((k, v) => MapEntry(k, v.toString())));
  }

  /// GET /applications/{id} — full application detail including score.
  Future<Response> getApplicationDetail(String applicationId) =>
      get('/$applicationId');

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
      '/$applicationId/status',
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
    return get('/public/jobs', query: params.map((k, v) => MapEntry(k, v.toString())));
  }

  /// GET /applications/public/jobs/{jobId} — get public job details.
  Future<Response> publicJobDetail(int jobId) {
    return get('/public/jobs/$jobId');
  }

  /// POST /applications/public/apply — submit application form.
  ///
  /// Expects multi-part FormData.
  Future<Response> publicApply(FormData formData) {
    // We override content-type header to multipart/form-data for uploads.
    return post(
      '/public/apply',
      formData,
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    );
  }

  /// GET /tickets/track/{ticketCode} — track ticket status.
  Future<Response> trackTicket(String ticketCode) {
    // We call an absolute URI because this routes to /api/v1/tickets/track instead of /applications.
    return get('${dotenv.env['API_BASE_URL']}/tickets/track/$ticketCode');
  }
}
