import 'package:freezed_annotation/freezed_annotation.dart';

import 'models/token_interceptor.dart';
import 'models/user.dart';

/// {@template authentication_api}
/// A dart API client for the Jellyfin Auth API
/// {@endtemplate}
@Immutable()
abstract class AuthenticationApi {
  /// {@macro authentication_api}
  const AuthenticationApi();

  Future<User> logIn(
      {required String serverName, required String serverUrl, required String username, required String password});

  Future<void> logout({required String serverUrl});

  Future<TokenInterceptor> generateToken({String? accessToken, String? refreshToken});
}

/// Error thrown when login fail
class LoginException implements Exception {}
