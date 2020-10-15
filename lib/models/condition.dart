class Condition {
  Condition({
    this.condition,
    this.property,
    this.value,
    this.isRequired,
  });

  String condition;
  String property;
  String value;
  bool isRequired;

  factory Condition.fromMap(Map<String, dynamic> json) => Condition(
        condition: json["Condition"] == null ? null : json["Condition"],
        property: json["Property"] == null ? null : json["Property"],
        value: json["Value"] == null ? null : json["Value"],
        isRequired: json["IsRequired"] == null ? null : json["IsRequired"],
      );

  Map<String, dynamic> toMap() => {
        "Condition": condition == null ? null : condition,
        "Property": property == null ? null : property,
        "Value": value == null ? null : value,
        "IsRequired": isRequired == null ? null : isRequired,
      };
}
