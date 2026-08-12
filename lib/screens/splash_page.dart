import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeOut,
      ),
    );

    _logoScale = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.35,
        0.75,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 2100), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F5F2),
              Color(0xFFEDE4DE),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 190,
                    height: 190,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/controlpan_logo.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    const Text(
                      'ControlPan',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gestión inteligente para tu negocio',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
