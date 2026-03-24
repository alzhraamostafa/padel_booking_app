import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../state/auth_provider.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0, 0.5, curve: Curves.easeOut)),
    );
    _scaleAnim = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0, 0.5, curve: Curves.easeOutBack)),
    );
    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller,
          curve: const Interval(0.3, 0.7, curve: Curves.easeOut)),
    );
    _controller.forward();

    // After animation, check auth state and route accordingly
    Future.delayed(const Duration(milliseconds: 2400), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final user = ref.read(currentUserProvider);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            user != null ? const HomeScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Opacity(
            opacity: _fadeAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text('P',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: -2,
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: Opacity(
                      opacity: (_controller.value * 2).clamp(0, 1),
                      child: const Text('PADEL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 8,
                          )),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: Opacity(
                      opacity: (_controller.value * 2).clamp(0, 1),
                      child: Text('COURT',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 6,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}