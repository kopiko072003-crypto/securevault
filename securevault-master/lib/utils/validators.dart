/// Validators - Regex and validation logic for form inputs
class Validators {
  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple email validation regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate password strength
  /// Requirements: Min 8 chars, 1 Uppercase letter, 1 Special character
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    // Check for special characters - using non-raw string to handle escapes properly
    if (!_hasSpecialChars(password)) {
      return 'Password must contain at least 1 special character (!@#\$%^&* etc)';
    }
    return null;
  }

  /// Check if password has special characters
  static bool _hasSpecialChars(String password) {
    // Check for any of these special characters
    const specialChars = '!@#\$%^&*()_+-=[]{};\\"\'<>?,./\\|`~';
    for (var char in password.split('')) {
      if (specialChars.contains(char)) {
        return true;
      }
    }
    return false;
  }

  /// Validate password confirmation
  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate full name
  static String? validateFullName(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return 'Full Name cannot be empty';
    }
    if (fullName.length < 2) {
      return 'Full Name must be at least 2 characters';
    }
    // Allow letters, spaces, hyphens, and apostrophes only
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(fullName)) {
      return 'Full Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// Validate display name
  static String? validateDisplayName(String? displayName) {
    final trimmed = displayName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Display Name cannot be empty';
    }
    return null;
  }

  /// Check if email format is valid
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Check if password is strong
  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        _hasSpecialChars(password);
  }
}
