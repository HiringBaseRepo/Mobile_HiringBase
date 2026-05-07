import 'package:get/get.dart';

class CandidateDetailController extends GetxController {
  late Map<String, dynamic> candidate;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      candidate = Get.arguments as Map<String, dynamic>;
    } else {
      // Fallback data if arguments are missing
      candidate = {
        'name': 'Unknown',
        'role': 'N/A',
        'status': 'N/A',
        'score': 0,
        'image': 'https://i.pravatar.cc/150?u=unknown',
      };
    }
  }
}
