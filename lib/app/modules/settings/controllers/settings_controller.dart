import 'package:get/get.dart';
import '../../../services/app_service.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final _appService = Get.find<AppService>();

  void logout() {
    _appService.setRole('');
    Get.offAllNamed(Routes.SELECTION);
  }
}
