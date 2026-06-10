import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/session_service.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view/signup_screen.dart';
import 'features/auth/viewmodel/login_viewmodel.dart';
import 'features/auth/viewmodel/signup_viewmodel.dart';
import 'features/home/view/home_map_screen.dart';
import 'features/home/viewmodel/home_map_viewmodel.dart';
import 'features/splash/view/splash_screen.dart';
import 'features/splash/viewmodel/splash_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = LocalStorageService();
  await storageService.init();
  final prefs = await SharedPreferences.getInstance();
  final sessionService = SessionService(prefs);
  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storageService),
        Provider<SessionService>.value(value: sessionService),
        ChangeNotifierProvider(create: (_) => SplashViewModel(sessionService)),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(storageService, sessionService),
        ),
        ChangeNotifierProvider(
          create: (_) => SignupViewModel(storageService, sessionService),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeMapViewModel(storageService, sessionService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigator Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.splashRoute,
      routes: {
        AppConstants.splashRoute: (context) => const SplashScreen(),
        AppConstants.loginRoute: (context) => const LoginScreen(),
        AppConstants.signupRoute: (context) => const SignupScreen(),
        AppConstants.homeRoute: (context) => const HomeMapScreen(),
      },
    );
  }
}
