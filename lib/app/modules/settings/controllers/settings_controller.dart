import 'package:get/get.dart';
import '../../../services/app_service.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final _appService = Get.find<AppService>();
  final _authService = Get.find<AuthService>();

  void logout() async {
    await _authService.logout();
  }
}
