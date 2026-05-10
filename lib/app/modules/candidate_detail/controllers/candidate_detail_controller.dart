import 'package:get/get.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';
import 'package:uifrontendmobile/app/modules/home/controllers/home_controller.dart';
import 'package:uifrontendmobile/app/data/models/candidate_model.dart';

class CandidateDetailController extends GetxController {
  final candidate = Rxn<Candidate>();
  int? candidateIndex;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    
    if (args != null) {
      if (args is Candidate) {
        candidate.value = args;
      } else if (args is Map) {
        if (args.containsKey('candidate')) {
          if (args['candidate'] is Candidate) {
            candidate.value = args['candidate'] as Candidate;
          } else if (args['candidate'] is Map) {
            candidate.value = Candidate.fromJson(Map<String, dynamic>.from(args['candidate'] as Map));
          }
          candidateIndex = args['index'] as int?;
        } else {
          candidate.value = Candidate.fromJson(Map<String, dynamic>.from(args));
        }
      }
    }
    
    // Final check to ensure we have at least basic data
    if (candidate.value == null) {
      candidate.value = const Candidate(
        id: '0',
        name: 'Unknown Candidate',
        role: 'No Role Specified',
        status: 'NEW',
        score: 0,
        matchText: 'N/A',
        appliedAt: '',
        imageUrl: 'https://i.pravatar.cc/150?u=unknown',
        statusColor: 0xFF64748B,
      );
    }
  }

  final isScreening = false.obs;

  Future<void> runScreening() async {
    if (candidate.value == null) return;
    
    isScreening.value = true;
    
    // POST /api/v1/screening/applications/{id}/run
    // Response is quick (queue system)
    await Future.delayed(const Duration(milliseconds: 800));
    Get.snackbar('Screening', 'Proses screening telah dimasukkan dalam antrean');
    
    // Polling simulation
    _startPolling();
  }

  void updateStatus(String status) {
    if (candidate.value == null) return;
    candidate.value = candidate.value!.copyWith(status: status.toUpperCase());

    // Sync back to controllers if index is available
    if (candidateIndex != null) {
      // Sync with CandidatesController
      try {
        final candidatesCtrl = Get.find<CandidatesController>();
        candidatesCtrl.updateCandidateStatus(candidateIndex!, status);
      } catch (_) {}

      // Sync with HomeController (Home has its own list)
      try {
        final homeCtrl = Get.find<HomeController>();
        if (candidateIndex! < homeCtrl.candidates.length) {
          homeCtrl.candidates[candidateIndex!] = homeCtrl.candidates[candidateIndex!].copyWith(
            status: status,
          );
        }
      } catch (_) {}
    }
  }

  void _startPolling() async {
    // Sequence: applied -> doc_check -> ai_processing -> result
    final sequence = ['DOC_CHECK', 'AI_PROCESSING', 'AI_PASSED'];
    
    for (var nextStatus in sequence) {
      await Future.delayed(const Duration(seconds: 4));
      updateStatus(nextStatus);
      
      if (nextStatus == 'AI_PASSED') {
        isScreening.value = false;
        // Mock score update from background worker
        candidate.value = candidate.value!.copyWith(score: 85);
        Get.snackbar('Screening Selesai', 'Kandidat telah selesai di-screening dengan skor 85');
        break;
      }
    }
  }
}
