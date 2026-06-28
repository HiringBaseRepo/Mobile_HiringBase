import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class SettingsController extends GetxController {
  final _authService = Get.find<AuthService>();

  void logout() async {
    await _authService.logout();
  }
}
