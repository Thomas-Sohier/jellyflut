class GenreItem {
  GenreItem({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory GenreItem.fromMap(Map<String, dynamic> json) => GenreItem(
        name: json['Name'],
        id: json['Id'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Id': id,
      };
}
