import 'package:jellyflut/shared/enums.dart';

import 'imageBlurHashes.dart';

class Person {
  Person({
    required this.name,
    required this.id,
    required this.role,
    required this.type,
    required this.primaryImageTag,
    required this.imageBlurHashes,
  });

  String name;
  String id;
  String role;
  PersonType type;
  String primaryImageTag;
  ImageBlurHashes imageBlurHashes;

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        name: json['Name'],
        id: json['Id'],
        role: json['Role'],
        type: json['Type'],
        primaryImageTag: json['PrimaryImageTag'],
        imageBlurHashes: ImageBlurHashes.fromMap(json['ImageBlurHashes']),
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Id': id,
        'Role': role,
        'Type': personTypeValues.reverse[type],
        'PrimaryImageTag': primaryImageTag,
        'ImageBlurHashes': imageBlurHashes.toMap(),
      };
}
