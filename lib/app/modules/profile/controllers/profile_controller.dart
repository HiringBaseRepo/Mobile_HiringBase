import 'package:get/get.dart';
import 'package:uifrontendmobile/app/services/app_service.dart';
import 'package:uifrontendmobile/app/services/job_service.dart';
import 'package:uifrontendmobile/app/data/models/user_model.dart';
import 'package:uifrontendmobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final _app = Get.find<AppService>();
  final _jobService = Get.find<JobService>();

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
}
