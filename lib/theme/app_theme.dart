import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Canvas & Background
  static const Color surface = Color(0xFFE9FEF3);
  static const Color canvasBody = Color(0xFFF4FBF7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFE3F9ED);
  static const Color surfaceContainer = Color(0xFFDEF3E8);
  static const Color surfaceContainerHigh = Color(0xFFD8EDE2);
  static const Color surfaceContainerHighest = Color(0xFFD2E7DD);

  // Brand Primaries & Deep Accents
  static const Color primary = Color(0xFF003B1B);
  static const Color primaryContainer = Color(0xFF14532D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF87C695);
  static const Color primaryFixed = Color(0xFFB1F2BE);
  static const Color onPrimaryFixedVariant = Color(0xFF12512C);

  // Secondaries
  static const Color secondary = Color(0xFF376757);
  static const Color secondaryContainer = Color(0xFFBAEED9);
  static const Color onSecondaryContainer = Color(0xFF3D6D5D);
  static const Color onSecondaryFixed = Color(0xFF002117);

  // Text Hierarchies
  static const Color onSurface = Color(0xFF0D1F18);
  static const Color onSurfaceVariant = Color(0xFF404941);
  static const Color textMuted = Color(0xFF4A6B5D);
  static const Color textLight = Color(0xFF7D9B8E);
  static const Color outline = Color(0xFF717970);
  static const Color outlineVariant = Color(0xFFC0C9BE);

  // Functional & Semantic Pastels
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Category Semantic Pastels
  static const Color sageBg = Color(0xFFE8F5E9);
  static const Color sageIcon = Color(0xFF1B4D3E);

  static const Color amberBg = Color(0xFFFEF3C7);
  static const Color amberIcon = Color(0xFFD97706);

  static const Color roseBg = Color(0xFFFEE2E2);
  static const Color roseIcon = Color(0xFFE11D48);

  static const Color lavenderBg = Color(0xFFF3E8FF);
  static const Color lavenderIcon = Color(0xFF7C3AED);

  static const Color skyBg = Color(0xFFE0F2FE);
  static const Color skyIcon = Color(0xFF0284C7);

  static const Color peachBg = Color(0xFFFFEDE5);
  static const Color peachIcon = Color(0xFFC2410C);

  // Ambient botanical shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF14532D).withValues(alpha: 0.04),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF14532D).withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: const Color(0xFF14532D).withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, -6),
        ),
      ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvasBody,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: AppColors.onSurface,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: AppColors.primary,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
    );
  }
}
