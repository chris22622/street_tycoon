import 'package:flutter/material.dart';

class AppTheme {
  // ── Core Colors ──
  static const Color gold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFFF8C00);
  static const Color accent = Color(0xFF00FFFF);
  static const Color bg = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);

  // ── Status Colors ──
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF42A5F5);


  // ── Legacy Aliases (used by other screens) ──
  static const Color primaryColor = gold;
  static const Color accentColor = accent;
  static const Color secondaryColor = accent;
  static const Color cardColor = surface;
  static const Color backgroundColor = bg;
  static const Color textColor = Colors.white;
  static TextStyle get headingStyle => heading;
  static TextStyle get bodyStyle => body;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: darkGold,
        tertiary: accent,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),

      // ── Navigation Bar ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        height: 64,
        indicatorColor: gold.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: gold);
          }
          return TextStyle(fontSize: 11, color: Colors.grey.shade500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: gold, size: 22);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 22);
        }),
      ),

      // ── Tab Bar ──
      tabBarTheme: TabBarTheme(
        labelColor: gold,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: gold,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
      ),

      // ── Cards ──
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        selectedColor: gold.withOpacity(0.2),
        labelStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      // ── Buttons ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // ── Text ──
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        labelSmall: TextStyle(fontSize: 11, color: Colors.white54),
      ),

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: gold),
      ),

      // ── Popup Menu ──
      popupMenuTheme: PopupMenuThemeData(
        color: surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ── Dialogs ──
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }

  // ── Utility ──
  static TextStyle get heading => const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle get body => const TextStyle(fontSize: 14, color: Colors.white70);
  static TextStyle get label => const TextStyle(fontSize: 12, color: Colors.white54);
}
import 'package:flutter/material.dart';

class AppTheme {
  // ── Core Colors ──
  static const Color gold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFFF8C00);
  static const Color accent = Color(0xFF00FFFF);
  static const Color bg = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);

  // ── Status Colors ──
  static const Color success = Color(0xFF4CAF50);
  static const Color danger = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF42A5F5);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: darkGold,
        tertiary: accent,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),

      // ── Navigation Bar ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        height: 64,
        indicatorColor: gold.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: gold);
          }
          return TextStyle(fontSize: 11, color: Colors.grey.shade500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: gold, size: 22);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 22);
        }),
      ),

      // ── Tab Bar ──
      tabBarTheme: TabBarTheme(
        labelColor: gold,
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: gold,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
      ),

      // ── Cards ──
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 4),
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        selectedColor: gold.withOpacity(0.2),
        labelStyle: const TextStyle(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      // ── Buttons ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // ── Text ──
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        labelSmall: TextStyle(fontSize: 11, color: Colors.white54),
      ),

      // ── AppBar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: gold),
      ),

      // ── Popup Menu ──
      popupMenuTheme: PopupMenuThemeData(
        color: surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ── Dialogs ──
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }

  // ── Utility ──
  static TextStyle get heading => const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle get body => const TextStyle(fontSize: 14, color: Colors.white70);
  static TextStyle get label => const TextStyle(fontSize: 12, color: Colors.white54);
}
