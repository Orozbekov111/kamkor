import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Holds the active locale (ky default, ru), persisted across launches.
class LocaleCubit extends HydratedCubit<Locale> {
  LocaleCubit() : super(const Locale('ky'));

  void setKyrgyz() => emit(const Locale('ky'));
  void setRussian() => emit(const Locale('ru'));

  @override
  Locale fromJson(Map<String, dynamic> json) =>
      Locale(json['languageCode'] as String? ?? 'ky');

  @override
  Map<String, dynamic> toJson(Locale state) =>
      {'languageCode': state.languageCode};
}
