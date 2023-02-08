part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsInitRequested extends SettingsEvent {
  const SettingsInitRequested();
}

class SettingsUpdateRequested extends SettingsEvent {
  final DatabaseSettingDto databaseSettingDto;

  const SettingsUpdateRequested({required this.databaseSettingDto});
}

class DetailsPageContrastChangeRequested extends SettingsEvent {
  final bool detailsPageContrasted;

  const DetailsPageContrastChangeRequested({required this.detailsPageContrasted});
}
