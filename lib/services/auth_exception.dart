/// Typed auth errors so the UI can show the right message
/// without leaking raw Firebase error codes to the user.
enum AuthErrorType {
  invalidEmail,
  wrongPassword,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  networkError,
  googleCancelled,
  appleCancelled,
  unknown,
}

class AuthException implements Exception {
  final AuthErrorType type;
  final String message;

  const AuthException(this.type, this.message);

  /// Map Firebase error codes → typed AuthException
  factory AuthException.fromFirebase(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthException(
          AuthErrorType.invalidEmail,
          'Please enter a valid email address.',
        );
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthException(
          AuthErrorType.wrongPassword,
          'Incorrect email or password.',
        );
      case 'user-not-found':
        return const AuthException(
          AuthErrorType.userNotFound,
          'No account found with this email.',
        );
      case 'email-already-in-use':
        return const AuthException(
          AuthErrorType.emailAlreadyInUse,
          'An account already exists with this email.',
        );
      case 'weak-password':
        return const AuthException(
          AuthErrorType.weakPassword,
          'Password must be at least 6 characters.',
        );
      case 'network-request-failed':
        return const AuthException(
          AuthErrorType.networkError,
          'Check your internet connection and try again.',
        );
      default:
        return const AuthException(
          AuthErrorType.unknown,
          'Something went wrong. Please try again.',
        );
    }
  }

  @override
  String toString() => message;
}