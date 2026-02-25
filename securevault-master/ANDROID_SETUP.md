## Android Configuration Guide for SecureVault

### 1. Update Android Build Configuration

Edit `android/build.gradle`:

```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // Add Firebase SDK
        classpath 'com.google.gms:google-services:4.3.14'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### 2. Update app/build.gradle

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"  // Add this line
}

android {
    compileSdkVersion 33

    compileOptions {
        // JDK 17 is required for our build environment
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = '17'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.securevault"
        minSdkVersion 21  // Minimum API level
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}

dependencies {
    // Firebase
    implementation 'com.google.firebase:firebase-core:21.1.1'
    implementation 'com.google.firebase:firebase-auth:21.1.0'
    
    // Google Sign-In
    implementation 'com.google.android.gms:play-services-auth:20.5.0'
    
    // Biometric
    implementation 'androidx.biometric:biometric:1.1.0'
}
```

### 3. Update AndroidManifest.xml

`android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <uses-permission android:name="android.permission.USE_FINGERPRINT" />
    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:label="SecureVault"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### 4. Add Firebase Configuration

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`

### 5. Configure Google Sign-In

For Google Sign-In to work:

1. Get your app's SHA-1 fingerprint:
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
        -alias androiddebugkey -storepass android -keypass android
```

2. Add SHA-1 to Firebase Console:
   - Firebase Console → Your Project → Settings → General
   - Scroll to "Your apps" → Android app
   - Paste SHA-1 fingerprint

3. For release builds:
   - Generate release keystore if you don't have one
   - Get release keystore SHA-1 fingerprint
   - Add to Firebase Console as well

### 6. Update settings.gradle

`android/settings.gradle`:

```gradle
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "7.3.0" apply false
    id "com.android.library" version "7.3.0" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
}

include ":app"
```

### 7. ProGuard Configuration

Create or update `android/app/proguard-rules.pro`:

```proguard
# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Google Sign-In
-keep class com.google.android.gms.auth.GoogleAuthUtil { *; }

# Biometric
-keep class androidx.biometric.** { *; }
```

### 8. Test Biometric on Emulator

For Android Emulator biometric testing:

1. Open Android Studio
2. Device Manager → Select your AVD → Edit
3. Advanced Settings → Enable: Fingerprint

### Testing Release Build

```bash
# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle --release

# Install to device
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Troubleshooting

**Issue**: Google Sign-In returns `DEVELOPER_ERROR`
- Check SHA-1 fingerprint matches Firebase Console
- Verify google-services.json is in correct location
- Clear app cache: `adb shell pm clear com.example.securevault`

**Issue**: Biometric not working on emulator
- Enable biometric in AVD settings
- Enroll fingerprint via Settings → Security → Fingerprint

**Issue**: Firebase not initializing
- Ensure google-services.json is valid JSON
- Check Firebase project ID matches your app
- Verify Firebase has Authentication service enabled
