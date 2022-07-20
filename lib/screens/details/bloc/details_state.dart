part of 'details_bloc.dart';

enum ScreenLayout {
  mobile,
  desktop;

  const ScreenLayout();

  bool get isDesktop => this == desktop;
  bool get isMobile => this == mobile;
}

enum DetailsStatus { initial, loading, success, failure }

@immutable
class DetailsState extends Equatable {
  final Item item;
  final String? heroTag;
  final ThemeData theme;
  final ScreenLayout screenLayout;
  final DetailsStatus detailsStatus;
  final bool pinnedHeader;

  const DetailsState(
      {required this.theme,
      required this.item,
      required this.screenLayout,
      this.pinnedHeader = false,
      this.heroTag,
      this.detailsStatus = DetailsStatus.initial});

  DetailsState copyWith(
      {ThemeData? theme,
      Item? item,
      ScreenLayout? screenLayout,
      String? heroTag,
      DetailsStatus? detailsStatus,
      bool? pinnedHeader}) {
    return DetailsState(
        item: item ?? this.item,
        theme: theme ?? this.theme,
        heroTag: heroTag ?? this.heroTag,
        pinnedHeader: pinnedHeader ?? this.pinnedHeader,
        screenLayout: screenLayout ?? this.screenLayout,
        detailsStatus: detailsStatus ?? this.detailsStatus);
  }

  @override
  List<Object?> get props => [theme, item, heroTag, detailsStatus, pinnedHeader, screenLayout];
}
