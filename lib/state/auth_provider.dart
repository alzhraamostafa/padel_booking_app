import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/auth_exception.dart';

// ─── Raw Firebase auth stream ──────────────────────────────────────────────
/// Emits [User?] whenever the auth state changes (login, logout, token refresh).
/// Use this to decide whether to show Home or Login.
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.instance.authStateChanges;
});

/// Convenience: just the current user, synchronously.
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// ─── Auth actions notifier ─────────────────────────────────────────────────
/// Holds the loading / error state for login, register, and social sign-in.
/// Screens watch [authNotifierProvider] to show spinners and error banners.
class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.signInWithEmail(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> registerWithEmail(
      String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.registerWithEmail(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.signInWithGoogle(),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.signInWithApple(),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.sendPasswordReset(email),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => AuthService.instance.signOut(),
    );
  }

  /// Extract a user-friendly message from the error state.
  String? get errorMessage {
    return state.whenOrNull(
      error: (e, _) {
        if (e is AuthException) return e.message;
        return 'Something went wrong. Please try again.';
      },
    );
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);