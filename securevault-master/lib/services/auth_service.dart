import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Authorization Service - Handles Firebase Authentication and Google Sign-In
/// Manages user registration, login, SSO, and credential validation
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final StorageService _storageService = StorageService();

  /// Initialize Google Sign-In if needed.
  ///
  /// On Android and iOS the GoogleSignIn plugin will read configuration
  /// from the `google-services.json` or `GoogleService-Info.plist` files,
  /// so this method is only required when running on web or when custom
  /// client IDs are needed.
  Future<void> initializeGoogleSignIn({
    required String clientId,
    String? serverClientId,
  }) async {
    try {
      // On mobile this is a no-op but we preserve the API for tests
      await _googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );
    } catch (e) {
      // just log but don't fail application startup
      print('Google Sign-In initialization warning: $e');
    }
  }

  /// Get current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Get current user as stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Register user with email and password
  /// Returns UserModel on success, throws exception on failure
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(fullName);
      await userCredential.user?.reload();

      final user = userCredential.user!;

      // Save auth token securely
      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }

      // Create UserModel from Firebase user
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? fullName,
        createdAt: DateTime.now(),
      );

      // Save user data
      await _storageService.saveUserData(userModel.toJson().toString());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Registration failed: ${e.toString()}';
    }
  }

  /// Login user with email and password
  /// Returns UserModel on success, throws exception on failure
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Save auth token securely
      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }

      // Create UserModel from Firebase user
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      // Save user data
      await _storageService.saveUserData(userModel.toJson().toString());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Login failed: ${e.toString()}';
    }
  }

  /// Sign in with Google using Firebase auth
  /// Returns UserModel on success, throws exception on failure
  Future<UserModel> signInWithGoogle() async {
    try {
      // attempt to sign in with Google account using the new API
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();
      if (googleUser == null) {
        // user aborted sign in or authentication failed
        throw 'Google sign-in cancelled by user';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw 'Missing Google ID token';
      }

      // create credential using only ID token (access token is no longer
      // provided by the latest plugin version)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Save auth token securely
      final token = await user.getIdToken();
      if (token != null) {
        await _storageService.saveAuthToken(token);
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        photoUrl: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      await _storageService.saveUserData(userModel.toJson().toString());
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      // propagate other errors as strings
      throw 'Google Sign-In failed: ${e.toString()}';
    }
  }

  /// Logout user and clear stored credentials
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await _storageService.clearAll();
    } catch (e) {
      throw 'Logout failed: ${e.toString()}';
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw 'User not logged in';
      }

      await user.updateDisplayName(displayName);
      await user.reload();
    } catch (e) {
      throw 'Failed to update display name: ${e.toString()}';
    }
  }

  /// Delete user account and all data
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw 'User not logged in';
      }

      await user.delete();
      await _storageService.clearAll();
    } catch (e) {
      throw 'Failed to delete account: ${e.toString()}';
    }
  }

  /// Get current user ID token
  Future<String?> getIdToken() async {
    try {
      return await currentUser?.getIdToken();
    } catch (e) {
      print('Error getting ID token: $e');
      return null;
    }
  }

  /// Refresh user authentication state
  Future<void> refreshUser() async {
    try {
      await currentUser?.reload();
    } catch (e) {
      print('Error refreshing user: $e');
    }
  }

  /// Handle Firebase auth exceptions and return user-friendly error messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'invalid-credential':
        return 'The credentials provided are invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different authentication method.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
