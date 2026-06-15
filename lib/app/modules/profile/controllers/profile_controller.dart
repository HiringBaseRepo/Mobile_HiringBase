import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/services/auth_service.dart';
import 'package:uifrontendmobile/app/data/models/user_model.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final _app = Get.find<AppService>();
  final _jobService = Get.find<JobService>();
  final _authService = Get.find<AuthService>();

  // ── Password Reset Controllers & State ──────────────────────────────
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isSendingOtp = false.obs;
  final isResettingPassword = false.obs;
  final otpSent = false.obs;

  // ── Reactive user data ──────────────────────────────────────────────
  final activeJobsCount = 0.obs;
  final isLoadingStats = false.obs;

  // ── Activities (local, no server endpoint yet) ──────────────────────
  final activities = <Map<String, String>>[
    {
      'title': 'Login Berhasil',
      'subtitle': 'Anda baru saja login ke sistem',
      'time': 'Baru saja',
      'type': 'login',
    },
  ].obs;

  // ── Getters proxying AppService ──────────────────────────────────────
  User? get user => _app.currentUser.value;
  String get userName => user?.name ?? 'User';
  String get userEmail => user?.email ?? '';
  String get userRole => user?.role.toUpperCase() ?? 'HR';
  String? get userAvatar => user?.imageUrl;
  String get memberSince {
    final raw = user?.createdAt;
    if (raw == null || raw.isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.length > 7 ? raw.substring(0, 7) : raw;
    }
  }

  /// Initials for avatar fallback (e.g. "Eskulkullagi" → "E")
  String get initials {
    final parts = userName.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      isLoadingStats.value = true;
      final response = await _jobService.listJobs(status: 'published');
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        if (outer is Map) {
          activeJobsCount.value =
              (outer['total'] as int?) ?? (outer['data'] as List?)?.length ?? 0;
        }
      }
    } catch (_) {
      // Silently fail — stats are non-critical
    } finally {
      isLoadingStats.value = false;
    }
  }

  void logout() {
    _app.logout();
    Get.offAllNamed(Routes.SELECTION);
  }

  // ── Password Reset Operations ───────────────────────────────────────
  Future<void> sendOtp() async {
    final email = userEmail;
    if (email.isEmpty) return;

    try {
      isSendingOtp.value = true;
      final response = await _authService.requestPasswordReset(email);
      if (response.statusCode == 200) {
        otpSent.value = true;
        Get.snackbar(
          'Sukses',
          'Kode OTP berhasil dikirim ke email Anda.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      } else {
        final errorMsg = response.body?['message'] ?? 'Gagal mengirim kode OTP.';
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghubungi server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> submitPasswordReset() async {
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (otp.length != 6) {
      Get.snackbar(
        'Validasi',
        'Kode OTP harus 6 digit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withValues(alpha: 0.1),
        colorText: Colors.amber,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Validasi',
        'Kata sandi minimal 8 karakter.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withValues(alpha: 0.1),
        colorText: Colors.amber,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Validasi',
        'Konfirmasi kata sandi tidak cocok.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.withValues(alpha: 0.1),
        colorText: Colors.amber,
      );
      return;
    }

    try {
      isResettingPassword.value = true;
      final response = await _authService.confirmPasswordReset(
        userEmail,
        otp,
        newPassword,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Kata sandi berhasil diperbarui. Silakan login kembali.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 4),
        );
        
        // Reset state
        otpSent.value = false;
        otpController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        // Close dialog/bottom sheet
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }

        // Delay sedikit sebelum logout agar user sempat membaca snackbar
        Future.delayed(const Duration(seconds: 2), () {
          logout();
        });
      } else {
        final errorMsg = response.body?['message'] ?? 'Gagal memperbarui kata sandi.';
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghubungi server.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isResettingPassword.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
