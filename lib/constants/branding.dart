import 'package:flutter/material.dart';

class Branding {
  // Primary brand colors
  static const Color primaryColor = Color(0xFF0662A3); // Blue
  static const Color secondaryColor = Color(0xFF979A9F); // Grey
  static const Color accentColor = Color(0xFF0662A3); // Blue
  static const Color successColor = Color(0xFF28A745);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFDC3545);

  // Neutral colors
  static const Color backgroundColor = Color(0xFFFBFBFC); // White
  static const Color surfaceColor = Color(
    0xFFFFFFFF,
  ); // Keep true white for cards, or use FBFBFC
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF979A9F); // Grey

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0662A3),
      Color(0xFF044D82),
    ], // Blue to slightly darker blue
  );

  // Logo path
  static const String logoPath = 'assets/logo/logo.png';
  static const String logoIconPath = 'assets/logo/logo_icon.png';

  // App name
  static const String appName = 'PrecisionFlow';
  static const String appTagline = 'Lite Manufacturing';

  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
}
