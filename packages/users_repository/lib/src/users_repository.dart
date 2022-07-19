import 'package:authentication_repository/authentication_repository.dart' hide User;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:users_api/users_api.dart';

/// {@template users_repository}
/// A repository that handles items related requests
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  const UsersRepository({required UsersApi usersApi, required AuthenticationRepository authenticationRepository})
      : _usersApi = usersApi,
        _authenticationRepository = authenticationRepository;

  final UsersApi _usersApi;
  final AuthenticationRepository _authenticationRepository;

  String get currentServerUrl => _authenticationRepository.currentServer.url;
  String get currentUserId => _authenticationRepository.currentUser.id;

  /// Get current User based on current used userid
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUser() => _usersApi.getCurrentUser(serverUrl: currentServerUrl, userId: currentUserId);

  /// Get current User based on current token
  ///
  /// Can throw [UserNotFound]
  Future<User> getCurrentUserFromToken() => _usersApi.getCurrentUserFromToken(serverUrl: currentServerUrl);

  /// Get user by his ID
  ///
  /// Can throw [UserNotFound]
  Future<User> getUserById({required String userId}) =>
      _usersApi.getUserById(serverUrl: currentServerUrl, userId: userId);

  /// Get all users from current server
  ///
  /// Can throw [UserNotFound]
  Future<List<User>> getUsers() => _usersApi.getUsers(serverUrl: currentServerUrl);
}
