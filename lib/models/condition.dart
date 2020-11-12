class Condition {
  Condition({
    this.condition,
    this.property,
    this.value,
    this.isRequired,
  });

  String condition;
  String property;
  dynamic value;
  bool isRequired;

  factory Condition.fromMap(Map<String, dynamic> json) => Condition(
        condition: json['Condition'] ?? null,
        property: json['Property'] ?? null,
        value: json['Value'] ?? null,
        isRequired: json['IsRequired'] ?? null,
      );

  Map<String, dynamic> toMap() => {
        if (condition != null) 'Condition': condition,
        if (property != null) 'Property': property,
        if (value != null || value != '') 'Value': value,
        if (isRequired != null) 'IsRequired': isRequired,
      };
}
