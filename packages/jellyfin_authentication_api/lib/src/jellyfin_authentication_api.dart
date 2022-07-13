import 'package:authentication_api/authentication_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyfin_authentication_api/src/models/auth_by_name.dart';

import 'models/authentication_response.dart';

/// {@template jellyfin_authentication_api}
/// A dart API client for the Jellyfin Auth API
/// {@endtemplate}
class JellyfinAuthenticationApi extends AuthenticationApi {
  /// {@macro jellyfin_authentication_api}
  JellyfinAuthenticationApi({required Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  /// Login a user to defined endpoint
  /// A server URL can be defined to override current one
  ///
  /// Can throw [AuthenticationFailure]
  @override
  Future<User> logIn(
      {required String serverName,
      required String serverUrl,
      required String username,
      required String password}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '$serverUrl/Users/authenticatebyname',
        data: AuthByName(username: username, password: password),
      );

      if (response.statusCode != 200) throw AuthenticationFailure('Error while trying to authenticate');

      final authenticationResponse = await compute(AuthenticationResponse.fromJson, response.data!);

      if (authenticationResponse.user == null) throw AuthenticationFailure('Incomplete response from backend');

      return User(
          id: authenticationResponse.user!.id,
          username: authenticationResponse.user!.name ?? '',
          token: authenticationResponse.accessToken);
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

  @override
  Future<void> logout({required String serverUrl}) async {
    final response = await _dioClient.post('$serverUrl/Sessions​/Logout');

    if (response.statusCode != 204) {
      throw AuthenticationFailure('Error while logout from jellyfin');
    }
  }
}

/// Exception thrown when views request has failed.
class AuthenticationFailure implements Exception {
  final dynamic message;

  AuthenticationFailure([this.message]);
}
