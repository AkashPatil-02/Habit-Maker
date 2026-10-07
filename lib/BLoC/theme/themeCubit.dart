import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/theme/themeState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Themecubit extends Cubit<ThemeState> {
  Themecubit() : super(ThemeState(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final bool dark = prefs.getBool('dark') ?? false;

    emit(
      ThemeState(
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }

  Future<void> setLightTheme() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('dark', false);

    emit(
      ThemeState(
        themeMode: ThemeMode.light,
      ),
    );
  }

  Future<void> setDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('dark', true);

    emit(
      ThemeState(
        themeMode: ThemeMode.dark,
      ),
    );
  }

  Future<void> toggleTheme() async {
    if (state.themeMode == ThemeMode.dark) {
      await setLightTheme();
    } else {
      await setDarkTheme();
    }
  }
}