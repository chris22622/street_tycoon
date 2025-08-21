import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Android phone breakpoints
  static const double mobileBreakpoint = 480;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  // Android-specific optimizations
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Android-optimized spacing
  static double getSpacing(BuildContext context, {double base = 8.0}) {
    if (isMobile(context)) return base * 0.75; // Tighter spacing on mobile
    if (isTablet(context)) return base;
    return base * 1.25; // More generous spacing on desktop
  }

  // Android-optimized font scaling
  static double getFontScale(BuildContext context) {
    if (isMobile(context)) return 0.9; // Slightly smaller fonts on mobile
    if (isTablet(context)) return 1.0;
    return 1.1; // Larger fonts on desktop
  }

  // Android-optimized button sizes
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 48.0; // Android Material minimum touch target
    if (isTablet(context)) return 52.0;
    return 56.0;
  }

  // Android-optimized grid columns
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  // Android-optimized card margins
  static EdgeInsets getCardMargin(BuildContext context) {
    final spacing = getSpacing(context);
    if (isMobile(context)) {
      return EdgeInsets.symmetric(
        horizontal: spacing,
        vertical: spacing * 0.5,
      );
    }
    return EdgeInsets.all(spacing);
  }

  // Android-optimized content padding
  static EdgeInsets getContentPadding(BuildContext context) {
    final spacing = getSpacing(context, base: 16.0);
    return EdgeInsets.all(spacing);
  }

  // Android-optimized app bar height
  static double getAppBarHeight(BuildContext context) {
    return kToolbarHeight; // Standard Android app bar height
  }

  // Android-optimized bottom sheet height
  static double getBottomSheetHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (isMobile(context)) {
      return screenHeight * 0.85; // Almost full screen on mobile
    }
    return screenHeight * 0.7; // Partial on larger screens
  }

  // Android-optimized modal size
  static Size getModalSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (isMobile(context)) {
      return Size(
        screenSize.width * 0.95,
        screenSize.height * 0.8,
      );
    }
    if (isTablet(context)) {
      return Size(
        screenSize.width * 0.8,
        screenSize.height * 0.7,
      );
    }
    return Size(
      screenSize.width * 0.6,
      screenSize.height * 0.6,
    );
  }

  // Android-optimized list tile height
  static double getListTileHeight(BuildContext context) {
    if (isMobile(context)) return 56.0; // Standard Android list item height
    return 64.0;
  }

  // Android-optimized icon size
  static double getIconSize(BuildContext context, {double base = 24.0}) {
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.1;
    return base * 1.2;
  }

  // Android safe area optimization
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  // Android orientation helpers
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Android-optimized market table columns
  static int getMarketTableColumns(BuildContext context) {
    if (isMobile(context)) {
      return isLandscape(context) ? 4 : 3; // Fewer columns in portrait
    }
    return 5; // Full columns on larger screens
  }

  // Android-optimized text scaling
  static TextStyle scaleTextStyle(BuildContext context, TextStyle style) {
    final scale = getFontScale(context);
    return style.copyWith(
      fontSize: (style.fontSize ?? 14.0) * scale,
    );
  }

  // Android performance optimization
  static bool shouldUseAnimations(BuildContext context) {
    return !MediaQuery.of(context).disableAnimations;
  }

  // Android accessibility optimization
  static bool isAccessibilityEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  // Android device type detection
  static bool isAndroid(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android;
  }

  // Android-specific optimizations
  static BoxDecoration getCardDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.0), // Android Material design
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
          blurRadius: 8.0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Android system UI overlay style
  static Color getSystemNavigationBarColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  // Android status bar optimization
  static Brightness getStatusBarBrightness(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }
}
