import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _preferences;

  ThemeCubit(this._preferences) : super(const ThemeInitial(ThemeMode.system)) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final String? savedTheme = _preferences.getString('themeMode');
    if (savedTheme != null) {
      final themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      emit(ThemeInitial(themeMode));
    }
  }

  void setThemeMode(ThemeMode mode) {
    _preferences.setString('themeMode', mode.toString());
    emit(ThemeInitial(mode));
  }
}
