import 'package:get/get.dart';
import '../controllers/jobs_list_controller.dart';

class JobsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobsListController>(
      () => JobsListController(),
    );
  }
}
