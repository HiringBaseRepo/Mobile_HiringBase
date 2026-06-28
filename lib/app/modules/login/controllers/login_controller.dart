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
      _showError('Silakan masukkan email dan kata sandi Anda.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError('Silakan masukkan alamat email yang valid.');
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
        _showError(body['message']?.toString() ?? 'Gagal masuk. Silakan coba lagi.');
        return;
      }

      final data = body['data'] as Map<String, dynamic>?;
      final token = data?['access_token'] as String?;
      if (token == null || token.isEmpty) {
        _showError('Respons server tidak valid. Silakan hubungi dukungan.');
        return;
      }

      // ── Step 2: Persist token in AppService ────────────────────────────
      _appService.setToken(token);

      // ── Step 3: GET /auth/me — fetch user profile ──────────────────────
      final meResponse = await _authService.me();

      if (meResponse.status.hasError || meResponse.body == null) {
        _showError('Tidak dapat memuat profil pengguna. Silakan coba lagi.');
        return;
      }

      final meBody = meResponse.body!;
      final meData = meBody['data'] as Map<String, dynamic>?;
      if (meData == null) {
        _showError('Respons profil tidak valid. Silakan hubungi dukungan.');
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
      _showError('Terjadi kesalahan yang tidak terduga. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }



  // ─── Private helpers ─────────────────────────────────────────────────────

  void _showError(String message) {
    Get.snackbar(
      'Gagal Masuk',
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
        message = 'Email atau kata sandi salah. Silakan periksa kembali data Anda.';
        break;
      case 422:
        message = 'Format data tidak valid. Silakan periksa kembali input Anda.';
        break;
      case 429:
        message = 'Terlalu banyak percobaan masuk. Silakan tunggu beberapa saat.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server sedang tidak tersedia. Silakan coba beberapa saat lagi.';
        break;
      default:
        // Try to get message from body
        final serverMsg = response.body?['message']?.toString();
        message = serverMsg?.isNotEmpty == true
            ? serverMsg!
            : 'Kesalahan koneksi. Silakan periksa koneksi internet Anda.';
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
