import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

/// Global session state for the authenticated user.
///
/// Holds the current [User] object, role string, and JWT access token.
/// Persists session to [SharedPreferences] for cold-start restoration.
class AppService extends GetxService {
  final currentRole = ''.obs;   // 'hr' | 'applicant'
  final currentUser = Rxn<User>();
  final accessToken = ''.obs;   // JWT Bearer token

  bool get isHR => currentRole.value == 'hr';
  bool get isApplicant => currentRole.value == 'applicant';
  bool get isAuthenticated => accessToken.value.isNotEmpty;

  static const _tokenKey = 'app_access_token';
  static const _roleKey = 'app_role';
  static const _userIdKey = 'app_user_id';
  static const _userNameKey = 'app_user_name';
  static const _userEmailKey = 'app_user_email';
  static const _userCompanyIdKey = 'app_user_company_id';
  static const _userImageUrlKey = 'app_user_image_url';

  /// Restores a persisted session from [SharedPreferences].
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      accessToken.value = token;
      currentRole.value = prefs.getString(_roleKey) ?? '';

      final id = prefs.getString(_userIdKey);
      final name = prefs.getString(_userNameKey);
      final email = prefs.getString(_userEmailKey);
      final imageUrl = prefs.getString(_userImageUrlKey);
      if (id != null && name != null && email != null) {
        currentUser.value = User(
          id: id,
          name: name,
          email: email,
          role: currentRole.value,
          companyId: prefs.getInt(_userCompanyIdKey),
          imageUrl: imageUrl,
        );
      }
    }
  }

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

  /// Writes the current session to [SharedPreferences].
  Future<void> persistSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken.value);

    final user = currentUser.value;
    if (user != null) {
      await prefs.setString(_roleKey, user.role);
      await prefs.setString(_userIdKey, user.id);
      await prefs.setString(_userNameKey, user.name);
      await prefs.setString(_userEmailKey, user.email);
      if (user.imageUrl != null) {
        await prefs.setString(_userImageUrlKey, user.imageUrl!);
      } else {
        await prefs.remove(_userImageUrlKey);
      }
      if (user.companyId != null) {
        await prefs.setInt(_userCompanyIdKey, user.companyId!);
      }
    }
  }

  /// Clears all session state and removes persisted data.
  Future<void> logout() async {
    accessToken.value = '';
    currentUser.value = null;
    currentRole.value = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userCompanyIdKey);
    await prefs.remove(_userImageUrlKey);
  }
}
