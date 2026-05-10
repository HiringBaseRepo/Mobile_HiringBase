import 'package:get/get.dart';
import '../controllers/job_detail_hr_controller.dart';

class JobDetailHrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailHrController>(
      () => JobDetailHrController(),
    );
  }
}
