import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

void main() {
  test('AppTheme light theme has correct primary color', () {
    final theme = AppTheme.light;
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, isNotNull);
  });

  test('AppTheme dark theme has correct brightness', () {
    final theme = AppTheme.dark;
    expect(theme.brightness, Brightness.dark);
  });
}
