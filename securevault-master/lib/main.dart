import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/constants.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'services/auth_service.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/profile_view.dart';
import 'views/home_account_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: _firebaseOptionsForCurrentPlatform,
      );
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase init error: $e');
      rethrow;
    }
  }

  // Initialize Google Sign-In
  final authService = AuthService();
  await authService.initializeGoogleSignIn(
    clientId: AppConstants.googleSignInClientId,
    // serverClientId: 'YOUR_SERVER_CLIENT_ID', // Optional: for backend server
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: const SecureVaultApp(),
    ),
  );
}

FirebaseOptions get _firebaseOptionsForCurrentPlatform {
  if (Platform.isAndroid) {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCiNN5EpRsGgtk0QJL_lIa8edtB9-fDU6A',
      appId: '1:622588675031:android:f685af4808a16cf9eec192',
      messagingSenderId: '622588675031',
      projectId: 'vault-7d555',
      storageBucket: 'vault-7d555.firebasestorage.app',
    );
  }

  if (Platform.isIOS) {
    return const FirebaseOptions(
      apiKey: 'YOUR_IOS_API_KEY',
      appId: 'YOUR_IOS_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'your-firebase-project-id',
      storageBucket: 'your-firebase-project-id.appspot.com',
    );
  }

  throw UnsupportedError(
    'FirebaseOptions are not configured for this platform.',
  );
}

class SecureVaultApp extends StatelessWidget {
  const SecureVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const AuthGate(),
      routes: {
        AppConstants.routeLogin: (_) => const LoginView(),
        AppConstants.routeRegister: (_) => const RegisterView(),
        AppConstants.routeProfile: (_) => const ProfileView(),
        AppConstants.routeHome: (_) => const HomeScreen(),
      },
    );
  }
}

/// Route gate that directs users based on authentication state
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        // Show loading while checking auth status
        if (authViewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Not logged in
        if (!authViewModel.isAuthenticated) {
          return const LoginView();
        }

        // User is authenticated
        return const HomeScreen();
      },
    );
  }
}

/// Home Screen - Main dashboard after login
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeAccountList(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.currentUser == null) {
          return const LoginView();
        }

        return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
