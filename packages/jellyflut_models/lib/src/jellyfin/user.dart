import 'index.dart';

class User {
  User({
    required this.name,
    required this.serverId,
    required this.id,
    required this.primaryImageTag,
    required this.hasPassword,
    required this.hasConfiguredPassword,
    required this.hasConfiguredEasyPassword,
    required this.enableAutoLogin,
    required this.lastLoginDate,
    required this.lastActivityDate,
    required this.configuration,
    required this.policy,
  });

  String name;
  String serverId;
  String id;
  String? primaryImageTag;
  bool hasPassword;
  bool hasConfiguredPassword;
  bool hasConfiguredEasyPassword;
  bool enableAutoLogin;
  DateTime lastLoginDate;
  DateTime lastActivityDate;
  Configuration configuration;
  Policy policy;

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json['Name'],
        serverId: json['ServerId'],
        id: json['Id'],
        primaryImageTag: json['PrimaryImageTag'],
        hasPassword: json['HasPassword'],
        hasConfiguredPassword: json['HasConfiguredPassword'],
        hasConfiguredEasyPassword: json['HasConfiguredEasyPassword'],
        enableAutoLogin: json['EnableAutoLogin'],
        lastLoginDate: DateTime.parse(json['LastLoginDate']),
        lastActivityDate: DateTime.parse(json['LastActivityDate']),
        configuration: Configuration.fromMap(json['Configuration']),
        policy: Policy.fromMap(json['Policy']),
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'ServerId': serverId,
        'Id': id,
        'PrimaryImageTag': primaryImageTag,
        'HasPassword': hasPassword,
        'HasConfiguredPassword': hasConfiguredPassword,
        'HasConfiguredEasyPassword': hasConfiguredEasyPassword,
        'EnableAutoLogin': enableAutoLogin,
        'LastLoginDate': lastLoginDate.toIso8601String(),
        'LastActivityDate': lastActivityDate.toIso8601String(),
        'Configuration': configuration.toMap(),
        'Policy': policy.toMap(),
      };
}
