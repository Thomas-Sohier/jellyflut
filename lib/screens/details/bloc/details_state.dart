part of 'details_bloc.dart';

@immutable
abstract class DetailsState extends Equatable {
  const DetailsState({required this.detailsInfosFuture});

  final DetailsInfosFuture detailsInfosFuture;

  @override
  List<Object> get props => [detailsInfosFuture];
}

class DetailsLoadedState extends DetailsState {
  DetailsLoadedState(DetailsInfosFuture detailsInfosFuture)
      : super(detailsInfosFuture: detailsInfosFuture);
}
