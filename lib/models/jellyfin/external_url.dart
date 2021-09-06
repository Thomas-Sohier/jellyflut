class ExternalUrl {
  ExternalUrl({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory ExternalUrl.fromMap(Map<String, dynamic> json) => ExternalUrl(
        name: json['Name'],
        url: json['Url'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Url': url,
      };
}
