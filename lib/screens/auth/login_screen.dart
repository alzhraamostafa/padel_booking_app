import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../state/auth_provider.dart';
import '../home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (_) => false,
    );
  }

  Future<void> _emailLogin() async {
    ref.read(authNotifierProvider.notifier).clearError();
    await ref.read(authNotifierProvider.notifier).signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
    if (ref.read(authNotifierProvider).hasError) return;
    if (mounted) _goHome();
  }

  Future<void> _googleLogin() async {
    ref.read(authNotifierProvider.notifier).clearError();
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (ref.read(authNotifierProvider).hasError) return;
    if (mounted) _goHome();
  }

  Future<void> _appleLogin() async {
    ref.read(authNotifierProvider.notifier).clearError();
    await ref.read(authNotifierProvider.notifier).signInWithApple();
    if (ref.read(authNotifierProvider).hasError) return;
    if (mounted) _goHome();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final errorMessage =
        ref.read(authNotifierProvider.notifier).errorMessage;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('P',
                      style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 40),
              const Text('Welcome\nback',
                  style: TextStyle(
                    fontSize: 38, fontWeight: FontWeight.w800,
                    color: AppTheme.textDark, height: 1.1, letterSpacing: -1.5,
                  )),
              const SizedBox(height: 8),
              const Text('Sign in to manage your bookings',
                  style: TextStyle(fontSize: 15, color: AppTheme.textMid)),

              // Error banner
              if (errorMessage != null) ...[
                const SizedBox(height: 20),
                _ErrorBanner(message: errorMessage),
              ],

              const SizedBox(height: 36),
              _FieldLabel('Email'),
              const SizedBox(height: 8),
              _AppTextField(
                controller: _emailController,
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _FieldLabel('Password'),
              const SizedBox(height: 8),
              _AppTextField(
                controller: _passwordController,
                hint: '••••••••',
                obscure: _obscurePassword,
                suffix: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppTheme.textLight, size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen())),
                  child: const Text('Forgot password?',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 36),
              _PrimaryButton(
                  label: 'Sign In',
                  isLoading: isLoading,
                  onTap: _emailLogin),
              const SizedBox(height: 24),
              _Divider(),
              const SizedBox(height: 24),
              _SocialButton(
                  icon: '🔍',
                  label: 'Continue with Google',
                  isLoading: isLoading,
                  onTap: _googleLogin),
              const SizedBox(height: 12),
              _SocialButton(
                  icon: '🍎',
                  label: 'Continue with Apple',
                  isLoading: isLoading,
                  onTap: _appleLogin),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style:
                          TextStyle(color: AppTheme.textMid, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen())),
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared widgets (used across auth screens) ─────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textDark,
          letterSpacing: 0.2));
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _AppTextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppTheme.textLight, fontSize: 15),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 14), child: suffix)
                : null,
            suffixIconConstraints: const BoxConstraints(),
          ),
        ),
      );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _PrimaryButton(
      {required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: AppTheme.accent))
                : Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3)),
          ),
        ),
      );
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _SocialButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: double.infinity, height: 52,
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark)),
            ],
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(child: Divider(color: AppTheme.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('or',
                style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
          ),
          const Expanded(child: Divider(color: AppTheme.border)),
        ],
      );
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.error.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded,
                size: 16, color: AppTheme.error),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}