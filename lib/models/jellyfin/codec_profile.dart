import 'condition.dart';

class CodecProfile {
  CodecProfile({
    this.codec,
    this.container,
    required this.type,
    required this.conditions,
  });

  String type;
  String? container;
  String? codec;
  List<Condition> conditions;

  factory CodecProfile.fromMap(Map<String, dynamic> json) => CodecProfile(
        type: json['Type'],
        codec: json['Codec'],
        container: json['Container'],
        conditions: List<Condition>.from(
            json['Conditions'].map((x) => Condition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'Type': type,
        'Codec': codec,
        'Container': container,
        'Conditions': List<dynamic>.from(conditions.map((x) => x.toMap())),
      };
}
