import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../services/storage_service.dart';

/// Authentication ViewModel - Manages login, registration, and Google Sign-In logic
/// Handles state management for UI to consume (isLoading, errorMessage, etc.)
/// Follows MVVM pattern by separating business logic from UI
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final BiometricService _biometricService = BiometricService();
  final StorageService _storageService = StorageService();

  // State variables
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  /// Register user with email and password
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userModel = await _authService.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );

      _currentUser = userModel;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userModel = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      _currentUser = userModel;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userModel = await _authService.signInWithGoogle();

      _currentUser = userModel;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Biometric login - authenticate and check if enabled
  ///
  /// When biometric login succeeds we also attempt to restore the
  /// last user data from secure storage so that `currentUser` is
  /// populated for the UI (profile screen, etc.).
  Future<bool> biometricLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isBiometricEnabled = await _storageService.isBiometricEnabled();

      if (!isBiometricEnabled) {
        throw 'Biometric authentication is not enabled';
      }

      final isAuthenticated = await _biometricService.authenticate();

      if (!isAuthenticated) {
        throw 'Biometric authentication failed';
      }

      // restore cached user info from secure storage
      final userJson = await _storageService.getUserData();
      if (userJson != null && userJson.isNotEmpty) {
        try {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(jsonDecode(userJson));
          _currentUser = UserModel.fromJson(data);
        } catch (e) {
          // if parsing fails we still mark authenticated but leave user null
          print('Failed to parse cached user data: $e');
        }
      }

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();

      _currentUser = null;
      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Check if user is already logged in (restore session)
  /// If there is no Firebase user but biometric login is enabled we
  /// try to authenticate with biometrics automatically.
  Future<void> checkAuthStatus() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        _currentUser = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoUrl: user.photoURL,
          createdAt: user.metadata.creationTime ?? DateTime.now(),
        );
        _isAuthenticated = true;
      } else {
        // no firebase session; attempt biometric if enabled
        final enabled = await _storageService.isBiometricEnabled();
        if (enabled) {
          final success = await biometricLogin();
          if (success && _currentUser != null) {
            _isAuthenticated = true;
          } else {
            _isAuthenticated = false;
          }
        } else {
          _isAuthenticated = false;
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error checking auth status: $e');
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Helper to determine if biometric login has been enabled by user
  Future<bool> isBiometricEnabled() {
    return _storageService.isBiometricEnabled();
  }
}
