import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../utils/constants.dart';

/// Biometric Service - Handles fingerprint and face recognition authentication
/// Uses local_auth plugin for iOS and Android biometric APIs
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();

  factory BiometricService() {
    return _instance;
  }

  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if biometric authentication is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final isDeviceSupported = await _auth.canCheckBiometrics;
      return isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get list of available biometrics (fingerprint, face, iris)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Check if fingerprint authentication is available
  Future<bool> isFingerPrintAvailable() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.fingerprint);
    } catch (e) {
      debugPrint('Error checking fingerprint availability: $e');
      return false;
    }
  }

  /// Check if face authentication is available
  Future<bool> isFaceRecognitionAvailable() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.face);
    } catch (e) {
      debugPrint('Error checking face recognition availability: $e');
      return false;
    }
  }

  /// Authenticate user with biometric (fingerprint or face)
  Future<bool> authenticate() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw Exception(AppConstants.errorBiometricNotAvailable);
      }

      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }

  /// Stop any ongoing biometric authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      debugPrint('Error stopping biometric authentication: $e');
    }
  }

  /// Get device biometric type name (e.g., "Fingerprint", "Face ID")
  Future<String> getBiometricTypeName() async {
    try {
      final biometrics = await getAvailableBiometrics();
      if (biometrics.isEmpty) {
        return 'Not Available';
      }

      if (biometrics.contains(BiometricType.face)) {
        return 'Face ID';
      } else if (biometrics.contains(BiometricType.fingerprint)) {
        return 'Fingerprint';
      } else if (biometrics.contains(BiometricType.iris)) {
        return 'Iris';
      }
      return 'Biometric';
    } catch (e) {
      debugPrint('Error getting biometric type name: $e');
      return 'Biometric';
    }
  }
}
