part of 'details_bloc.dart';

enum ScreenLayout {
  mobile,
  desktop;
}

enum DetailsStatus { initial, loading, success, failure }

@immutable
class DetailsState extends Equatable {
  final Item item;
  final String? heroTag;
  final ThemeData theme;
  final ScreenLayout screenLayout;
  final DetailsStatus detailsStatus;

  const DetailsState(
      {required this.theme,
      required this.item,
      required this.screenLayout,
      this.heroTag,
      this.detailsStatus = DetailsStatus.initial});

  DetailsState copyWith(
      {ThemeData? theme, Item? item, ScreenLayout? screenLayout, String? heroTag, DetailsStatus? detailsStatus}) {
    return DetailsState(
        item: item ?? this.item,
        theme: theme ?? this.theme,
        heroTag: heroTag ?? this.heroTag,
        screenLayout: screenLayout ?? this.screenLayout,
        detailsStatus: detailsStatus ?? this.detailsStatus);
  }

  @override
  List<Object?> get props => [theme, item, heroTag, detailsStatus, screenLayout];
}
