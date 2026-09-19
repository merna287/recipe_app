import 'package:flutter/material.dart';

/// Central color palette for the Recipe App design system.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF1B4332);
  static const Color primaryLight = Color(0xFF2D6A4F);
  static const Color primaryDark = Color(0xFF081C15);
  static const Color accent = Color(0xFFE76F51);
  static const Color accentSoft = Color(0xFFF4A261);
  static const Color gold = Color(0xFFE9C46A);

  // Surfaces — Light
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF5F1EB);
  static const Color border = Color(0xFFE8E2DA);
  static const Color borderLight = Color(0xFFF0EBE4);

  // Text — Light
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Semantic
  static const Color success = Color(0xFF2D6A4F);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);

  // Surfaces — Dark
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceElevated = Color(0xFF21262D);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentSoft],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [primaryDark, Color(0xFF1B4332), Color(0xFF40916C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
