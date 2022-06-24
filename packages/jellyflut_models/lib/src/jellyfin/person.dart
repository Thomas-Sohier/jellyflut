import '../enum/enum.dart';
import 'image_blur_hashes.dart';
import 'item.dart';

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
  String? role;
  PersonType type;
  String? primaryImageTag;
  ImageBlurHashes? imageBlurHashes;

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        name: json['Name'],
        id: json['Id'],
        role: json['Role'],
        type: PersonType.fromString(json['Type']),
        primaryImageTag: json['PrimaryImageTag'],
        imageBlurHashes: json['ImageBlurHashes'] != null
            ? ImageBlurHashes.fromMap(json['ImageBlurHashes'])
            : json['ImageBlurHashes'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'Id': id,
        'Role': role,
        'Type': type,
        'PrimaryImageTag': primaryImageTag,
        'ImageBlurHashes': imageBlurHashes?.toMap(),
      };

  Item asItem() {
    return Item(
        id: id,
        name: name,
        type: ItemType.PERSON,
        imageBlurHashes: imageBlurHashes);
  }
}
