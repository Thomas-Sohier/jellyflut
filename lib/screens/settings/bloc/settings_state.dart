part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

@immutable
class SettingsState extends Equatable {
  const SettingsState(
      {this.settingsStatus = SettingsStatus.initial,
      this.databaseSetting = DatabaseSetting.empty,
      this.detailsPageContrasted = false,
      this.version = ''});

  final SettingsStatus settingsStatus;
  final DatabaseSetting databaseSetting;
  final String version;
  final bool detailsPageContrasted;

  SettingsState copyWith(
      {SettingsStatus? settingsStatus,
      DatabaseSetting? databaseSetting,
      String? version,
      bool? detailsPageContrasted}) {
    return SettingsState(
        version: version ?? this.version,
        detailsPageContrasted: detailsPageContrasted ?? this.detailsPageContrasted,
        settingsStatus: settingsStatus ?? this.settingsStatus,
        databaseSetting: databaseSetting ?? this.databaseSetting);
  }

  @override
  List<Object?> get props => [settingsStatus, databaseSetting, detailsPageContrasted];
}
