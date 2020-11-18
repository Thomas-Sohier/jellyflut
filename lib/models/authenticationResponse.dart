// To parse this JSON data, do
//
//     final authenticationResponse = authenticationResponseFromMap(jsonString);

import 'dart:convert';

import 'package:jellyflut/models/sessionInfos.dart';
import 'package:jellyflut/models/user.dart';

AuthenticationResponse authenticationResponseFromMap(String str) =>
    AuthenticationResponse.fromMap(json.decode(str));

String authenticationResponseToMap(AuthenticationResponse data) =>
    json.encode(data.toMap());

class AuthenticationResponse {
  AuthenticationResponse({
    this.user,
    this.sessionInfo,
    this.accessToken,
    this.serverId,
  });

  User user;
  SessionInfo sessionInfo;
  String accessToken;
  String serverId;

  factory AuthenticationResponse.fromMap(Map<String, dynamic> json) =>
      AuthenticationResponse(
        user: User.fromMap(json['User']),
        sessionInfo: SessionInfo.fromMap(json['SessionInfo']),
        accessToken: json['AccessToken'],
        serverId: json['ServerId'],
      );

  Map<String, dynamic> toMap() => {
        'User': user.toMap(),
        'SessionInfo': sessionInfo.toMap(),
        'AccessToken': accessToken,
        'ServerId': serverId,
      };
}
