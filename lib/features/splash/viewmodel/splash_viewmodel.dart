import 'package:flutter/material.dart';
import 'package:task/core/services/session_service.dart';

class SplashViewModel extends ChangeNotifier {
  final SessionService _sessionService;
  SplashViewModel(this._sessionService);
  Future<bool> checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    return _sessionService.isLoggedIn();
  }
}
