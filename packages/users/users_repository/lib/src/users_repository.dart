import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:users_api/users_api.dart';

/// {@template users_repository}
/// A repository that handles items related requests
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  const UsersRepository({required UsersApi usersApi}) : _usersApi = usersApi;

  final UsersApi _usersApi;

  /// Update API properties
  /// UseFul when endpoint Server  or user change
  void updateProperties({String? serverUrl, String? userId}) =>
      _usersApi.updateProperties(serverUrl: serverUrl, userId: userId);

  /// Get current User based on current used userid
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUser() => _usersApi.getCurrentUser();

  /// Get current User based on current token
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUserFromToken() => _usersApi.getCurrentUserFromToken();

  /// Get user by his ID
  ///
  /// Can throw [UserNotFound]
  Future<User> getUserById({required String userId}) => _usersApi.getUserById(userId: userId);

  /// Get all users from current server
  ///
  /// Can throw [UserNotFound]
  Future<List<User>> getUsers() => _usersApi.getUsers();

  /// Login a user to defined endpoint
  /// A server URL can be defined to override current one
  ///
  /// Can throw [AuthenticationFailure]
  Future<AuthenticationResponse> login({required String username, required String password, String? serverUrl}) =>
      _usersApi.login(username, password, serverUrl);
}
