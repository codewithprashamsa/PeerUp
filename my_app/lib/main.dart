import 'package:flutter/material.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PeerUpApp());
}

class PeerUpApp extends StatelessWidget {
  const PeerUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF52A3CC);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PeerUp',

      // ================= LIGHT THEME =================
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),

        colorScheme: ColorScheme.light(
          primary: brandBlue,
          surface: Colors.white,
          onSurface: const Color(0xFF1E293B),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E293B),
          centerTitle: true,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 1,
        ),
      ),

      // ================= DARK THEME =================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),

        colorScheme: ColorScheme.dark(
          primary: brandBlue,
          surface: const Color(0xFF1E293B),
          onSurface: const Color(0xFFF1F5F9),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Color(0xFFF1F5F9),
          centerTitle: true,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
          elevation: 0,
        ),
      ),

      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
