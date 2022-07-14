part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

@immutable
class SettingsState extends Equatable {
  const SettingsState(
      {this.settingsStatus = SettingsStatus.initial, this.databaseSetting = DatabaseSetting.empty, this.version = ''});

  final SettingsStatus settingsStatus;
  final DatabaseSetting databaseSetting;
  final String version;

  SettingsState copyWith({SettingsStatus? settingsStatus, DatabaseSetting? databaseSetting, String? version}) {
    return SettingsState(
        version: version ?? this.version,
        settingsStatus: settingsStatus ?? this.settingsStatus,
        databaseSetting: databaseSetting ?? this.databaseSetting);
  }

  @override
  List<Object?> get props => [settingsStatus, databaseSetting];
}
