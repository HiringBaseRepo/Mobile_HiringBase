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

  // ── Activities (dynamically loaded from server) ─────────────────────
  final activities = <Map<String, String>>[].obs;

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
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      final response = await _jobService.listAuditLogs();
      if (response.statusCode == 200 && response.body != null) {
        final outer = response.body!['data'];
        if (outer is Map) {
          final listRaw = outer['data'] as List?;
          if (listRaw != null) {
            final mapped = listRaw.map((log) {
              final action = log['action'] as String? ?? '';
              final actionLabel = log['action_label'] as String? ?? action;
              final createdAt = log['created_at'] as String? ?? '';

              String timeStr = 'Baru saja';
              if (createdAt.isNotEmpty) {
                try {
                  final dt = DateTime.parse(createdAt).toLocal();
                  final diff = DateTime.now().difference(dt);
                  if (diff.inMinutes < 60) {
                    timeStr = '${diff.inMinutes}m ago';
                  } else if (diff.inHours < 24) {
                    timeStr = '${diff.inHours}h ago';
                  } else if (diff.inDays < 7) {
                    timeStr = '${diff.inDays}d ago';
                  } else {
                    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                    timeStr = '${dt.day} ${months[dt.month - 1]}';
                  }
                } catch (_) {}
              }

              String type = 'default';
              if (action.contains('login') || action.contains('auth')) {
                type = 'login';
              } else if (action.contains('job')) {
                type = 'job';
              } else if (action.contains('candidate') || action.contains('application') || action.contains('status') || action.contains('screen') || action.contains('override')) {
                type = 'candidate';
              } else if (action.contains('email') || action.contains('mail')) {
                type = 'email';
              }

              String subtitle = '';
              final newVals = log['new_values'] as Map?;
              if (newVals != null) {
                if (action.contains('publish') && newVals.containsKey('job_id')) {
                  subtitle = 'Mempublikasikan lowongan kerja #${newVals['job_id']}';
                } else if (action.contains('create') && newVals.containsKey('title')) {
                  subtitle = 'Membuat lowongan baru: ${newVals['title']}';
                } else if (action.contains('status') && newVals.containsKey('new_status')) {
                  subtitle = 'Mengubah status pelamar #${newVals['application_id'] ?? ''} menjadi ${newVals['new_status']}';
                } else if (action.contains('schedule') && newVals.containsKey('scheduled_at')) {
                  subtitle = 'Menjadwalkan wawancara untuk pelamar #${newVals['application_id'] ?? ''}';
                } else {
                  subtitle = 'Melakukan aksi: $actionLabel';
                }
              } else {
                subtitle = 'Aksi $actionLabel berhasil dicatat';
              }

              return {
                'title': actionLabel,
                'subtitle': subtitle,
                'time': timeStr,
                'type': type,
              };
            }).toList();

            activities.assignAll(List<Map<String, String>>.from(mapped));
            return;
          }
        }
      }
    } catch (_) {}
    
    // Fallback if empty or error
    if (activities.isEmpty) {
      activities.assignAll([
        {
          'title': 'Login Berhasil',
          'subtitle': 'Anda baru saja login ke sistem',
          'time': 'Baru saja',
          'type': 'login',
        },
      ]);
    }
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

  void logout() async {
    await _authService.logout();
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
