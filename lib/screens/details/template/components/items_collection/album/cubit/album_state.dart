part of 'album_cubit.dart';

enum Status { initial, loading, success, failure }

class AlbumState extends Equatable {
  const AlbumState({
    required this.parentItem,
    this.status = Status.initial,
    this.songs = const <Item>[],
  });

  final Status status;
  final Item parentItem;
  final List<Item> songs;

  AlbumState copyWith({
    Status? status,
    Item? parentItem,
    List<Item>? songs,
  }) {
    return AlbumState(
      status: status ?? this.status,
      parentItem: parentItem ?? this.parentItem,
      songs: songs ?? this.songs,
    );
  }

  @override
  List<Object?> get props => [status, parentItem, songs];
}
