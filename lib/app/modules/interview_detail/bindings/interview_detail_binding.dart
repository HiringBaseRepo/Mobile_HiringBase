import 'package:get/get.dart';
import '../controllers/interview_detail_controller.dart';

class InterviewDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewDetailController>(
      () => InterviewDetailController(),
    );
  }
}
