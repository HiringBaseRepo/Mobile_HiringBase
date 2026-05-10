import 'package:get/get.dart';
import '../controllers/public_vacancy_controller.dart';

class PublicVacancyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublicVacancyController>(
      () => PublicVacancyController(),
    );
  }
}
