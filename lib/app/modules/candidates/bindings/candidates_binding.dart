import 'package:get/get.dart';
import 'package:uifrontendmobile/app/modules/candidates/controllers/candidates_controller.dart';

class CandidatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidatesController>(
      () => CandidatesController(),
    );
  }
}
