import 'package:jellyflut/shared/enums.dart';

import 'imageBlurHashes.dart';

class Person {
  Person({
    this.name,
    this.id,
    this.role,
    this.type,
    this.primaryImageTag,
    this.imageBlurHashes,
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
        type: personTypeValues.map[json['Type']],
        primaryImageTag:
            json['PrimaryImageTag'] == null ? null : json['PrimaryImageTag'],
        imageBlurHashes: json['ImageBlurHashes'] == null
            ? null
            : ImageBlurHashes.fromMap(json['ImageBlurHashes']),
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Id': id,
        'Role': role,
        'Type': personTypeValues.reverse[type],
        'PrimaryImageTag': primaryImageTag == null ? null : primaryImageTag,
        'ImageBlurHashes':
            imageBlurHashes == null ? null : imageBlurHashes.toMap(),
      };
}
