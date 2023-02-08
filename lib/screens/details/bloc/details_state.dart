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
  final EdgeInsets contentPadding;
  final bool contrastedPage;

  const DetailsState(
      {required this.theme,
      required this.item,
      required this.screenLayout,
      this.pinnedHeader = false,
      this.heroTag,
      this.contrastedPage = false,
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 12),
      this.detailsStatus = DetailsStatus.initial});

  DetailsState copyWith(
      {ThemeData? theme,
      Item? item,
      ScreenLayout? screenLayout,
      String? heroTag,
      DetailsStatus? detailsStatus,
      EdgeInsets? contentPadding,
      bool? contrastedPage,
      bool? pinnedHeader}) {
    return DetailsState(
        item: item ?? this.item,
        theme: theme ?? this.theme,
        heroTag: heroTag ?? this.heroTag,
        contrastedPage: contrastedPage ?? this.contrastedPage,
        contentPadding: contentPadding ?? this.contentPadding,
        pinnedHeader: pinnedHeader ?? this.pinnedHeader,
        screenLayout: screenLayout ?? this.screenLayout,
        detailsStatus: detailsStatus ?? this.detailsStatus);
  }

  @override
  List<Object?> get props =>
      [theme, item, contentPadding, contrastedPage, heroTag, detailsStatus, pinnedHeader, screenLayout];
}
