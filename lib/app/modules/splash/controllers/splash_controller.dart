import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/app_service.dart';

class SplashController extends GetxController {
  final _appService = Get.find<AppService>();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateNext();
  }

  void _navigateNext() {
    if (_appService.isAuthenticated) {
      if (_appService.isHR) {
        Get.offAllNamed(Routes.HOME);
      } else if (_appService.isApplicant) {
        Get.offAllNamed(Routes.PUBLIC_VACANCY);
      } else {
        Get.offAllNamed(Routes.SELECTION);
      }
    } else {
      Get.offAllNamed(Routes.SELECTION);
    }
  }
}
