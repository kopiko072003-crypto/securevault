# 🚀 SecureVault - Quick Start Guide (5 Minutes)

## For Team Leads: Get Running in 5 Minutes

### ✅ Step 1: Check Prerequisites (1 min)

```bash
# Check Flutter installation
flutter --version
# Should show: Flutter X.X.X • channel stable

# Check Dart installation
dart --version
# Should show: Dart SDK version X.X.X

# Run doctor
flutter doctor
# Should show: ✓ Flutter (✓ Dart, ✓ Plugins, ✓ Android SDK, ✓ Android toolchain, ✓ Xcode, etc.)
```

If something is missing:
- **Windows**: Download from https://flutter.dev/docs/get-started/install/windows
- **macOS**: Download from https://flutter.dev/docs/get-started/install/macos
- **Linux**: Download from https://flutter.dev/docs/get-started/install/linux

---

### ✅ Step 2: Navigate to Project (1 min)

```bash
# Windows
cd "d:\SIr Vinz Laboraties\ERD DIAGRAM\ITMSD5\SecureVault"

# macOS/Linux
cd path/to/SecureVault
```

---

### ✅ Step 3: Get Dependencies (1 min)

```bash
flutter pub get
# Downloads all packages from pubspec.yaml
# Should complete with: Running "flutter pub get" in SecureVault...
```

---

### ✅ Step 4: Setup Firebase (2 min - Skip for Now)

As Member 1, you'll need to:

1. Create Firebase project: https://console.firebase.google.com
2. Add Android app to Firebase
3. Download `google-services.json`
4. Place in `android/app/google-services.json`
5. Update `lib/firebase_options.dart` with credentials

**For now**, you can test with mock data or keep placeholder values.

---

### ✅ Step 5: Run App

```bash
# For Android Emulator or connected device
flutter run

# For iOS Simulator (macOS only)
open -a Simulator
flutter run -d ios
```

**Expected Output:**
```
Flutter 3.x.x • channel stable
Launching lib/main.dart on [Device Name]...
...
I/Choreographer: Skipped X frames!
✓ Built build/app/apk/debug/app-debug.apk in 15 seconds
```

---

## 📱 What You'll See

**First Screen**: Login View
- Email input
- Password input
- Login button
- "Sign Up" link
- "Sign in with Google" button

Try:
- Email: `test@example.com`
- Password: `Test@1234`

---

## 🔧 Common Quick Fixes

### Issue: "Flutter not found"
```bash
# Add Flutter to PATH
# Windows: Add to System Environment Variables
# macOS/Linux: Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:/flutter/bin"
```

### Issue: "Doctor shows errors"
```bash
# Install missing SDKs
flutter doctor --android-licenses
# Accept all licenses

# For iOS issues (macOS)
cd ios
pod repo update
pod install
cd ..
```

### Issue: "Emulator not starting"
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch [emulator_id]

# Wait 10 seconds, then run
flutter run
```

### Issue: "Port already in use"
```bash
flutter run -d all
# Or specify a different device
```

---

## 📂 Project Structure Quick Reference

```
lib/
├── main.dart                    ← App entry point (START HERE)
├── models/user_model.dart       ← User data
├── views/                       ← Screens
│   ├── login_view.dart
│   ├── register_view.dart
│   ├── profile_view.dart
│   └── widgets/custom_widgets.dart
├── viewmodels/                  ← Business logic
│   ├── auth_viewmodel.dart
│   └── profile_viewmodel.dart
├── services/                    ← Data/API
│   ├── auth_service.dart
│   ├── storage_service.dart
│   └── biometric_service.dart
└── utils/                       ← Helpers
    ├── constants.dart
    └── validators.dart
```

---

## 🎯 Team Member Assignments

### Member 1 (You): Lead Architect
- [x] Initialize project (DONE)
- [x] Setup folder structure (DONE)
- [x] Configure routing in main.dart (DONE)
- [ ] Configure Firebase & Google OAuth
      - edit `lib/firebase_options.dart` with your project values
      - place `google-services.json` / `GoogleService-Info.plist` in respective folders
      - follow README instructions
- [ ] Initialize Git repository and push to GitHub
      - `git init`, add remote, commit, push
      - **do not** commit credential files (google-services.json etc.)

### Member 2: Core Auth Developer
- [ ] Verify `AuthViewModel` functions correctly on device/emulator
- [ ] Test registration flow (valid/invalid, weak password, confirm match)
- [ ] Test login flow (correct/incorrect credentials, error messages)
- [ ] Add comments/documentation to viewmodel methods

### Member 3: Security Engineer
- [ ] Confirm `StorageService` encrypts stored tokens/data
- [ ] Validate `BiometricService` behaviour on supported hardware
- [ ] Ensure `utils/validators.dart` catches invalid inputs

### Member 4: UI/UX Designer
- [ ] Make sure all views render correctly on various screen sizes
- [ ] Test responsiveness and orientation changes
- [ ] Verify loading spinners and error messages appear appropriately

### Member 5: Integration Specialist
- [ ] Setup Google Sign-In per README and Implementation Guide
- [ ] Test profile editing and persistence after restart
- [ ] Run end‑to‑end registration → login → profile update


---

## 💡 Development Workflow

### 1. Start Development

**Member 1** (if needed):
```bash
git checkout -b feature/firebase-setup
# Make changes
git add .
git commit -m "[M1] [SETUP]: Configure Firebase credentials"
git push origin feature/firebase-setup
# Create Pull Request
```

**Others**: Do the same with your feature branch

### 2. Keep Code Synced

```bash
# Before starting each day
git pull origin main

# Before pushing
git pull origin main  # Merge any new changes
git push origin feature/your-branch
```

### 3. Review Code

- Check pull request on GitHub
- Comment if changes needed
- Merge when reviewed and approved

---

## 🧪 Quick Testing

### Test Authentication
1. Run app
2. Tap "Sign Up"
3. Enter data:
   - Name: John Doe
   - Email: john@example.com
   - Password: Password@123 (meets requirements)
   - Confirm: Password@123
4. Tap "Register"
5. Should see profile screen

### Test Profile Edit
1. From profile screen
2. Tap "Edit"
3. Change name to "Jane Doe"
4. Tap "Save"
5. Should update immediately

### Test Validation
1. Try registration with weak password: `password`
2. Should show error: "Password must contain at least 1 special character"
3. Try invalid email: `notanemail`
4. Should show error: "Please enter a valid email address"

---

## 🔐 Firebase Setup (Do This Soon)

1. Go to: https://console.firebase.google.com
2. Click "Create Project"
3. Fill in project details
4. Wait for project creation (~2 min)
5. Click "Add an app" → Select Android
6. Download `google-services.json`
7. Copy to `android/app/google-services.json`
8. Go back, add an iOS app
9. Download `GoogleService-Info.plist`
10. Copy to `ios/Runner/GoogleService-Info.plist`
11. Update `lib/firebase_options.dart` with your project credentials
12. Run `flutter run` again

**Total time**: 10-15 minutes

---

## 🚨 When Something Goes Wrong

### App Crashes on Startup?
1. Check console for error message
2. Check Firebase credentials are set
3. Run `flutter clean && flutter pub get`
4. Try again

### Firebase Not Initializing?
1. Verify `google-services.json` is in correct location
2. Verify `firebase_options.dart` has correct data
3. Check internet connection
4. Check Firebase project is active

### Can't Build APK?
```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## 📞 Quick Reference

### Useful Flutter Commands

```bash
# See what's running
flutter devices

# Run on specific device
flutter run -d [device_id]

# Hot reload (after code change)
Press 'r' in terminal

# Full rebuild
Press 'R' in terminal (capital R)

# Stop app
Press 'q' in terminal

# See logs
flutter logs

# Build APK
flutter build apk --release

# Clean build
flutter clean
```

### Directory Shortcuts

```bash
# Windows - Open file explorer
start .

# macOS/Linux - Open finder/files
open .

# Run from project root
cd /path/to/SecureVault
```

---

## 📚 Documentation at a Glance

| Document | Use Case | Read Time |
|----------|----------|-----------|
| **README.md** | Project overview | 10 min |
| **PROJECT_STRUCTURE.md** | Understand architecture | 5 min |
| **IMPLEMENTATION_GUIDE.md** | Detailed team roles | 10 min |
| **SUBMISSION_CHECKLIST.md** | Before submission | 15 min |
| **ANDROID_SETUP.md** | Android config | 5 min |
| **IOS_SETUP.md** | iOS config | 5 min |

---

## ✅ First Day Checklist

- [ ] Clone/open project
- [ ] Run `flutter pub get`
- [ ] Run `flutter run`
- [ ] See login screen
- [ ] Test registration
- [ ] Create GitHub repository
- [ ] Each member creates feature branch
- [ ] Configure Firebase (if possible)
- [ ] Daily standup with team

---

## 🎯 First Week Timeline

**Day 1**: Setup & Firebase Configuration
- Project runs locally
- Firebase configured
- Code pushed to GitHub

**Days 2-4**: Feature Development
- Each member implements features
- Regular push to GitHub
- Code reviews and merges

**Day 5**: Testing & Bug Fixes
- Test all features
- Find and fix bugs
- Update documentation

**Day 6**: Build & Submission
- Build release APK
- Create submission PDF
- Upload to LMS

---

## 🚀 You're Ready!

All files are created and ready to use. Your team can start:

1. ✅ Reading documentation
2. ✅ Running the app locally
3. ✅ Implementing assigned features
4. ✅ Storing code in GitHub
5. ✅ Testing end-to-end
6. ✅ Submitting final project

**Total setup time**: ~15 minutes  
**Total development time**: 3-4 days  
**Total submission time**: 1 day  

---

## 🎉 Good Luck!

Your SecureVault project is ready for implementation. The architecture is complete, the code is organized, and the documentation is comprehensive.

**Start with**: README.md → Run the app → Assign tasks

**Then**: Each member works on their features → Regular GitHub commits → Integration testing → Final submission

**You've got this!** 🚀

---

*Last Updated: February 24, 2026*  
*Project Status: Ready for Team Implementation*
