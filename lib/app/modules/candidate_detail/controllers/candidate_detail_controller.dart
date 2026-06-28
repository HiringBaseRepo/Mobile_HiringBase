import 'package:get/get.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';
import 'package:uifrontendmobile/app/services/application_service.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';

class CandidateDetailController extends GetxController {
  final _service = Get.find<ApplicationService>();

  final candidate = Rxn<Candidate>();
  final isLoading = false.obs;
  final isUpdatingStatus = false.obs;
  final isScreening = false.obs;
  final isPolling = false.obs;

  /// Screening in-progress statuses — polling continues while status is one of these.
  static const _inProgressStatuses = {'applied', 'doc_check', 'ai_processing'};

  /// Polling config: check every 3s, max 20 attempts (60s total).
  static const _pollInterval = Duration(seconds: 3);
  static const _maxPollAttempts = 20;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is Candidate) {
      candidate.value = args;
      _fetchDetail(args.id);
    } else if (args is Map && args.containsKey('candidate')) {
      final c = args['candidate'];
      candidate.value = c is Candidate ? c : Candidate.fromJson(Map<String, dynamic>.from(c as Map));
      _fetchDetail(candidate.value!.id);
    } else if (args is Map) {
      candidate.value = Candidate.fromJson(Map<String, dynamic>.from(args));
      _fetchDetail(candidate.value!.id);
    }
  }

  /// Fetch full detail from server to get name, email, answers, score.
  Future<void> _fetchDetail(String applicationId) async {
    try {
      isLoading.value = true;
      final response = await _service.getApplicationDetail(applicationId);
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body!['data'];
        if (data != null) {
          candidate.value = Candidate.fromDetail(Map<String, dynamic>.from(data as Map));
        }
      }
    } catch (_) {
      // Keep whatever partial data we have from the list
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh candidate detail from server.
  Future<void> refreshData() async {
    final c = candidate.value;
    if (c != null) {
      await _fetchDetail(c.id);
    }
  }

  /// Update status via PATCH /applications/{id}/status.
  Future<void> updateStatus(String newStatus, {String? reason}) async {
    final c = candidate.value;
    if (c == null) return;
    try {
      isUpdatingStatus.value = true;
      final response = await _service.updateApplicationStatus(
        c.id,
        newStatus,
        reason: reason,
      );

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body!['data'];
        final updated = (data?['new_status'] as String?) ?? newStatus;
        candidate.value = c.copyWith(
          status: updated,
          rejectionReason: updated == 'rejected' ? reason : null,
        );

        // Sync back to candidates list
        try {
          Get.find<CandidatesController>().updateCandidateStatus(c.id, updated);
        } catch (_) {}

        Get.snackbar(
          'Status Diperbarui',
          'Status diubah menjadi ${candidate.value?.statusIndonesian ?? updated}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Kesalahan',
          response.body?['message']?.toString() ?? 'Gagal memperbarui status.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar('Kesalahan', 'Kesalahan koneksi.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// Trigger AI screening via POST /screening/applications/{id}/run,
  /// then poll until screening completes (status exits in-progress states).
  Future<void> runScreening() async {
    final c = candidate.value;
    if (c == null) return;
    try {
      isScreening.value = true;
      final response = await _service.runScreening(c.id);

      if (response.statusCode == 200 && response.body != null) {
        Get.snackbar(
          'Skrining AI Masuk Antrean',
          'Proses skrining berhasil dimasukkan ke dalam antrean.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Poll until screening completes
        await _pollUntilDone(c.id);

        // Re-fetch detail after polling ends (in case polling was skipped)
        await _fetchDetail(c.id);

        // Sync status back to candidates list
        final updatedStatus = candidate.value?.status;
        if (updatedStatus != null) {
          try {
            Get.find<CandidatesController>().updateCandidateStatus(c.id, updatedStatus);
          } catch (_) {}
        }
      } else {
        Get.snackbar(
          'Kesalahan',
          response.body?['message']?.toString() ?? 'Gagal memulai skrining AI.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar('Kesalahan', 'Kesalahan koneksi.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isScreening.value = false;
      isPolling.value = false;
    }
  }

  /// Poll [GET /applications/{id}] every [_pollInterval] until status
  /// exits the in-progress set or [_maxPollAttempts] is reached.
  Future<void> _pollUntilDone(String applicationId) async {
    isPolling.value = true;
    for (var i = 0; i < _maxPollAttempts; i++) {
      await Future.delayed(_pollInterval);
      await _fetchDetail(applicationId);
      final status = candidate.value?.status ?? '';
      if (!_inProgressStatuses.contains(status)) break;
    }
    isPolling.value = false;
  }


  /// Available status transitions — presented in UI action sheet.
  static const statusOptions = [
    {'value': 'under_review', 'label': 'Tinjau Lamaran'},
    {'value': 'interview', 'label': 'Undang Wawancara'},
    {'value': 'offered', 'label': 'Kirim Penawaran Kerja'},
    {'value': 'hired', 'label': 'Terima Kerja'},
    {'value': 'rejected', 'label': 'Tolak Lamaran'},
  ];
}
