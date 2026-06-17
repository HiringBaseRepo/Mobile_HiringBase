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
          'Status Updated',
          'Status changed to ${data?['new_status_label'] ?? updated}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response.body?['message']?.toString() ?? 'Failed to update status.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar('Error', 'Connection error.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// Trigger AI screening via POST /screening/applications/{id}/run.
  Future<void> runScreening() async {
    final c = candidate.value;
    if (c == null) return;
    try {
      isScreening.value = true;
      final response = await _service.runScreening(c.id);

      if (response.statusCode == 200 && response.body != null) {
        Get.snackbar(
          'AI Screening Queued',
          response.body?['message']?.toString() ?? 'Screening has been queued successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Refresh candidate detail to fetch updated score & status
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
          'Error',
          response.body?['message']?.toString() ?? 'Failed to start AI screening.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar('Error', 'Connection error.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isScreening.value = false;
    }
  }


  /// Available status transitions — presented in UI action sheet.
  static const statusOptions = [
    {'value': 'under_review', 'label': 'Under Review'},
    {'value': 'interview', 'label': 'Invite to Interview'},
    {'value': 'offered', 'label': 'Send Offer'},
    {'value': 'hired', 'label': 'Mark as Hired'},
    {'value': 'rejected', 'label': 'Reject'},
  ];
}
