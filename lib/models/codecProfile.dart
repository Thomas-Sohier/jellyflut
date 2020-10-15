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
        type: json["Type"] == null ? null : json["Type"],
        codec: json["Codec"] == null ? null : json["Codec"],
        conditions: json["Conditions"] == null
            ? null
            : List<Condition>.from(
                json["Conditions"].map((x) => Condition.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "Type": type == null ? null : type,
        "Codec": codec == null ? null : codec,
        "Conditions": conditions == null
            ? null
            : List<dynamic>.from(conditions.map((x) => x.toMap())),
      };
}
