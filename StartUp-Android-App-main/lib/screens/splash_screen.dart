import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textScale;
  late Animation<double> _fadeAnimation;
  final List<_FloatingDot> _dots = [];

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _textScale = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    for (int i = 0; i < 15; i++) {
      _dots.add(
        _FloatingDot(
          x: math.Random().nextDouble(),
          y: math.Random().nextDouble(),
          size: 15 + math.Random().nextDouble() * 20,
          speed: 0.3 + math.Random().nextDouble() * 0.5,
        ),
      );
    }

    // 🚀 Navigate based on login status
    Timer(const Duration(seconds: 4), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final String userEmail = prefs.getString('email') ??
          ''; // Default empty if not found

      if (isLoggedIn && userEmail.isNotEmpty) {
        // ⭐ FIX: Added required userEmail
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userEmail: userEmail),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFFDF6E3);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return CustomPaint(
                painter: _DotsPainter(_dots, _textController.value),
                size: MediaQuery.of(context).size,
              );
            },
          ),
          Center(
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _textScale.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      "EventAllinOne",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                        color: Colors.orange.shade700,
                        shadows: [
                          Shadow(
                            color: Colors.orange.withOpacity(0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _FloatingDot {
  final double x, y, size, speed;
  _FloatingDot({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class _DotsPainter extends CustomPainter {
  final List<_FloatingDot> dots;
  final double progress;

  _DotsPainter(this.dots, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.orangeAccent.withOpacity(0.15);

    for (final dot in dots) {
      final dy = (dot.y * size.height +
              math.sin(progress * dot.speed * 2 * math.pi) * 15) %
          size.height;
      final dx = (dot.x * size.width +
              math.cos(progress * dot.speed * 2 * math.pi) * 15) %
          size.width;

      canvas.drawCircle(Offset(dx, dy), dot.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
