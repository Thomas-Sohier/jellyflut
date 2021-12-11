part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {}

class DetailsUpdateItem extends DetailsEvent {
  final Item item;

  DetailsUpdateItem({required this.item});
}

class DetailsUpdateDetailsInfos extends DetailsEvent {
  final DetailsInfosFuture detailsInfos;

  DetailsUpdateDetailsInfos({required this.detailsInfos});
}

class ResetStates extends DetailsEvent {}
