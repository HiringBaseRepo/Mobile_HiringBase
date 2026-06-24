import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';
import 'package:uifrontendmobile/app/data/models/user_model.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/services/auth_service.dart';

/// Controller for the Login screen.
///
/// Handles credential validation, API authentication via [AuthService],
/// session initialisation via [AppService], and post-login navigation.
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  // ─── Private deps ────────────────────────────────────────────────────────
  final _authService = Get.find<AuthService>();
  final _appService = Get.find<AppService>();

  // ─── UI helpers ─────────────────────────────────────────────────────────

  /// Toggles the password field visibility.
  void togglePasswordVisibility() => isPasswordVisible.toggle();

  // ─── Login flow ──────────────────────────────────────────────────────────

  /// Validates the form and, if valid, authenticates against the server.
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ── Client-side validation ──────────────────────────────────────────
    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    isLoading.value = true;
    try {
      // ── Step 1: POST /auth/login — obtain access token ─────────────────
      final loginResponse = await _authService.login(email, password);

      if (loginResponse.status.hasError || loginResponse.body == null) {
        _handleLoginError(loginResponse);
        return;
      }

      final body = loginResponse.body!;
      final bool success = body['success'] == true;
      if (!success) {
        _showError(body['message']?.toString() ?? 'Login failed. Please try again.');
        return;
      }

      final data = body['data'] as Map<String, dynamic>?;
      final token = data?['access_token'] as String?;
      if (token == null || token.isEmpty) {
        _showError('Invalid server response. Please contact support.');
        return;
      }

      // ── Step 2: Persist token in AppService ────────────────────────────
      _appService.setToken(token);

      // ── Step 3: GET /auth/me — fetch user profile ──────────────────────
      final meResponse = await _authService.me();

      if (meResponse.status.hasError || meResponse.body == null) {
        _showError('Could not load user profile. Please try again.');
        return;
      }

      final meBody = meResponse.body!;
      final meData = meBody['data'] as Map<String, dynamic>?;
      if (meData == null) {
        _showError('Invalid profile response. Please contact support.');
        return;
      }

      // ── Step 4: Store user in AppService ───────────────────────────────
      final user = User.fromJson(meData);
      _appService.setUser(user);

      // ── Step 5: Persist session for cold-start restore ─────────────────
      await _appService.persistSession();

      // ── Step 6: Navigate to home ───────────────────────────────────────
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Placeholder for SSO login — not yet implemented.
  void loginWithSSO() {
    Get.snackbar(
      'SSO',
      'SSO Login is currently unavailable.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  void _showError(String message) {
    Get.snackbar(
      'Login Failed',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
      colorText: AppColors.error,
      duration: const Duration(seconds: 3),
    );
  }

  /// Maps HTTP status codes and server error messages to user-friendly strings.
  void _handleLoginError(Response<Map<String, dynamic>> response) {
    final statusCode = response.statusCode ?? 0;
    String message;

    switch (statusCode) {
      case 401:
        message = 'Invalid email or password. Please check your credentials.';
        break;
      case 422:
        message = 'Invalid request format. Please check your input.';
        break;
      case 429:
        message = 'Too many login attempts. Please wait and try again.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server is temporarily unavailable. Please try again later.';
        break;
      default:
        // Try to get message from body
        final serverMsg = response.body?['message']?.toString();
        message = serverMsg?.isNotEmpty == true
            ? serverMsg!
            : 'Connection error. Please check your internet connection.';
    }

    _showError(message);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
