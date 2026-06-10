import 'package:flutter/material.dart';
import 'package:task/core/services/local_storage_service.dart';
import 'package:task/core/services/session_service.dart';

class LoginViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  final SessionService _sessionService;
  LoginViewModel(this._storageService, this._sessionService);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _storageService.getUser(email);
    if (user == null) {
      _errorMessage = 'User not found. Please sign up.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    if (user.password != password) {
      _errorMessage = 'Incorrect password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    await _sessionService.saveSession(email);
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
