import 'package:flutter/material.dart';
import '../main.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      emoji: '🎾',
      title: 'Book Courts\nInstantly',
      subtitle: 'Find and reserve padel courts near you in seconds. Real-time availability at your fingertips.',
      bg: Color(0xFF0A0A0A),
    ),
    _OnboardingData(
      emoji: '⏱',
      title: 'Choose Your\nPerfect Time',
      subtitle: 'Flexible scheduling that works around your life. Morning, evening, weekend — your call.',
      bg: Color(0xFF111111),
    ),
    _OnboardingData(
      emoji: '💳',
      title: 'Pay Securely,\nPlay Freely',
      subtitle: 'Confirm your booking with a single tap. Secure payments, instant confirmation.',
      bg: Color(0xFF0D0D0D),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _OnboardingPage(data: page);
            },
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 52),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppTheme.accent
                              : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  // CTA Button
                  GestureDetector(
                    onTap: _goToNext,
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Continue',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoginScreen(),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bg;
  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bg,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.bg,
      padding: const EdgeInsets.fromLTRB(32, 100, 32, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration area
          Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Center(
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}