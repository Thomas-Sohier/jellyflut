import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

/// Exception thrown when views request has failed.
class UserNotFound implements Exception {}

/// Exception thrown when views request has failed.
class AuthenticationFailure implements Exception {
  final dynamic message;

  AuthenticationFailure([this.message]);
}

/// {@template users_api}
/// A dart API client for the Jellyfin User API
/// {@endtemplate}
class UsersApi {
  /// {@macro users_api}
  UsersApi({required String serverUrl, String? userId, Dio? dioClient})
      : _dioClient = dioClient ?? Dio(),
        _serverUrl = serverUrl,
        _userId = userId ?? _notLoggedUserId;

  static const _notLoggedUserId = '-1';
  final Dio _dioClient;
  String _serverUrl;
  String _userId;

  /// Update API properties
  /// UseFul when endpoint Server or user change
  void updateProperties({String? serverUrl, String? userId}) {
    _serverUrl = serverUrl ?? _serverUrl;
    _userId = userId ?? _userId;
  }

  /// Get user by his ID
  ///
  /// Can throw [UserNotFound]
  Future<User> getUserById({required String userId}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$_serverUrl/Users/$userId');

      if (response.statusCode != 200) {
        throw UserNotFound();
      }

      return compute(User.fromMap, response.data!);
    } catch (_) {
      throw UserNotFound();
    }
  }

  /// Get current User based on current used userid
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUser() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$_serverUrl/Users/$_userId');

      if (response.statusCode != 200) {
        throw UserNotFound();
      }

      return compute(User.fromMap, response.data!);
    } catch (_) {
      throw UserNotFound();
    }
  }

  /// Get current User based on current token
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUserFromToken() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$_serverUrl/Users/Me');

      if (response.statusCode != 200) {
        throw UserNotFound();
      }

      return compute(User.fromMap, response.data!);
    } catch (_) {
      throw UserNotFound();
    }
  }

  /// Get all users from current server
  ///
  /// Can throw [UserNotFound]
  Future<List<User>> getUsers() async {
    try {
      final response = await _dioClient.get<List<dynamic>>('$_serverUrl/Users');

      if (response.statusCode != 200) {
        throw UserNotFound();
      }

      List<User> parseUsers(List<dynamic> list) => list.map((user) => User.fromMap(user)).toList();

      return compute(parseUsers, response.data!);
    } catch (_) {
      throw UserNotFound();
    }
  }

  /// Login a user to defined endpoint
  /// A server URL can be defined to override current one
  ///
  /// Can throw [AuthenticationFailure]
  Future<AuthenticationResponse> login(String username, String password, [String? serverUrl]) async {
    try {
      // final authEmby = await authHeader(embedToken: false);
      // Override default sever URL if needed
      serverUrl ??= _serverUrl;
      final response = await _dioClient.post(
        '$_serverUrl/Users/authenticatebyname',
        data: jsonEncode({'Username': username, 'Pw': password}),
        // X-Emby-Authorization needs to be set manually here
        // I don't know why...
        // options: Options(headers: {'X-Emby-Authorization': authEmby}
      );

      if (response.statusCode != 200) {
        throw AuthenticationFailure('Error while trying to authenticate');
      }

      return AuthenticationResponse.fromMap(response.data);
    } on DioError catch (dioError) {
      switch (dioError.response?.statusCode ?? 500) {
        case 401:
          throw AuthenticationFailure('Authentication error, check your login, password and server\'s url');
        case 404:
          throw AuthenticationFailure('Url error, check that youre using the correct url and/or subpath');
        case 500:
          throw AuthenticationFailure('Server error, check that you can connect to your server');
        default:
          throw AuthenticationFailure('Cannot access to the server, check your url and/or your server');
      }
    } on Exception catch (e) {
      throw AuthenticationFailure('Unknow error : ${e.toString()}');
    }
  }
}
