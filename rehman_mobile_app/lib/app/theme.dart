import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Single source for app font ---
// Change font here and it updates everywhere in the app
TextStyle Function({
  TextStyle? textStyle,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  double? height,
}) _appFont = GoogleFonts.nunitoSans;

TextTheme Function(TextTheme) _appFontTextTheme = GoogleFonts.nunitoSansTextTheme;

class AppColors {
  // Primary - Deep Navy
  static const Color primary = Color(0xFF1A1B4B);
  static const Color primaryLight = Color(0xFFEEEEFF);
  static const Color primaryDark = Color(0xFF12133A);

  // Accent - Bright Blue
  static const Color accent = Color(0xFF2D31FA);
  static const Color accentLight = Color(0xFFEDEDFF);

  // Secondary - Golden (CTAs)
  static const Color secondary = Color(0xFFF5A623);
  static const Color secondaryLight = Color(0xFFFFF3D6);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFF4F5F9);
  static const Color cardBg = Colors.white;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F3F8);

  // Text
  static const Color textPrimary = Color(0xFF1A1D26);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF1B8A2D);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A1B4B), Color(0xFF2D31FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1A1B4B), Color(0xFF1A1B4B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2D31FA), Color(0xFF5B5FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFF7C948)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFF5A623), Color(0xFFF7C948)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// --- Spacing Grid System ---

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppPadding {
  // Card paddings
  static const EdgeInsets card = EdgeInsets.all(12);
  static const EdgeInsets cardLg = EdgeInsets.all(16);

  // Horizontal paddings
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets screenHLg = EdgeInsets.symmetric(horizontal: 20);

  // Section paddings
  static const EdgeInsets section = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets sectionSm = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  // Inline paddings (badges, chips)
  static const EdgeInsets badge = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const EdgeInsets chip = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
}

class AppGap {
  static const SizedBox xs = SizedBox(height: 4);
  static const SizedBox sm = SizedBox(height: 8);
  static const SizedBox md = SizedBox(height: 14);
  static const SizedBox lg = SizedBox(height: 20);
  static const SizedBox xl = SizedBox(height: 32);

  static const SizedBox hXs = SizedBox(width: 4);
  static const SizedBox hSm = SizedBox(width: 8);
  static const SizedBox hMd = SizedBox(width: 12);
  static const SizedBox hLg = SizedBox(width: 16);
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 100;
}

// --- Font Size System ---

class AppFontSize {
  static const double xs = 9;
  static const double sm = 10;
  static const double md = 11;
  static const double base = 12;
  static const double lg = 14;
  static const double xl = 15;
  static const double xxl = 18;
  static const double h3 = 20;
  static const double h2 = 24;
  static const double h1 = 28;
}

// --- Icon Size System ---

class AppIconSize {
  static const double xs = 12;
  static const double sm = 14;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

// --- Pre-built Text Styles ---

class AppTextStyles {
  // Headings
  static TextStyle h1 = _appFont(
    fontSize: AppFontSize.h1, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h2 = _appFont(
    fontSize: AppFontSize.h2, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h3 = _appFont(
    fontSize: AppFontSize.h3, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // Titles
  static TextStyle titleLg = _appFont(
    fontSize: AppFontSize.xxl, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle titleMd = _appFont(
    fontSize: AppFontSize.xl, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle titleSm = _appFont(
    fontSize: AppFontSize.lg, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLg = _appFont(
    fontSize: AppFontSize.lg, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodyMd = _appFont(
    fontSize: AppFontSize.base, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle bodySm = _appFont(
    fontSize: AppFontSize.sm, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  // Labels
  static TextStyle labelLg = _appFont(
    fontSize: AppFontSize.base, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle labelMd = _appFont(
    fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary,
  );
  static TextStyle labelSm = _appFont(
    fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.textHint,
  );

  // Hints / Captions
  static TextStyle hint = _appFont(
    fontSize: AppFontSize.sm, fontWeight: FontWeight.w400, color: AppColors.textHint,
  );
  static TextStyle caption = _appFont(
    fontSize: AppFontSize.md, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
  );

  // Price
  static TextStyle priceLg = _appFont(
    fontSize: AppFontSize.xxl, fontWeight: FontWeight.w700, color: AppColors.secondary,
  );
  static TextStyle priceMd = _appFont(
    fontSize: AppFontSize.xl, fontWeight: FontWeight.w700, color: AppColors.secondary,
  );
  static TextStyle priceSm = _appFont(
    fontSize: AppFontSize.base, fontWeight: FontWeight.w700, color: AppColors.secondary,
  );
}

class AppShadows {
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: const Color(0xFF1A1B4B).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: const Color(0xFF1A1B4B).withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: const Color(0xFF1A1B4B).withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get button => [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: _appFont(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 24,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          textStyle: _appFont(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: _appFont(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: _appFont(
          fontSize: 14,
          color: AppColors.textHint,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: _appFont(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: _appFont(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: _appFont(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: _appFont(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineSmall: _appFont(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: _appFont(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: _appFont(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: _appFont(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: _appFont(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: _appFont(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodySmall: _appFont(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: _appFont(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: _appFont(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: _appFont(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textHint,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );

    // Apply Google Font globally to ALL TextStyles in the app
    return baseTheme.copyWith(
      textTheme: _appFontTextTheme(baseTheme.textTheme),
    );
  }
}
