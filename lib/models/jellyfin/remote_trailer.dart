class RemoteTrailer {
  RemoteTrailer({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory RemoteTrailer.fromMap(Map<String, dynamic> json) => RemoteTrailer(
        name: json.keys.first,
        url: json[json.keys.first],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Url': url,
      };
}
