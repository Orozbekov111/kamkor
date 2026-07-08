import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Holds the active theme mode (light, dark, system), persisted across
/// launches. Mirrors `LocaleCubit`: a HydratedCubit so the user's choice sticks
/// between runs. The light/dark [ThemeData] themselves live in AppTheme.
///
/// The first launch defaults to [ThemeMode.light] (not system) so a new user
/// always starts on the calm light theme; once they pick dark or system, that
/// choice is remembered.
class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void setMode(ThemeMode mode) => emit(mode);

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    final name = json['themeMode'] as String?;
    return ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Map<String, dynamic> toJson(ThemeMode state) => {'themeMode': state.name};
}
