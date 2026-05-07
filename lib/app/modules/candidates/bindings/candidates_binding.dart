import 'package:get/get.dart';
import '../controllers/candidates_controller.dart';

class CandidatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidatesController>(
      () => CandidatesController(),
    );
  }
}
