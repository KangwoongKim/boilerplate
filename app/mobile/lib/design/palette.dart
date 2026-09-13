import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.disabled,
    required this.accent,
    required this.onAccent,
    required this.error,
    required this.warning,
    required this.success,
  });

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color disabled;
  final Color accent;
  final Color onAccent;
  final Color error;
  final Color warning;
  final Color success;

  static const light = AppPalette(
    background: Color(0xFFF7F7F5),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1C1C1C),
    textSecondary: Color(0xFF707070),
    textTertiary: Color(0xFFA0A0A0),
    border: Color(0xFFE5E5E2),
    disabled: Color(0xFFB8B8B5),
    accent: Color(0xFF2C2C2A),
    onAccent: Color(0xFFFFFFFF),
    error: Color(0xFFC04545),
    warning: Color(0xFFA67C32),
    success: Color(0xFF3D6B4F),
  );

  static const dark = AppPalette(
    background: Color(0xFF141413),
    surface: Color(0xFF1E1E1C),
    textPrimary: Color(0xFFF2F2F0),
    textSecondary: Color(0xFFA8A8A4),
    textTertiary: Color(0xFF6E6E6A),
    border: Color(0xFF333330),
    disabled: Color(0xFF5C5C58),
    accent: Color(0xFFE8E6E0),
    onAccent: Color(0xFF1C1C1C),
    error: Color(0xFFD66A6A),
    warning: Color(0xFFC4A15A),
    success: Color(0xFF6A9A7A),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? disabled,
    Color? accent,
    Color? onAccent,
    Color? error,
    Color? warning,
    Color? success,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
}

abstract final class AppRadius {
  static const small = 8.0;
  static const control = 12.0;
  static const card = 16.0;
  static const sheet = 20.0;
}

abstract final class AppCopy {
  static const appName = 'Boilerplate';
}
