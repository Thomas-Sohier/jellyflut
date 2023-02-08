import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

/// Exception thrown when views request has failed.
class UserNotFound implements Exception {}

/// {@template users_api}
/// A dart API client for the Jellyfin User API
/// {@endtemplate}
class UsersApi {
  /// {@macro users_api}
  UsersApi({required Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  /// Get user by his ID
  ///
  /// Can throw [UserNotFound]
  Future<User> getUserById({required String serverUrl, required String userId}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$serverUrl/Users/$userId');

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
  Future<User> getCurrentUser({required String serverUrl, required String userId}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$serverUrl/Users/$userId');

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
  Future<User> getCurrentUserFromToken({required String serverUrl}) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$serverUrl/Users/Me');

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
  Future<List<User>> getUsers({required String serverUrl}) async {
    try {
      final response = await _dioClient.get<List<dynamic>>('$serverUrl/Users');

      if (response.statusCode != 200) {
        throw UserNotFound();
      }

      List<User> parseUsers(List<dynamic> list) => list.map((user) => User.fromMap(user)).toList();

      return compute(parseUsers, response.data!);
    } catch (_) {
      throw UserNotFound();
    }
  }
}
