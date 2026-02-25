import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

/// Secure Storage Service - Handles secure token and sensitive data storage
/// Uses flutter_secure_storage for encrypted storage (Keychain on iOS, Keystore on Android)
class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Save authentication token securely
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.storageKeyAuthToken,
        value: token,
      );
    } catch (e) {
      print('Error saving auth token: $e');
      rethrow;
    }
  }

  /// Retrieve stored authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(
        key: AppConstants.storageKeyAuthToken,
      );
    } catch (e) {
      print('Error retrieving auth token: $e');
      return null;
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.storageKeyRefreshToken,
        value: token,
      );
    } catch (e) {
      print('Error saving refresh token: $e');
      rethrow;
    }
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(
        key: AppConstants.storageKeyRefreshToken,
      );
    } catch (e) {
      print('Error retrieving refresh token: $e');
      return null;
    }
  }

  /// Save user data (JSON string)
  Future<void> saveUserData(String userDataJson) async {
    try {
      await _secureStorage.write(
        key: AppConstants.storageKeyUserData,
        value: userDataJson,
      );
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Retrieve saved user data
  Future<String?> getUserData() async {
    try {
      return await _secureStorage.read(
        key: AppConstants.storageKeyUserData,
      );
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  /// Save biometric enabled flag
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(
        key: AppConstants.storageKeyBiometricEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      print('Error saving biometric enabled flag: $e');
      rethrow;
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(
        key: AppConstants.storageKeyBiometricEnabled,
      );
      return value == 'true';
    } catch (e) {
      print('Error retrieving biometric enabled flag: $e');
      return false;
    }
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      print('Error clearing storage: $e');
      rethrow;
    }
  }

  /// Delete specific key
  Future<void> deleteKey(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      print('Error deleting key: $e');
      rethrow;
    }
  }
}
