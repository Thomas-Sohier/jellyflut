class ArtistItems {
  ArtistItems({
    required this.artistItems,
  });

  Map<String, dynamic> artistItems;

  factory ArtistItems.fromMap(Map<String, dynamic> json) => ArtistItems(
        artistItems: json,
      );
}
