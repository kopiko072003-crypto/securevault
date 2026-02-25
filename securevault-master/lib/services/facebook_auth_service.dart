// Bonus Feature: Facebook Login Service
// This is an optional feature for +5 bonus points
// Implement only if time permits

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

/// Facebook Sign-In Service (BONUS FEATURE)
/// Handles Facebook OAuth authentication using Firebase
/// +5 Bonus Points
class FacebookAuthService {
  static final FacebookAuthService _instance = FacebookAuthService._internal();

  factory FacebookAuthService() {
    return _instance;
  }

  FacebookAuthService._internal();

  // ignore: unused_field
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // ignore: unused_field
  final StorageService _storageService = StorageService();

  /// Sign in with Facebook
  /// Returns UserModel on success, throws exception on failure
  ///
  /// Requirements:
  /// 1. Add facebook_sdk_flutter package to pubspec.yaml:
  ///    facebook_sdk_flutter: ^3.0.0
  /// 2. Configure Facebook App at https://developers.facebook.com
  /// 3. Add Facebook App ID to AndroidManifest.xml and Info.plist
  /// 4. Enable Facebook Sign-In in Firebase Console
  Future<UserModel> signInWithFacebook() async {
    try {
      // NOTE: facebook_sdk_flutter package required
      // Uncomment below when implementing

      /*
      import 'package:facebook_sdk_flutter/facebook_sdk_flutter.dart';

      final facebookLoginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (facebookLoginResult.status == LoginStatus.success) {
        final accessToken = facebookLoginResult.accessToken!.toTokenMap();
        final facebookAuthCredential = FacebookAuthProvider.credential(
          accessToken['access_token'] ?? '',
        );

        final userCredential = await _firebaseAuth.signInWithCredential(
          facebookAuthCredential,
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
      } else if (facebookLoginResult.status == LoginStatus.cancel) {
        throw 'Facebook login cancelled by user';
      } else {
        throw 'Facebook login failed: ${facebookLoginResult.message}';
      }
      */

      throw 'Facebook authentication not yet implemented';
    } catch (e) {
      throw 'Facebook Sign-In failed: ${e.toString()}';
    }
  }

  /// Logout from Facebook
  Future<void> facebookLogout() async {
    try {
      // NOTE: facebook_sdk_flutter package required
      // Uncomment below when implementing
      /*
      import 'package:facebook_sdk_flutter/facebook_sdk_flutter.dart';
      await FacebookAuth.instance.logOut();
      */
    } catch (e) {
      print('Error logging out from Facebook: $e');
    }
  }

  /// Check if user is logged in with Facebook
  Future<bool> isUserLoggedIn() async {
    try {
      // NOTE: facebook_sdk_flutter package required
      /*
      import 'package:facebook_sdk_flutter/facebook_sdk_flutter.dart';
      final accessToken = await FacebookAuth.instance.accessToken;
      return accessToken != null;
      */
      return false;
    } catch (e) {
      print('Error checking Facebook login status: $e');
      return false;
    }
  }
}

/// Facebook Login Button Component (BONUS)
/// Add to custom_widgets.dart
/*
class FacebookLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const FacebookLoginButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Sign In with Facebook',
      backgroundColor: const Color(0xFF1877F2), // Facebook blue
      icon: Icons.facebook,
      isLoading: isLoading,
      onPressed: onPressed,
    );
  }
}
*/

/// Implementation Steps for Facebook Login (BONUS):
/// 
/// 1. Add dependency to pubspec.yaml:
///    facebook_sdk_flutter: ^3.0.0
/// 
/// 2. Create Facebook App: https://developers.facebook.com/apps
///    - Get App ID and App Secret
///    - Set App Domains: oauth redirect domain
///    - Add Products: Facebook Login
/// 
/// 3. Android Configuration (android/app/build.gradle):
///    - Add Facebook SDK
///    - AndroidManifest.xml: Add Facebook App ID and permissions
/// 
/// 4. iOS Configuration (ios/Runner/Info.plist):
///    - Add Facebook App ID
///    - Add URL schemes for FB auth callback
/// 
/// 5. Firebase Configuration:
///    - Firebase Console → Authentication → Facebook provider
///    - Add Facebook App ID and App Secret
///    - Set OAuth redirect URI
/// 
/// 6. In Login View:
///    - Add FacebookLoginButton next to Google Sign-In button
///    - Call facebookService.signInWithFacebook() on tap
///    - Same error handling as Google Sign-In
/// 
/// 7. Testing:
///    - Create Facebook test account at Roles → Test Users
///    - Use test account to sign in
///    - Verify user profile is fetched and stored
/// 
/// 8. Submission:
///    - Include Facebook login button in LoginView
///    - Document Facebook app creation process
///    - Add +5 bonus points to total score
/// 
/// Expected behavior same as Google Sign-In:
/// 1. User taps Facebook Login button
/// 2. Facebook OAuth dialog appears
/// 3. User enters Facebook credentials
/// 4. App receives access token
/// 5. Firebase authenticates user
/// 6. User profile created/updated
/// 7. Redirect to Home screen
