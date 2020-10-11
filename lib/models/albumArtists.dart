class AlbumArtists {
  AlbumArtists({
    this.albumArtists,
  });

  Map<String, dynamic> albumArtists;

  factory AlbumArtists.fromMap(Map<String, dynamic> json) => AlbumArtists(
        albumArtists: json,
      );
}
