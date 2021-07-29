class ExternalUrl {
  ExternalUrl({
    this.name,
    this.url,
  });

  String? name;
  String? url;

  factory ExternalUrl.fromMap(Map<String, dynamic> json) => ExternalUrl(
        name: json['Name'],
        url: json['Url'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Url': url,
      };
}
