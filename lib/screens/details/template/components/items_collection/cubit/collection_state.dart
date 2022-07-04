part of 'collection_cubit.dart';

enum CollectionStatus { initial, loading, success, failure }

class CollectionState extends Equatable {
  const CollectionState({this.status = CollectionStatus.initial, this.season, this.episodes = const <Item>[]});

  final CollectionStatus status;
  final Item? season;
  final List<Item> episodes;

  CollectionState copyWith({CollectionStatus? status, Item? season, List<Item>? episodes}) {
    return CollectionState(
        status: status ?? this.status, season: season ?? this.season, episodes: episodes ?? this.episodes);
  }

  @override
  List<Object?> get props => [status, season, episodes];
}
