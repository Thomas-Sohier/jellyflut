import 'condition.dart';

class CodecProfile {
  CodecProfile({
    this.type,
    this.codec,
    this.conditions,
  });

  String type;
  String codec;
  List<Condition> conditions;

  factory CodecProfile.fromMap(Map<String, dynamic> json) => CodecProfile(
        type: json['Type'],
        codec: json['Codec'],
        conditions: json['Conditions'] == null
            ? null
            : List<Condition>.from(
                json['Conditions'].map((x) => Condition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        if (type != null) 'Type': type,
        if (codec != null) 'Codec': codec,
        if (conditions != null)
          'Conditions': List<dynamic>.from(conditions.map((x) => x.toMap())),
      };
}
