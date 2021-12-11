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

class DetailsUpdateDetailsInfos extends DetailsEvent {
  final DetailsInfosFuture detailsInfos;

  DetailsUpdateDetailsInfos({required this.detailsInfos});

  @override
  List<Object> get props => [detailsInfos];
}

class ResetStates extends DetailsEvent {}
