import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/core/services/local_storage_service.dart';
import 'package:task/core/services/session_service.dart';
import 'package:task/models/user_model.dart';

class SignupViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  final SessionService _sessionService;
  final ImagePicker _imagePicker = ImagePicker();
  SignupViewModel(this._storageService, this._sessionService);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  String? _imagePath;
  String? get imagePath => _imagePath;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        _imagePath = pickedFile.path;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  void clearImage() {
    _imagePath = null;
    notifyListeners();
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    if (_storageService.checkUserExists(email)) {
      _errorMessage = 'User with this email already exists.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    final newUser = UserModel(
      name: name,
      email: email,
      mobile: mobile,
      password: password,
      imagePath: _imagePath,
    );
    await _storageService.saveUser(newUser);
    await _sessionService.saveSession(email);
    _isLoading = false;
    notifyListeners();
    return true;
  }
}
