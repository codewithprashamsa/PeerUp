import 'package:flutter/material.dart';
import 'package:my_app/screens/splash_screen.dart';


void main() {
  runApp(const PeerUpApp());
}

class PeerUpApp extends StatelessWidget {
  const PeerUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PeerUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Launches the new interactive interface entry view
    );
  }
}