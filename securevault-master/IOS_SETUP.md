## iOS Configuration Guide for SecureVault

### 1. Update iOS Build Configuration

Edit `ios/Podfile`:

```ruby
platform :ios, '12.0'

# Post install script to fix issues
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
        'PERMISSION_LOCAL_AUTH=1',
      ]
    end
  end
end
```

Then run:
```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

### 2. Update Info.plist

Edit `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Your existing keys -->
    
    <!-- Biometric Permission -->
    <key>NSFaceIDUsageDescription</key>
    <string>We need access to Face ID to securely authenticate you.</string>
    
    <!-- Keychain Sharing (optional, for better security) -->
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>biometric</string>
    </array>
    
    <!-- Firebase/Google Sign-In Configuration -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID</string>
            </array>
        </dict>
    </array>
    
    <!-- Google Client ID (from GoogleService-Info.plist) -->
    <key>GOOGLE_APP_ID</key>
    <string>YOUR_GOOGLE_APP_ID</string>
    <key>GCM_SENDER_ID</key>
    <string>YOUR_GCM_SENDER_ID</string>
</dict>
</plist>
```

### 3. Add Firebase Configuration

1. Download `GoogleService-Info.plist` from Firebase Console
2. Open Xcode: `open ios/Runner.xcworkspace`
3. Drag `GoogleService-Info.plist` into Xcode
4. Ensure it's added to all targets (especially Runner)

### 4. Configure Google Sign-In

1. Download credentials from Google Cloud Console
2. Extract `REVERSED_CLIENT_ID` from OAuth JSON
3. Update `Info.plist` CFBundleURLSchemes with your `REVERSED_CLIENT_ID`

Example: If `com.google.gms.CLIENT_ID` is `12345-abcdef.apps.googleusercontent.com`:
- REVERSED_CLIENT_ID: `com.googleusercontent.apps.12345-abcdef`

### 5. Update Runner Build Settings

In Xcode:

1. Select Runner in Project Navigator
2. Select Runner target
3. Build Phases → Link Binary With Libraries:
   - Add `LocalAuthentication.framework`
   - Add `Security.framework`

4. Build Settings:
   - Search "Minimum Deployments Target"
   - Set to 12.0 or higher

### 6. CocoaPods Configuration

Create/update `ios/Podfile`:

```ruby
# Version control your Podfile.lock
platform :ios, '12.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join(
    '..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\s*=\s*(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # Firebase pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  
  # Google Sign-In
  pod 'GoogleSignIn'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCAL_AUTH=1',
      ]
    end
  end
end
```

### 7. Testing Biometric on Simulator

For iOS Simulator biometric testing:

1. Open iOS Simulator
2. Features → Face ID → Enrolled
   - Or Features → Touch ID → Enrolled

3. In your app, when prompted for biometric:
   - Simulator → Biometric → Matching Face/Touch
   - Or Simulator → Biometric → Non-matching Face/Touch (to test failure)

### 8. Testing Release Build

```bash
# Build iOS app for testing
flutter build ios

# Build for App Store
flutter build ios --release

# Create IPA file
pushd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build -archivePath build/Runner.xcarchive \
  archive
xcodebuild -exportArchive -archivePath build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/ipa
popd
```

### 9. Keychain Configuration

For production security, add Keychain Sharing:

1. Xcode → Runner → Signing & Capabilities
2. Click "+ Capability"
3. Add "Keychain Sharing"
4. Ensure it's enabled for your app bundle ID

### 10. Troubleshooting

**Issue**: Pod install fails
```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod repo update
pod install --repo-update
cd ..
```

**Issue**: Firebase not initializing
1. Verify GoogleService-Info.plist is added to all targets
2. Check Info.plist has correct Google Client ID
3. Run: `flutter clean && flutter pub get && flutter run`

**Issue**: Google Sign-In returns error
1. Verify REVERSED_CLIENT_ID is correct in Info.plist
2. Check bundle ID matches Firebase Console
3. Clear simulators keychains: Simulator menu → Device → Erase All Content and Settings

**Issue**: Biometric not working on device
1. Ensure device has biometric capability
2. User must have enrolled biometric
3. App needs NSFaceIDUsageDescription in Info.plist

### File Structure

```
ios/
├── Runner/
│   ├── GeneratedPluginRegistrant.m/h (auto-generated)
│   ├── GoogleService-Info.plist (add from Firebase)
│   ├── Info.plist (update with permissions)
│   └── Runner.xcodeproj/
├── Podfile (update with pods)
├── Podfile.lock (version control)
└── Pods/ (generated, not version controlled)
```

### Security Best Practices

1. **Never** commit `GoogleService-Info.plist` with real credentials to version control
2. **Never** hardcode API keys or client IDs
3. Use environment-specific configurations
4. Review security settings in Xcode before release
5. Keep Xcode and CocoaPods updated

### Device Testing Checklist

- [ ] Biometric authentication works on physical device
- [ ] Google Sign-In works
- [ ] Secure storage encrypts data
- [ ] App doesn't crash when permissions denied
- [ ] Back button handling works correctly
- [ ] Text input is secure (password masked}
- [ ] No sensitive data in console logs
