import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../state/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    ref.read(authNotifierProvider.notifier).clearError();
    await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordReset(_emailController.text);
    if (!ref.read(authNotifierProvider).hasError && mounted) {
      setState(() => _sent = true);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: _sent ? _buildSuccess() : _buildForm(isLoading, errorMessage),
      ),
    );
  }

  Widget _buildForm(bool isLoading, String? errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reset\npassword',
            style: TextStyle(
              fontSize: 38, fontWeight: FontWeight.w800,
              color: AppTheme.textDark, height: 1.1, letterSpacing: -1.5,
            )),
        const SizedBox(height: 8),
        const Text(
            "Enter your email and we'll send you a reset link.",
            style: TextStyle(fontSize: 15, color: AppTheme.textMid)),
        if (errorMessage != null) ...[
          const SizedBox(height: 20),
          _errorBanner(errorMessage),
        ],
        const SizedBox(height: 36),
        const Text('Email',
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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500),
            decoration: const InputDecoration(
              hintText: 'you@example.com',
              hintStyle:
                  TextStyle(color: AppTheme.textLight, fontSize: 15),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: isLoading ? null : _send,
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
                  : const Text('Send Reset Link',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined,
              size: 36, color: AppTheme.success),
        ),
        const SizedBox(height: 24),
        const Text('Check your inbox',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                letterSpacing: -0.6)),
        const SizedBox(height: 12),
        Text(
          'We sent a reset link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15, color: AppTheme.textMid, height: 1.5),
        ),
        const SizedBox(height: 36),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity, height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('Back to Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorBanner(String message) => Container(
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