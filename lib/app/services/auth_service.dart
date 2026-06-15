import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';

/// HTTP client service for all authentication-related API calls.
/// Handles login, current-user fetch, and token storage via [AppService].
class AuthService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Returns the Authorization header map using the stored access token.
  Map<String, String> get _authHeaders {
    final token = Get.find<AppService>().accessToken.value;
    return {'Authorization': 'Bearer $token'};
  }

  // ─── Endpoints ──────────────────────────────────────────────────────────────

  /// Sends login credentials to `POST /auth/login`.
  /// Returns the raw [Response] for the caller to handle.
  Future<Response<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    return await post<Map<String, dynamic>>('/auth/login', {
      'email': email,
      'password': password,
    });
  }

  /// Fetches the authenticated user profile from `GET /auth/me`.
  /// Requires a valid Bearer token already stored in [AppService].
  Future<Response<Map<String, dynamic>>> me() async {
    return await get<Map<String, dynamic>>('/auth/me', headers: _authHeaders);
  }

  /// Request OTP for resetting password.
  Future<Response<Map<String, dynamic>>> requestPasswordReset(String email) async {
    return await post<Map<String, dynamic>>('/auth/password-reset/request', {
      'email': email,
    });
  }

  /// Confirm password reset using OTP.
  Future<Response<Map<String, dynamic>>> confirmPasswordReset(
    String email,
    String otp,
    String newPassword,
  ) async {
    return await post<Map<String, dynamic>>('/auth/password-reset/confirm', {
      'email': email,
      'otp': otp,
      'new_password': newPassword,
    });
  }


  /// Calls `POST /auth/logout` to invalidate the refresh-token cookie.
  Future<void> logout() async {
    try {
      await post<Map<String, dynamic>>(
        '/auth/logout',
        {},
        headers: _authHeaders,
      );
    } catch (_) {
      // Swallow network errors — local session will still be cleared.
    } finally {
      final appService = Get.find<AppService>();
      appService.logout();
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
