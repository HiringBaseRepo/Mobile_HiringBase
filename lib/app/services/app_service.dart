import 'package:get/get.dart';
import '../data/models/user_model.dart';

/// Global session state for the authenticated HR user.
/// Holds the current [User] object, role string, and JWT access token.
class AppService extends GetxService {
  final currentRole = ''.obs;   // 'hr' | 'applicant'
  final currentUser = Rxn<User>();
  final accessToken = ''.obs;   // JWT Bearer token

  bool get isHR => currentRole.value == 'hr';
  bool get isApplicant => currentRole.value == 'applicant';
  bool get isAuthenticated => accessToken.value.isNotEmpty;

  /// Stores the JWT access token received after a successful login.
  void setToken(String token) {
    accessToken.value = token;
  }

  void setRole(String role) {
    currentRole.value = role;
  }

  /// Stores both the user profile and derives the role from it.
  void setUser(User user) {
    currentUser.value = user;
    currentRole.value = user.role;
  }

  /// Clears all session state (token, user, role).
  void logout() {
    accessToken.value = '';
    currentUser.value = null;
    currentRole.value = '';
  }
}
