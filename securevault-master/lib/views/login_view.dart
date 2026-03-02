import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import 'widgets/custom_widgets.dart';

/// Login View - Screen for user authentication
/// Supports email/password login, Google Sign-In, and biometric login
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // if biometric is enabled and available, attempt authentication immediately
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authViewModel = context.read<AuthViewModel>();
      final enabled = await authViewModel.isBiometricEnabled();
      if (enabled) {
        final success = await authViewModel.biometricLogin();
        if (success && mounted) {
          Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.backgroundColor,
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      CustomTextField(
                        label: AppConstants.labelEmail,
                        hint: 'Enter your email',
                        controller: _emailController,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        label: AppConstants.labelPassword,
                        hint: 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      if (authViewModel.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppConstants.errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppConstants.errorColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppConstants.errorColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authViewModel.errorMessage!,
                                  style: const TextStyle(
                                    color: AppConstants.errorColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      CustomButton(
                        label: AppConstants.labelLogin,
                        isLoading: authViewModel.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final success = await authViewModel.login(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            if (success && mounted) {
                              Navigator.of(context).pushReplacementNamed(
                                AppConstants.routeHome,
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      // biometric login button
                      if (!authViewModel.isLoading &&
                          authViewModel.isAuthenticated == false)
                        FutureBuilder<bool>(
                          future: authViewModel.isBiometricEnabled(),
                          builder: (context, snapshot) {
                            final enabled = snapshot.data == true;
                            if (enabled) {
                              return IconButton(
                                icon: const Icon(Icons.fingerprint),
                                color: AppConstants.primaryColor,
                                tooltip: 'Use fingerprint login',
                                onPressed: () async {
                                  final success =
                                      await authViewModel.biometricLogin();
                                  if (success && mounted) {
                                    Navigator.of(context).pushReplacementNamed(
                                      AppConstants.routeHome,
                                    );
                                  }
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppConstants.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Google Sign-In Button
                CustomButton(
                  label: AppConstants.labelSignInWithGoogle,
                  backgroundColor: Colors.white,
                  textColor: AppConstants.textPrimary,
                  icon: Icons.g_mobiledata,
                  isLoading: authViewModel.isLoading,
                  onPressed: () async {
                    final success = await authViewModel.signInWithGoogle();

                    if (success && mounted) {
                      Navigator.of(context).pushReplacementNamed(
                        AppConstants.routeHome,
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Sign Up Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppConstants.routeRegister,
                      );
                      authViewModel.clearError();
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
