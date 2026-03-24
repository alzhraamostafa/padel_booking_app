import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../state/auth_provider.dart';
import '../home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    ref.read(authNotifierProvider.notifier).clearError();
    await ref.read(authNotifierProvider.notifier).registerWithEmail(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
    if (ref.read(authNotifierProvider).hasError) return;
    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final errorMessage =
        ref.read(authNotifierProvider.notifier).errorMessage;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create\naccount',
                style: TextStyle(
                  fontSize: 38, fontWeight: FontWeight.w800,
                  color: AppTheme.textDark, height: 1.1, letterSpacing: -1.5,
                )),
            const SizedBox(height: 8),
            const Text('Join thousands of padel players',
                style: TextStyle(fontSize: 15, color: AppTheme.textMid)),
            if (errorMessage != null) ...[
              const SizedBox(height: 20),
              _ErrorBanner(message: errorMessage),
            ],
            const SizedBox(height: 32),
            _buildField('Full Name', _nameController, 'Ahmed Hassan'),
            const SizedBox(height: 16),
            _buildField('Email', _emailController, 'you@example.com',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 12),
            Text(
              'By creating an account, you agree to our Terms of Service and Privacy Policy.',
              style: TextStyle(
                  fontSize: 12, color: AppTheme.textLight, height: 1.5),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: isLoading ? null : _register,
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
                      : const Text('Create Account',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style:
                        TextStyle(color: AppTheme.textMid, fontSize: 14)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Sign In',
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
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: TextField(
            controller: controller,
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle:
                  const TextStyle(color: AppTheme.textLight, fontSize: 15),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
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
              suffixIconConstraints: const BoxConstraints(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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