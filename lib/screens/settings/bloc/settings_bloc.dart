import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(
      {required SettingsRepository settingsRepository,
      required AuthenticationRepository authenticationRepository,
      required PackageInfo packageInfo})
      : _settingsRepository = settingsRepository,
        _authenticationRepository = authenticationRepository,
        _packageInfo = packageInfo,
        super(const SettingsState()) {
    on<SettingsInitRequested>(_onSettingsInitRequested);
    on<SettingsUpdateRequested>(_onSettingsUpdateRequested);
    _authenticationRepository.user.listen((user) => user.isNotEmpty ? add(SettingsInitRequested()) : null);
  }

  final SettingsRepository _settingsRepository;
  final AuthenticationRepository _authenticationRepository;
  final PackageInfo _packageInfo;

  void _onSettingsInitRequested(SettingsInitRequested event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(settingsStatus: SettingsStatus.loading));
    try {
      final databaseSetting = await _settingsRepository.getcurrentSettings();
      final version = _packageInfo.version;
      emit(state.copyWith(databaseSetting: databaseSetting, version: version, settingsStatus: SettingsStatus.success));
    } catch (_) {
      emit(state.copyWith(settingsStatus: SettingsStatus.failure));
    }
  }

  void _onSettingsUpdateRequested(SettingsUpdateRequested event, Emitter<SettingsState> emit) async {
    await _settingsRepository.updateCurrentSettings(event.databaseSettingDto);
    final databaseSetting = await _settingsRepository.getcurrentSettings();
    emit(state.copyWith(databaseSetting: databaseSetting));
  }
}
