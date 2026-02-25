import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show Platform;

/// Firebase configuration for both Android and iOS
/// IMPORTANT: Replace these values with your Firebase project credentials
/// Visit: https://firebase.google.com/docs/flutter/setup
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBRiMBquvcS7kty793U2PAdhI6iUtgtZs',
    appId: '1:112921432075:android:e479947942928429a2f70e',
    messagingSenderId: '112921432075',
    projectId: 'vault-adc6e',
    storageBucket: 'vault-adc6e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'your-firebase-project-id',
    storageBucket: 'your-firebase-project-id.appspot.com',
  );
}

/// Firebase Setup Instructions:
///
/// 1. Go to Firebase Console: https://console.firebase.google.com
/// 2. Create a new project or select existing one
/// 3. Add Flutter app to your project:
///    - For Android: Download google-services.json and place in android/app/
///    - For iOS: Download GoogleService-Info.plist and place in ios/Runner/
/// 4. Get your Firebase credentials from Project Settings
/// 5. Replace the placeholder values above with your credentials
///
/// 6. Enable Authentication methods in Firebase Console:
///    - Enable Email/Password authentication
///    - Enable Google Sign-In (requires Google OAuth credentials)
///    - Optional: Enable Facebook Sign-In
///
/// 7. For Google Sign-In on Android:
///    - Add your SHA-1 fingerprint to Firebase Console
///    - Run: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
///
/// 8. For Google Sign-In on iOS:
///    - Add your iOS app to Google Cloud Console
///    - Configure OAuth consent screen
///    - Update ios/Runner/Info.plist with Google Client ID
