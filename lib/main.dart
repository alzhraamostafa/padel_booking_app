import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Firebase before runApp
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    // ProviderScope is required by Riverpod — wraps the entire widget tree
    const ProviderScope(
      child: PadelApp(),
    ),
  );
}

class PadelApp extends StatelessWidget {
  const PadelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Court',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class AppTheme {
  static const Color primary = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFB5F23D);
  static const Color surface = Color(0xFFF7F7F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0A0A0A);
  static const Color textMid = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFFAAAAAA);
  static const Color border = Color(0xFFEAEAEA);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: textDark),
          titleTextStyle: TextStyle(
            color: textDark,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      );
}