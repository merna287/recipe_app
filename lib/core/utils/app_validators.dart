/// Client-side validation helpers for application and authentication forms.
abstract final class AppValidators {
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  /// Login accepts either email or username depending on the backend account.
  static String? loginIdentifier(String? value) {
    return required(value, 'email or username');
  }

  static String? email(String? value) {
    final requiredError = AppValidators.required(value, 'email');
    if (requiredError != null) return requiredError;

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? username(String? value) {
    final requiredError = AppValidators.required(value, 'username');
    if (requiredError != null) return requiredError;

    if (value!.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = AppValidators.required(value, 'password');
    if (requiredError != null) return requiredError;

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final requiredError = AppValidators.required(value, 'confirmation');
    if (requiredError != null) return 'Please confirm your password';

    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

/// Backward compatibility alias for AuthValidators
typedef AuthValidators = AppValidators;
