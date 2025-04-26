import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_animations/simple_animations.dart';
import 'package:lottie/lottie.dart';
import '../view_task_screen.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showStaticLogo = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    Timer(const Duration(seconds: 2), () {
      setState(() => _showStaticLogo = true);
      _fadeController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ViewTasksScreen(onToggleTheme: widget.onToggleTheme),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoopAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.5),
        duration: const Duration(seconds: 6),
        builder: (context, value, child) {
          final color1 = Color.lerp(
              const Color(0xFF000080), const Color(0xff0000ff), value)!;
          final color2 = Color.lerp(
              const Color(0xff0000ff), const Color(0xFF000080), value)!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset('assets/animation/Animation-1745156917515.json'),
                  if (_showStaticLogo)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: Image.asset(
                          'assets/images/logo_white.png',
                          width: 425,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
