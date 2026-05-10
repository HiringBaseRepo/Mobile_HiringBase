import 'package:get/get.dart';
import '../controllers/manual_override_controller.dart';

class ManualOverrideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualOverrideController>(
      () => ManualOverrideController(),
    );
  }
}
