import 'condition.dart';

class CodecProfile {
  CodecProfile({
    required this.type,
    required this.codec,
    required this.conditions,
  });

  String type;
  String codec;
  List<Condition> conditions;

  factory CodecProfile.fromMap(Map<String, dynamic> json) => CodecProfile(
        type: json['Type'],
        codec: json['Codec'],
        conditions: List<Condition>.from(
            json['Conditions'].map((x) => Condition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'Type': type,
        'Codec': codec,
        'Conditions': List<dynamic>.from(conditions.map((x) => x.toMap())),
      };
}
