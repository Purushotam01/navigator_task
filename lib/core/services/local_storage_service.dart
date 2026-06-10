import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/models/user_model.dart';
import 'package:task/core/constants/app_constants.dart';

class LocalStorageService {
  late Box _usersBox;
  Future<void> init() async {
    await Hive.initFlutter();
    _usersBox = await Hive.openBox(AppConstants.hiveUsersBox);
  }

  Future<void> saveUser(UserModel user) async {
    await _usersBox.put(user.email.toLowerCase(), user.toMap());
  }

  UserModel? getUser(String email) {
    final userData = _usersBox.get(email.toLowerCase());
    if (userData != null) {
      return UserModel.fromMap(userData);
    }
    return null;
  }

  bool checkUserExists(String email) {
    return _usersBox.containsKey(email.toLowerCase());
  }
}
