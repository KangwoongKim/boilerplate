import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences.dart';

class AppSettings {
  const AppSettings({required this.themeMode});

  final ThemeMode themeMode;

  static const defaults = AppSettings(themeMode: ThemeMode.system);

  AppSettings copyWith({ThemeMode? themeMode}) {
    return AppSettings(themeMode: themeMode ?? this.themeMode);
  }
}

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const _themeKey = 'theme_mode';

  SharedPreferences? get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final prefs = _prefs;
    if (prefs == null) return AppSettings.defaults;
    final themeIndex = prefs.getInt(_themeKey);
    return AppSettings(
      themeMode: themeIndex == null
          ? ThemeMode.system
          : ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)],
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setInt(_themeKey, mode.index);
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
