import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';

/// HTTP client service for all authentication-related API calls.
///
/// Automatically injects the Bearer token via [httpClient.addRequestModifier]
/// and manages the refresh-token cookie for silent token rotation.
class AuthService extends GetConnect {
  static const _refreshCookieKey = 'refresh_cookie';

  /// True while a token refresh is in-flight, to coalesce concurrent 401s.
  bool _isRefreshing = false;
  final _refreshQueue = <Completer<void>>[];

  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    httpClient.addAuthenticator<dynamic>((request) async {
      await _handleTokenRefresh();
      final token = Get.find<AppService>().accessToken.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    super.onInit();
  }

  // ─── Cookie helpers ─────────────────────────────────────────────────────────

  /// Extracts the `refresh_token={value}` portion from a Set-Cookie header.
  String? _extractRefreshCookie(Map<String, String>? headers) {
    if (headers == null) return null;
    final setCookie = headers['set-cookie'];
    if (setCookie == null || setCookie.isEmpty) return null;
    for (final part in setCookie.split(';')) {
      final trimmed = part.trim();
      if (trimmed.startsWith('refresh_token=')) {
        return trimmed;
      }
    }
    return null;
  }

  Future<String?> _getStoredRefreshCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshCookieKey);
  }

  Future<void> _storeRefreshCookie(Map<String, String>? headers) async {
    final cookie = _extractRefreshCookie(headers);
    if (cookie != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshCookieKey, cookie);
    }
  }

  /// Attempts a token refresh, coalescing concurrent 401 retries.
  ///
  /// If a refresh is already in-flight, subsequent callers wait on the same
  /// pending refresh instead of triggering redundant requests.
  Future<void> _handleTokenRefresh() async {
    final appService = Get.find<AppService>();
    if (appService.accessToken.value.isEmpty) return;

    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final result = await refresh();
      if (result.statusCode == 200 &&
          result.body != null &&
          result.body!['success'] == true) {
        final token = result.body!['data']?['access_token'] as String?;
        if (token != null && token.isNotEmpty) {
          appService.setToken(token);
          await appService.persistSession();
        }
      } else {
        await _failRefresh(appService);
      }
    } catch (_) {
      await _failRefresh(appService);
    } finally {
      _isRefreshing = false;
      for (final c in _refreshQueue) {
        if (!c.isCompleted) c.complete();
      }
      _refreshQueue.clear();
    }
  }

  Future<void> _failRefresh(AppService appService) async {
    await appService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshCookieKey);
    Get.offAllNamed(Routes.LOGIN);
  }

  // ─── Endpoints ──────────────────────────────────────────────────────────────

  /// Sends login credentials to `POST /auth/login`.
  /// Stores the refresh-token cookie from the response headers.
  Future<Response<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    final response = await post<Map<String, dynamic>>('/auth/login', {
      'email': email,
      'password': password,
    });
    if (response.headers != null) {
      await _storeRefreshCookie(response.headers);
    }
    return response;
  }

  /// Fetches the authenticated user profile from `GET /auth/me`.
  Future<Response<Map<String, dynamic>>> me() async {
    return await get<Map<String, dynamic>>('/auth/me');
  }

  /// Rotates the access token via `POST /auth/refresh`.
  ///
  /// Sends the stored refresh cookie and updates it from the response.
  Future<Response<Map<String, dynamic>>> refresh() async {
    final cookie = await _getStoredRefreshCookie();
    final response = await post<Map<String, dynamic>>(
      '/auth/refresh',
      {},
      headers: cookie != null ? {'Cookie': cookie} : null,
    );
    if (response.headers != null) {
      await _storeRefreshCookie(response.headers);
    }
    return response;
  }

  /// Requests a password-reset OTP.
  Future<Response<Map<String, dynamic>>> requestPasswordReset(String email) async {
    return await post<Map<String, dynamic>>('/auth/password-reset/request', {
      'email': email,
    });
  }

  /// Confirms a password reset with the OTP.
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

  /// Calls `POST /auth/logout` to invalidate the refresh-token cookie,
  /// then clears the local session and navigates to the login screen.
  Future<void> logout() async {
    try {
      await post<Map<String, dynamic>>('/auth/logout', {});
    } catch (_) {
      // Server call is best-effort; local session is still cleared.
    } finally {
      final appService = Get.find<AppService>();
      await appService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_refreshCookieKey);
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
