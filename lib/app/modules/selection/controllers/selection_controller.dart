import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/app_service.dart';
import '../../../services/navigation_service.dart';

class SelectionController extends GetxController {
  final _appService = Get.find<AppService>();
  final _navService = Get.find<NavigationService>();

  void selectHR() {
    _appService.setRole('hr');
    _navService.reset();
    Get.offAllNamed(Routes.LOGIN);
  }

  void selectApplicant() {
    _appService.setRole('applicant');
    _navService.reset();
    Get.offAllNamed(Routes.PUBLIC_VACANCY);
  }
}
