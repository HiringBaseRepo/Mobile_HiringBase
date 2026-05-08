import 'package:get/get.dart';
import '../../candidates/controllers/candidates_controller.dart';
import '../../home/controllers/home_controller.dart';

class CandidateDetailController extends GetxController {
  final candidate = <String, dynamic>{}.obs;
  int? candidateIndex;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    
    if (args != null) {
      if (args is Map) {
        if (args.containsKey('candidate') && args['candidate'] is Map) {
          // New format: {'candidate': ..., 'index': ...}
          candidate.assignAll(Map<String, dynamic>.from(args['candidate'] as Map));
          candidateIndex = args['index'] as int?;
        } else {
          // Old format or direct map
          candidate.assignAll(Map<String, dynamic>.from(args));
        }
      }
    }
    
    // Final check to ensure we have at least basic data
    if (candidate.isEmpty || candidate['name'] == null) {
      candidate.assignAll({
        'name': 'Unknown Candidate',
        'role': 'No Role Specified',
        'status': 'NEW',
        'score': 0,
        'image': 'https://i.pravatar.cc/150?u=unknown',
      });
    }
  }

  void updateStatus(String status) {
    candidate['status'] = status.toUpperCase();
    candidate.refresh();

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
          homeCtrl.candidates[candidateIndex!] = {
            ...homeCtrl.candidates[candidateIndex!],
            'status': status,
          };
          homeCtrl.candidates.refresh();
        }
      } catch (_) {}
    }
  }
}
