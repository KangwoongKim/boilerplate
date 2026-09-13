import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/palette.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppPalette.light, Brightness.light);

  static ThemeData dark() => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: palette.accent,
      onPrimary: palette.onAccent,
      secondary: palette.textSecondary,
      onSecondary: palette.surface,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: palette.error,
      onError: palette.onAccent,
      outline: palette.border,
    );

    final textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.1,
        color: palette.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.25,
        color: palette.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: palette.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: palette.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: palette.textTertiary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      splashColor: palette.accent.withValues(alpha: 0.06),
      highlightColor: palette.accent.withValues(alpha: 0.04),
      extensions: [palette],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: palette.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.border,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? palette.accent : palette.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? palette.accent : palette.textSecondary,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        hintStyle: TextStyle(color: palette.textTertiary, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide(color: palette.accent, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
          borderSide: BorderSide(color: palette.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.onAccent,
          elevation: 0,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.textSecondary,
          minimumSize: const Size(48, 44),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.accent,
        elevation: 0,
        contentTextStyle: TextStyle(
          color: palette.onAccent,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        space: 1,
        thickness: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: palette.accent),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.accent;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(palette.onAccent),
        side: BorderSide(color: palette.border, width: 1.4),
      ),
    );
  }
}
