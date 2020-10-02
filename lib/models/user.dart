import 'package:jellyflut/models/policy.dart';

import 'configuration.dart';

class User {
  User({
    this.name,
    this.serverId,
    this.id,
    this.primaryImageTag,
    this.hasPassword,
    this.hasConfiguredPassword,
    this.hasConfiguredEasyPassword,
    this.enableAutoLogin,
    this.lastLoginDate,
    this.lastActivityDate,
    this.configuration,
    this.policy,
  });

  String name;
  String serverId;
  String id;
  String primaryImageTag;
  bool hasPassword;
  bool hasConfiguredPassword;
  bool hasConfiguredEasyPassword;
  bool enableAutoLogin;
  DateTime lastLoginDate;
  DateTime lastActivityDate;
  Configuration configuration;
  Policy policy;

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json["Name"],
        serverId: json["ServerId"],
        id: json["Id"],
        primaryImageTag: json["PrimaryImageTag"],
        hasPassword: json["HasPassword"],
        hasConfiguredPassword: json["HasConfiguredPassword"],
        hasConfiguredEasyPassword: json["HasConfiguredEasyPassword"],
        enableAutoLogin: json["EnableAutoLogin"],
        lastLoginDate: DateTime.parse(json["LastLoginDate"]),
        lastActivityDate: DateTime.parse(json["LastActivityDate"]),
        configuration: Configuration.fromMap(json["Configuration"]),
        policy: Policy.fromMap(json["Policy"]),
      );

  Map<String, dynamic> toMap() => {
        "Name": name,
        "ServerId": serverId,
        "Id": id,
        "PrimaryImageTag": primaryImageTag,
        "HasPassword": hasPassword,
        "HasConfiguredPassword": hasConfiguredPassword,
        "HasConfiguredEasyPassword": hasConfiguredEasyPassword,
        "EnableAutoLogin": enableAutoLogin,
        "LastLoginDate": lastLoginDate.toIso8601String(),
        "LastActivityDate": lastActivityDate.toIso8601String(),
        "Configuration": configuration.toMap(),
        "Policy": policy.toMap(),
      };
}
