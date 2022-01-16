part of 'details_bloc.dart';

@immutable
abstract class DetailsState {
  const DetailsState({required this.detailsInfosFuture});

  final DetailsInfosFuture detailsInfosFuture;
}

class DetailsLoadedState extends DetailsState {
  DetailsLoadedState(DetailsInfosFuture detailsInfosFuture)
      : super(detailsInfosFuture: detailsInfosFuture);
}
