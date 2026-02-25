import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/biometric_service.dart';

/// Profile ViewModel - Manages user profile state and operations
/// Handles profile editing, biometric toggle, and view updates
/// Notifies UI of changes using notifyListeners()
class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final BiometricService _biometricService = BiometricService();

  // State variables
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isEditing = false;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isBiometricAvailable => _isBiometricAvailable;
  bool get isEditing => _isEditing;

  /// Initialize profile with user data
  Future<void> initializeProfile(UserModel user) async {
    _user = user;
    await _checkBiometricAvailability();
    await _loadBiometricStatus();
    notifyListeners();
  }

  /// Update display name and refresh UI
  Future<bool> updateDisplayName(String displayName) async {
    if (displayName.isEmpty) {
      _errorMessage = 'Display name cannot be empty';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _authService.updateDisplayName(displayName);
      await _authService.refreshUser();

      // Update local user model
      _user = _user?.copyWith(
        displayName: displayName,
        lastUpdated: DateTime.now(),
      );

      _successMessage = 'Profile updated successfully!';
      _isLoading = false;
      _isEditing = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Toggle biometric authentication
  Future<bool> toggleBiometric(bool enable) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (enable) {
        // Verify biometric is available
        final isAvailable = await _biometricService.isBiometricAvailable();
        if (!isAvailable) {
          throw 'Biometric authentication is not available on this device';
        }

        // Test biometric authentication
        final isAuthenticated = await _biometricService.authenticate();
        if (!isAuthenticated) {
          throw 'Biometric authentication failed';
        }

        // Save biometric enabled flag
        await _storageService.setBiometricEnabled(true);
        _isBiometricEnabled = true;
        _successMessage = 'Fingerprint login enabled successfully!';
      } else {
        // Disable biometric
        await _storageService.setBiometricEnabled(false);
        _isBiometricEnabled = false;
        _successMessage = 'Fingerprint login disabled';
      }

      // Update user model
      _user = _user?.copyWith(
        isBiometricEnabled: enable,
        lastUpdated: DateTime.now(),
      );

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

  /// Load biometric enabled status from storage
  Future<void> _loadBiometricStatus() async {
    try {
      _isBiometricEnabled = await _storageService.isBiometricEnabled();
      notifyListeners();
    } catch (e) {
      print('Error loading biometric status: $e');
    }
  }

  /// Check if device supports biometric
  Future<void> _checkBiometricAvailability() async {
    try {
      _isBiometricAvailable = await _biometricService.isBiometricAvailable();
      notifyListeners();
    } catch (e) {
      print('Error checking biometric availability: $e');
      _isBiometricAvailable = false;
    }
  }

  /// Toggle edit mode
  void toggleEditMode() {
    _isEditing = !_isEditing;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Cancel edit mode and discard changes
  void cancelEdit() {
    _isEditing = false;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Refresh user profile data
  Future<void> refreshProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.refreshUser();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to refresh profile: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear success message
  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
