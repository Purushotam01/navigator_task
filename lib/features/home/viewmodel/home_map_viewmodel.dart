import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:task/core/services/local_storage_service.dart';
import 'package:task/core/services/session_service.dart';
import 'package:task/models/user_model.dart';

class HomeMapViewModel extends ChangeNotifier {
  final LocalStorageService _storageService;
  final SessionService _sessionService;
  HomeMapViewModel(this._storageService, this._sessionService);
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  final List<LatLng> _routePoints = const [
    LatLng(28.5355, 77.3910),
    LatLng(28.5390, 77.3850),
    LatLng(28.5450, 77.3780),
    LatLng(28.5550, 77.3650),
    LatLng(28.5680, 77.3520),
    LatLng(28.5720, 77.3450),
    LatLng(28.5800, 77.3320),
    LatLng(28.5820, 77.3210),
    LatLng(28.5890, 77.3120),
    LatLng(28.5950, 77.3000),
    LatLng(28.6010, 77.2900),
    LatLng(28.6100, 77.2800),
    LatLng(28.6120, 77.2650),
    LatLng(28.6150, 77.2500),
    LatLng(28.6180, 77.2300),
    LatLng(28.6129, 77.2295),
  ];
  List<LatLng> get routePoints => _routePoints;
  final List<LatLng> _interpolatedPoints = [];
  List<LatLng> get interpolatedPoints => _interpolatedPoints;
  LatLng _currentCarPosition = const LatLng(28.5355, 77.3910);
  LatLng get currentCarPosition => _currentCarPosition;
  double _carBearing = 0.0;
  double get carBearing => _carBearing;
  int _currentPointIndex = 0;
  Timer? _timer;
  bool _isMoving = false;
  bool get isMoving => _isMoving;
  void loadCurrentUser() {
    final email = _sessionService.getCurrentUserEmail();
    if (email != null) {
      _currentUser = _storageService.getUser(email);
      notifyListeners();
    }
  }

  void generateInterpolatedRoute() {
    _interpolatedPoints.clear();
    for (int i = 0; i < _routePoints.length - 1; i++) {
      LatLng start = _routePoints[i];
      LatLng end = _routePoints[i + 1];
      int steps = 30;
      for (int step = 0; step <= steps; step++) {
        double t = step / steps;
        double lat = start.latitude + (end.latitude - start.latitude) * t;
        double lng = start.longitude + (end.longitude - start.longitude) * t;
        _interpolatedPoints.add(LatLng(lat, lng));
      }
    }
    if (_interpolatedPoints.isNotEmpty) {
      _currentCarPosition = _interpolatedPoints.first;
    }
  }

  double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * math.pi / 180;
    double lng1 = start.longitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double lng2 = end.longitude * math.pi / 180;
    double dLon = lng2 - lng1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double radians = math.atan2(y, x);
    return (radians * 180 / math.pi + 360) % 360;
  }

  void startCarMovement(Function(LatLng, double) onUpdate) {
    if (_isMoving) return;
    if (_interpolatedPoints.isEmpty) {
      generateInterpolatedRoute();
    }
    _isMoving = true;
    _currentPointIndex = 0;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentPointIndex >= _interpolatedPoints.length - 1) {
        stopCarMovement();
        return;
      }
      LatLng currentPoint = _interpolatedPoints[_currentPointIndex];
      LatLng nextPoint = _interpolatedPoints[_currentPointIndex + 1];
      _currentCarPosition = nextPoint;
      _carBearing = calculateBearing(currentPoint, nextPoint);
      _currentPointIndex++;
      onUpdate(_currentCarPosition, _carBearing);
      notifyListeners();
    });
  }

  void stopCarMovement() {
    _timer?.cancel();
    _isMoving = false;
    notifyListeners();
  }

  Future<void> logout() async {
    stopCarMovement();
    await _sessionService.clearSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
