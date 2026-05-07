import 'package:get/get.dart';
import '../controllers/candidate_detail_controller.dart';

class CandidateDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidateDetailController>(
      () => CandidateDetailController(),
    );
  }
}
