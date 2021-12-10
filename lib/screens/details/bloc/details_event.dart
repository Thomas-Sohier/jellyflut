part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {}

class DetailsItemUpdated extends DetailsEvent {
  final Item item;

  DetailsItemUpdated({required this.item});
}

class DetailsItemInfos extends DetailsEvent {
  final DetailsInfosFuture detailsInfos;

  DetailsItemInfos({required this.detailsInfos});
}

class ResetStates extends DetailsEvent {}
