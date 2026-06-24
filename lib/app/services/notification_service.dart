import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';

/// HTTP client for all Notification-related API endpoints.
///
/// Endpoints:
/// - `GET    /notifications`          — list notifications (paginated)
/// - `GET    /notifications/summary`  — get unread notification count
/// - `POST   /notifications/{id}/read` — mark single notification as read
/// - `POST   /notifications/read-all` — mark all notifications as read
class NotificationService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      if (!request.headers.containsKey('Content-Type')) {
        request.headers['Content-Type'] = 'application/json';
      }
      return request;
    });
    super.onInit();
  }

  /// Fetches a paginated list of notifications for the authenticated user.
  Future<Response<Map<String, dynamic>>> listNotifications({
    bool unreadOnly = false,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = {
      'unread_only': unreadOnly.toString(),
      'page': page.toString(),
      'limit': limit.toString(),
    };
    return get<Map<String, dynamic>>(
      '/notifications',
      query: queryParams,
    );
  }

  /// Fetches the summary (unread count) of notifications.
  Future<Response<Map<String, dynamic>>> getSummary() {
    return get<Map<String, dynamic>>('/notifications/summary');
  }

  /// Marks a specific notification as read.
  Future<Response<Map<String, dynamic>>> markRead(int notificationId) {
    return post<Map<String, dynamic>>('/notifications/$notificationId/read', {});
  }

  /// Marks all unread notifications as read.
  Future<Response<Map<String, dynamic>>> markAllRead() {
    return post<Map<String, dynamic>>('/notifications/read-all', {});
  }
}
