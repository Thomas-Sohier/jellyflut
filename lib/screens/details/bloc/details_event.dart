part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsInitRequested extends DetailsEvent {
  final Item item;

  DetailsInitRequested({required this.item});
}

class DetailsUpdateSeedColor extends DetailsEvent {
  final List<Color> colors;

  DetailsUpdateSeedColor({required this.colors});
}

class DetailsThemeUpdate extends DetailsEvent {
  final ThemeData theme;

  DetailsThemeUpdate({required this.theme});
}

class DetailsItemUpdate extends DetailsEvent {
  final Item item;

  DetailsItemUpdate({required this.item});

  @override
  List<Object> get props => [item];
}

class DetailsScreenSizeChanged extends DetailsEvent {
  final ScreenLayout screenLayout;

  DetailsScreenSizeChanged({required this.screenLayout});

  @override
  List<Object> get props => [screenLayout];
}

class ResetStates extends DetailsEvent {}
