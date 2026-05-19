import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EventAllInOneApp());
}

class EventAllInOneApp extends StatelessWidget {
  const EventAllInOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // 👈 Start directly from Splash Screen
    );
  }
}
