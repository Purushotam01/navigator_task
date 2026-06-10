import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/core/constants/app_constants.dart';

class SessionService {
  final SharedPreferences _prefs;
  SessionService(this._prefs);
  bool isLoggedIn() {
    return _prefs.getBool(AppConstants.prefIsLoggedIn) ?? false;
  }

  String? getCurrentUserEmail() {
    return _prefs.getString(AppConstants.prefUserEmail);
  }

  Future<void> saveSession(String email) async {
    await _prefs.setBool(AppConstants.prefIsLoggedIn, true);
    await _prefs.setString(AppConstants.prefUserEmail, email.toLowerCase());
  }

  Future<void> clearSession() async {
    await _prefs.setBool(AppConstants.prefIsLoggedIn, false);
    await _prefs.remove(AppConstants.prefUserEmail);
  }
}
