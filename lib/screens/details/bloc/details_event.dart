part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsUpdateItem extends DetailsEvent {
  final Item item;

  DetailsUpdateItem({required this.item});

  @override
  List<Object> get props => [item];
}

class DetailsUpdateSeedColor extends DetailsEvent {
  final List<Color> colors;

  DetailsUpdateSeedColor({required this.colors});
}

class DetailsUpdateTheme extends DetailsEvent {
  final ThemeData theme;

  DetailsUpdateTheme({required this.theme});
}

class DetailsUpdateDetailsInfos extends DetailsEvent {
  final DetailsInfosFuture detailsInfos;

  DetailsUpdateDetailsInfos({required this.detailsInfos});

  @override
  List<Object> get props => [detailsInfos];
}

class DetailsScreenSizeChanged extends DetailsEvent {
  final ScreenLayout screenLayout;

  DetailsScreenSizeChanged({required this.screenLayout});

  @override
  List<Object> get props => [screenLayout];
}

class ResetStates extends DetailsEvent {}

enum ScreenLayout {
  mobile,
  desktop;
}
