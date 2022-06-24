class Condition {
  const Condition({
    required this.condition,
    required this.property,
    required this.value,
    this.isRequired,
  });

  final String condition;
  final String property;
  final dynamic value;
  final bool? isRequired;

  factory Condition.fromMap(Map<String, dynamic> json) => Condition(
        condition: json['Condition'],
        property: json['Property'],
        value: json['Value'],
        isRequired: json['IsRequired'],
      );

  Map<String, dynamic> toMap() => {
        'Condition': condition,
        'Property': property,
        if (value != null || value != '') 'Value': value,
        if (isRequired != null) 'IsRequired': isRequired,
      };
}
