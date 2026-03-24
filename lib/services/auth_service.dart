import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'auth_exception.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ─── Stream ────────────────────────────────────────────────
  /// Emits the current [User] whenever auth state changes.
  /// Screens listen to this via Riverpod's [authStateProvider].
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  // ─── Email / Password ──────────────────────────────────────
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    }
  }

  Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Save display name immediately after registration
      await credential.user?.updateDisplayName(name.trim());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    }
  }

  // ─── Google ────────────────────────────────────────────────
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the picker
        throw const AuthException(
          AuthErrorType.googleCancelled,
          'Google sign-in was cancelled.',
        );
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        AuthErrorType.unknown,
        'Google sign-in failed. Please try again.',
      );
    }
  }

  // ─── Apple ─────────────────────────────────────────────────
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Apple only sends the name on the very first sign-in
      final fullName = appleCredential.givenName != null
          ? '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
              .trim()
          : null;
      if (fullName != null && fullName.isNotEmpty) {
        await userCredential.user?.updateDisplayName(fullName);
      }

      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthException(
          AuthErrorType.appleCancelled,
          'Apple sign-in was cancelled.',
        );
      }
      throw const AuthException(
        AuthErrorType.unknown,
        'Apple sign-in failed. Please try again.',
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    }
  }

  // ─── Sign Out ──────────────────────────────────────────────
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ─── Delete Account ────────────────────────────────────────
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e.code);
    }
  }
}