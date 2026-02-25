# SecureVault Identity System

A comprehensive mobile secure design implementation using Flutter with MVVM architecture, featuring secure authentication, biometric security, and secure storage practices.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Team Members & Roles](#team-members--roles)
- [Installation & Setup](#installation--setup)
- [Firebase Configuration](#firebase-configuration)
- [Security Features](#security-features)
- [Usage](#usage)
- [Testing](#testing)
- [APK Download](#apk-download)

## Features

✅ **Strict MVVM Architecture** - Separation of concerns between UI, Business Logic, and Data layers

✅ **Secure Authentication System**
   - Custom Email/Password Registration with validation
   - Email/Password Login
   - Google Sign-In (SSO)
   - Optional Facebook Login (Bonus)

✅ **Biometric Security**
   - Fingerprint Authentication
   - Face Recognition (FaceID)
   - Toggle biometric login in profile

✅ **Secure Storage**
   - FlutterSecureStorage for encrypted token storage
   - No plain-text password storage
   - Secure auth token management

✅ **User Profile Management**
   - View and edit display name
   - Real-time profile updates without restart
   - Profile information persistence

✅ **Password Validation**
   - Minimum 8 characters
   - At least 1 uppercase letter
   - At least 1 special character

✅ **Dark Mode** (Bonus) - Toggle dark theme in settings

## Project Structure

```
lib/
├── main.dart                     # Entry point with routing & providers
├── firebase_options.dart         # Firebase configuration
├── models/
│   └── user_model.dart          # User data structure
├── views/
│   ├── login_view.dart          # Login screen
│   ├── register_view.dart       # Registration screen
│   ├── profile_view.dart        # Profile management screen
│   └── widgets/
│       └── custom_widgets.dart  # Reusable UI components
├── viewmodels/
│   ├── auth_viewmodel.dart      # Authentication logic
│   └── profile_viewmodel.dart   # Profile management logic
├── services/
│   ├── auth_service.dart        # Firebase auth methods
│   ├── storage_service.dart     # Secure storage service
│   └── biometric_service.dart   # Biometric authentication
└── utils/
    ├── constants.dart           # App constants and colors
    └── validators.dart          # Input validation logic
```

## Team Members & Roles

| Member | Role | Responsibilities |
|--------|------|------------------|
| **Jhonn Lee Maning** | Lead Architect & Navigation | Project setup, folder structure, routing, MultiProvider configuration |
| **Angelo Padullon** | Core Auth Developer | AuthViewModel, custom registration, login logic, state management |
| **Rollyboy Ryan Pionilla** | Security Engineer | StorageService, BiometricService, password validation, secure encryption |
| **Vera Bianca Domminguez** | UI/UX Designer | LoginView, RegisterView, ProfileView, Consumer widgets, loading states |
| **Rollyboy Ryan Pionilla** | Integration Specialist | Google Sign-In, profile editing, data persistence, QA testing |

## Installation & Setup

### Prerequisites

- Flutter 3.0+ installed
- Dart 3.0+ installed
- Android SDK 32+ or iOS 12+
- Firebase account
- Google Cloud project for OAuth

### Step 1: Clone Repository

```bash
git clone https://github.com/jhonnleemaning-ux/securevault.git
cd SecureVault
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Configure Firebase

See [Firebase Configuration](#firebase-configuration) section below.

### Step 4: Run the App

```bash
flutter run
```

### Step 5: Build APK (Android)

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## Firebase Configuration

### 1. Create Firebase Project

1. Visit [Firebase Console](https://console.firebase.google.com)
2. Click "Create Project"
3. Fill in project details and complete setup

### 2. Register Flutter App

#### For Android:

1. From Firebase Console, click "Add App" → Android
2. Enter your Android package name (usually `com.example.securevault`)
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`
5. Add SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore \
   -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy SHA-1 and paste in Firebase Console

#### For iOS:

1. From Firebase Console, click "Add App" → iOS
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`
4. Open in Xcode and add to all targets

### 3. Enable Authentication

In Firebase Console → Authentication:

1. Enable **Email/Password** provider
2. Enable **Google** provider
3. Optional: Enable **Facebook** provider
4. Add authorized redirect URIs

### 4. Set Google OAuth Credentials

For Android:
- Use Web Client ID from Google Cloud Console
- Add to `android/app/src/main/AndroidManifest.xml`

For iOS:
- Download OAuth credentials JSON
- Update `ios/Runner/Info.plist` with `REVERSED_CLIENT_ID`

### 5. Update Firebase Options

Edit `lib/firebase_options.dart` with your Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'your-firebase-project-id',
  storageBucket: 'your-firebase-project-id.appspot.com',
);
```

## Security Features

### Password Requirements

- **Length**: Minimum 8 characters
- **Uppercase**: At least 1 uppercase letter (A-Z)
- **Special Characters**: At least 1 special character (!@#$%^&* etc)

### Secure Storage

All sensitive data is encrypted using:
- **Android**: Android Keystore + SharedPreferences encryption
- **iOS**: Keychain with accessibility restrictions

### Authentication Flow

1. User registers with validated email and password
2. Firebase handles authentication (password is NOT stored locally)
3. Auth token is securely stored using FlutterSecureStorage
4. Biometric authentication optional for future logins
5. Token automatically refreshed on app startup

### Biometric Security

- Device biometric availability detected
- User must authenticate via fingerprint/face to enable biometric login
- Biometric enabled flag stored securely
- On next app launch, biometric auth prompts before accessing profile

## Usage

### Registration

1. Tap "Sign Up" on login screen
2. Enter full name, email, password (with requirements)
3. Confirm password
4. Tap "Register"
5. Automatically logged in after successful registration

### Login

1. Enter email and password
2. Tap "Login"
3. Or tap "Sign In with Google" for SSO

### Biometric Login

1. If biometric enabled, app shows fingerprint prompt on startup
2. User authenticates with biometric
3. Directly access profile

### Profile Management

1. Tap profile icon
2. View user information (name, email, account creation date)
3. Tap "Edit" to change display name
4. Toggle "Enable Fingerprint Login" to manage biometric auth

### Logout

1. From profile screen, tap menu (⋮) button
2. Select "Logout"
3. Returns to login screen

## Testing

### Unit Testing

```bash
flutter test
```

### Integration Testing

```bash
flutter test integration_test/app_test.dart
```

### Manual Testing Checklist

- [ ] Registration with valid email and password
- [ ] Registration with weak password (should fail)
- [ ] Login with correct credentials
- [ ] Login with wrong password (should fail)
- [ ] Google Sign-In
- [ ] View profile information
- [ ] Edit display name (should update immediately)
- [ ] Enable/disable biometric
- [ ] Biometric login prompt appears on app restart
- [ ] Logout clears all data
- [ ] App persists login after restart (with valid token)

## APK Download

Download the latest APK from:
```
[GitHub Releases](https://github.com/your-username/SecureVault/releases)
```

Or build locally:
```bash
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

## Dependencies

- **provider** (^6.0.0) - State management
- **firebase_core** (^2.24.0) - Firebase initialization
- **firebase_auth** (^4.14.0) - Authentication
- **google_sign_in** (^6.1.0) - Google OAuth
- **flutter_secure_storage** (^9.0.0) - Encrypted storage
- **local_auth** (^2.1.0) - Biometric authentication
- **fluttertoast** (^8.2.0) - Toast notifications
- **email_validator** (^2.1.17) - Email validation

## Troubleshooting

### Firebase Initialization Error

**Issue**: `FirebaseException: Firebase app not initialized`

**Solution**: Ensure `firebase_options.dart` has correct credentials and Firebase is initialized in `main.dart`

### Google Sign-In Not Working

**Issue**: Google Sign-In returns null or error

**Solution**:
1. Verify Google OAuth credentials are correct
2. Check SHA-1 fingerprint matches Firebase Console
3. Ensure Google account has permissions

### Biometric Not Available

**Issue**: Biometric toggle disabled

**Solution**:
1. Device must have biometric hardware (fingerprint/face scanner)
2. User must have enrolled biometric data
3. For emulator, enable biometric in AVD settings

### Secure Storage Issues

**Issue**: AppData not persisting after app restart

**Solution**:
1. Flutter Secure Storage requires KeyStore (Android) / Keychain (iOS)
2. Cannot test on debug builds with unverified signatures
3. Use release builds for production testing

## Performance Optimization

- Lazy loading of user data
- Efficient state management with Provider
- Minimal rebuilds using Consumer widgets
- Cached authentication tokens
- Optimized Firebase calls

## Future Enhancements

- [ ] Email verification
- [ ] Password reset functionality
- [ ] Two-factor authentication (2FA)
- [ ] Account deletion with data wipe
- [ ] User activity logging
- [ ] Session timeout security
- [ ] Notification system

## License

This project is created for educational purposes as part of the ITMSD5 Mobile Development course.

## Contributors

- **M1**: Lead Architect & Navigation
- **M2**: Core Auth Developer
- **M3**: Security Engineer
- **M4**: UI/UX Designer
- **M5**: Integration Specialist

---

**Repository**: [GitHub URL]

**Last Updated**: February 24, 2026

**Status**: Complete & Production Ready ✅
