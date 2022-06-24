class Studio {
  Studio({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory Studio.fromMap(Map<String, dynamic> json) => Studio(
        name: json['Name'],
        id: json['Id'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Id': id,
      };
}
