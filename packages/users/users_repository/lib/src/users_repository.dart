import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:users_api/users_api.dart';

/// {@template users_repository}
/// A repository that handles items related requests
/// {@endtemplate}
class UsersRepository {
  /// {@macro users_repository}
  const UsersRepository({required UsersApi usersApi}) : _usersApi = usersApi;

  final UsersApi _usersApi;

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
}
