import 'package:flutter/material.dart';

class AppTheme {
  // Street Tycoon themed colors - Gold and Black like money/luxury
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFD700), // Gold primary
    brightness: Brightness.dark,
    primary: const Color(0xFFFFD700), // Gold
    secondary: const Color(0xFFFF8C00), // Orange-gold
    surface: const Color(0xFF1a1a1a), // Dark surface
    background: const Color(0xFF000000), // Black background
  );

  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFD700), // Gold primary
    brightness: Brightness.light,
    primary: const Color(0xFFFFD700), // Gold
    secondary: const Color(0xFFFF8C00), // Orange-gold
  );

  // Static color properties for easy access
  static const Color primaryColor = Color(0xFFFFD700); // Gold
  static const Color secondaryColor = Color(0xFFFF8C00); // Orange-gold
  static const Color accentColor = Color(0xFF00FFFF); // Cyan accent
  static const Color backgroundColor = Color(0xFF000000); // Black
  static const Color cardColor = Color(0xFF1a1a1a); // Dark surface
  static const Color textColor = Color(0xFFFFFFFF); // White text

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFFCCCCCC),
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Utility method to replace deprecated withOpacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Android-optimized colors for better visibility
  static Color get androidGreen => const Color(0xFF4CAF50);
  static Color get androidRed => const Color(0xFFF44336);
  static Color get androidBlue => const Color(0xFF2196F3);
  static Color get androidOrange => const Color(0xFFFF9800);
  static Color get androidPurple => const Color(0xFF9C27B0);

  // Performance optimized gradients for Android
  static const LinearGradient androidBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
    colors: [Color(0xFF000000), Color(0xFF1a1a1a)],
  );

  static const LinearGradient androidCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
  );
}
