import 'dart:convert';

class NowPlayingQueue {
  final String id;
  final String playlistItemId;
  NowPlayingQueue({
    required this.id,
    required this.playlistItemId,
  });

  NowPlayingQueue copyWith({
    String? id,
    String? playlistItemId,
  }) {
    return NowPlayingQueue(
      id: id ?? this.id,
      playlistItemId: playlistItemId ?? this.playlistItemId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'PlaylistItemId': playlistItemId,
    };
  }

  factory NowPlayingQueue.fromMap(Map<String, dynamic> map) {
    return NowPlayingQueue(
      id: map['Id'] ?? '',
      playlistItemId: map['PlaylistItemId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NowPlayingQueue.fromJson(String source) => NowPlayingQueue.fromMap(json.decode(source));

  @override
  String toString() => 'NowPlayingQueue(Id: $id, PlaylistItemId: $playlistItemId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NowPlayingQueue && other.id == id && other.playlistItemId == playlistItemId;
  }

  @override
  int get hashCode => id.hashCode ^ playlistItemId.hashCode;
}
