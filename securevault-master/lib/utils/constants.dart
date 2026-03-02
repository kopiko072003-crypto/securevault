import 'package:flutter/material.dart';

/// App Constants - Colors, Strings, and Configuration
class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color secondaryColor = Color(0xFF00B894);
  static const Color accentColor = Color(0xFFFF7675);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color errorColor = Color(0xFFD63031);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);

  // String Constants
  static const String appName = 'SecureVault';
  static const String appVersion = '1.0.0';

  // Firebase Configuration
  // NOTE: Replace with your Firebase project credentials
  static const String firebaseWebApiKey = 'YOUR_WEB_API_KEY';
  static const String googleSignInClientId = '622588675031-ldu5hcrqppf7qickk2qfja0c21semq9t.apps.googleusercontent.com';

  // Route Names
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeProfile = '/profile';

  // Secure Storage Keys
  static const String storageKeyAuthToken = 'auth_token';
  static const String storageKeyRefreshToken = 'refresh_token';
  static const String storageKeyUserData = 'user_data';
  static const String storageKeyBiometricEnabled = 'biometric_enabled';

  // UI Strings
  static const String labelEmail = 'Email Address';
  static const String labelPassword = 'Password';
  static const String labelConfirmPassword = 'Confirm Password';
  static const String labelFullName = 'Full Name';
  static const String labelDisplayName = 'Display Name';
  static const String labelLogin = 'Login';
  static const String labelRegister = 'Register';
  static const String labelSignUp = 'Sign Up';
  static const String labelSignOut = 'Sign Out';
  static const String labelEdit = 'Edit';
  static const String labelSave = 'Save';
  static const String labelCancel = 'Cancel';
  static const String labelForgotPassword = 'Forgot Password?';
  static const String labelCreateAccount = "Don't have an account? Sign Up";
  static const String labelAlreadyHaveAccount = 'Already have an account? Login';
  static const String labelEnableBiometric = 'Enable Fingerprint Login';
  static const String labelSignInWithGoogle = 'Sign In with Google';
  static const String labelSignInWithFacebook = 'Sign In with Facebook';
  static const String labelProfile = 'Profile';
  static const String labelSettings = 'Settings';
  static const String labelDarkMode = 'Dark Mode';

  // Error Messages
  static const String errorEmptyEmail = 'Email cannot be empty';
  static const String errorInvalidEmail = 'Please enter a valid email address';
  static const String errorEmptyPassword = 'Password cannot be empty';
  static const String errorWeakPassword = 'Password must be at least 8 characters, contain 1 uppercase letter and 1 special character';
  static const String errorPasswordMismatch = 'Passwords do not match';
  static const String errorEmptyFullName = 'Full Name cannot be empty';
  static const String errorAuthFailed = 'Authentication failed. Please try again';
  static const String errorUserExists = 'User already exists. Please login instead';
  static const String errorBiometricNotAvailable = 'Biometric authentication not available';
  static const String errorBiometricFailed = 'Biometric authentication failed';
  static const String errorUserNotFound = 'User not found';

  // Success Messages
  static const String successRegistration = 'Registration successful! Please login';
  static const String successLogin = 'Login successful!';
  static const String successProfileUpdate = 'Profile updated successfully!';
  static const String successBiometricEnabled = 'Fingerprint login enabled';
  static const String successBiometricDisabled = 'Fingerprint login disabled';

  // Password Requirements
  static const int minPasswordLength = 8;
  
  // API Endpoints (if needed)
  static const String baseApiUrl = 'https://your-api.com';
}
