import 'package:get/get.dart';
import '../data/models/user_model.dart';

class AppService extends GetxService {
  final currentRole = ''.obs; // 'hr' | 'applicant'
  final currentUser = Rxn<User>();

  bool get isHR => currentRole.value == 'hr';
  bool get isApplicant => currentRole.value == 'applicant';

  void setRole(String role) {
    currentRole.value = role;
  }

  void setUser(User user) {
    currentUser.value = user;
    currentRole.value = user.role;
  }

  void logout() {
    currentUser.value = null;
    currentRole.value = '';
  }
}
