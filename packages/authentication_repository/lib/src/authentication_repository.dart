import 'dart:async';
import 'dart:convert';

import 'package:authentication_api/authentication_api.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_database/sqlite_database.dart' hide Server;

import 'models/server.dart';

/// {@template authentication_repository}
/// A repository that handles auth related requests
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository._(
      {required AuthenticationApi authenticationApi,
      required SharedPreferences sharedPreferences,
      required Dio dioClient,
      required Database database})
      : _authenticationApi = authenticationApi,
        _sharedPreferences = sharedPreferences,
        _dioClient = dioClient,
        _database = database;

  static Future<AuthenticationRepository> create(
      {required AuthenticationApi authenticationApi,
      required SharedPreferences sharedPreferences,
      required Dio dioClient,
      required Database database}) async {
    final authenticationRepository = AuthenticationRepository._(
      authenticationApi: authenticationApi,
      sharedPreferences: sharedPreferences,
      dioClient: dioClient,
      database: database,
    );
    await authenticationRepository._initListeners();
    return authenticationRepository;
  }

  final AuthenticationApi _authenticationApi;
  final SharedPreferences _sharedPreferences;
  final Dio _dioClient;
  final Database _database;

  // Stream of user and server when state change
  final StreamController<User> _userStream = StreamController<User>.broadcast();
  final StreamController<Server> _serverStream = StreamController<Server>.broadcast();

  // Shared preferences key
  final String _spUserKey = 'authentication_repository_user';
  final String _spServerKey = 'authentication_repository_server';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user => _userStream.stream;

  /// Returns the current cached user.
  /// If there is no cached user then a [NoCurrentUserException] is thrown
  User get currentUser => _getSharedPrefUser();

  /// Stream of [Server] which will emit the current server when
  /// the authentication state changes.
  ///
  /// Emits [Server.empty] if the server is not defined yet.
  Stream<Server> get server => _serverStream.stream;

  /// Returns the current cached server.
  /// If there is no cached server then a [NoCurrentServerException] is thrown
  Server get currentServer => _getSharedPreServer();

  Future<void> _initListeners() {
    _serverStream.stream.listen(_setSharedPrefServer);
    _userStream.stream.listen((user) async {
      await _setSharedPrefUser(user);
      await _setDioInterceptor(user);
    });
    return _setDioInterceptor(currentUser);
  }

  Future<void> _setDioInterceptor(User user) async {
    final tokenInterceptor = await _authenticationApi.generateToken(accessToken: user.token);
    final dioInterceptor =
        QueuedInterceptorsWrapper(onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) async {
      requestOptions.queryParameters.addAll(tokenInterceptor.queryParameters);
      requestOptions.headers.addAll(tokenInterceptor.headers);
      handler.next(requestOptions);
    });
    _dioClient.interceptors.removeWhere((i) => i is QueuedInterceptorsWrapper);
    _dioClient.interceptors.add(dioInterceptor);
  }

  /// Login a user to defined endpoint
  /// A server URL need o be defined as backend can vary
  ///
  /// Can throw [AuthenticationFailure]
  Future<void> logIn(
      {required String serverName,
      required String serverUrl,
      required String username,
      required String password}) async {
    final user = await _authenticationApi.logIn(
      serverName: serverName,
      serverUrl: serverUrl,
      username: username,
      password: password,
    );
    try {
      final serverId = await _createOrGetServer(serverUrl, serverName);
      final uri = Uri.parse(serverUrl);
      final server = Server(
        id: serverId,
        name: serverName,
        host: uri.host,
        port: uri.port,
        scheme: uri.scheme,
      );
      await _createOrGetUser(
        user.id,
        user.username,
        user.token,
        password,
        serverId,
      );

      // Notify new user and server
      _userStream.add(user);
      _serverStream.add(server);
    } catch (_) {
      throw AuthenticationStorageException();
    }
  }

  /// Logout a user to the defined endpoint
  Future<void> logout() async {
    await _authenticationApi.logout(serverUrl: currentServer.url);

    // Notify user disconnected
    _userStream.add(User.empty);
    _serverStream.add(Server.empty);
  }

  /// Get list of users for server
  /// [serverId] id from local sqlite database
  Future<List<UserAppData>> getUsersForServerId(int serverId) async {
    return _database.userAppDao.getUserAppByserverId(serverId);
  }

  /// Try to get server with url, if it exist then return it's [id]. If it doesn't exist
  /// then it create it and return it"s [id]
  Future<int> _createOrGetServer(String serverUrl, String serverName) async {
    return _database.serversDao.getServerByUrl(serverUrl).then((value) => value.id).catchError((e) {
      // Create server if not present
      final serverCompanion = ServersCompanion.insert(url: serverUrl, name: serverName);
      return _database.serversDao.createServer(serverCompanion);
    });
  }

  /// Try to get user with it's [username] and [serverId], if it exist then return it's [id]. If it doesn't exist
  /// then it :
  /// - create default settings
  /// - create user
  /// - return user's [id]
  Future<int> _createOrGetUser(String id, String name, String? token, String password, int serverId) async {
    return _database.userAppDao
        .getUserByNameAndServerId(name, serverId)
        .then((value) => value.id)
        .catchError((e) async {
      // Create default settings if not present
      final settingsCompanion = SettingsCompanion.insert();
      final settingsId = await _database.settingsDao.createSettings(settingsCompanion);

      // Create default user if not present
      final userCompanion = UserAppCompanion.insert(
          name: name,
          password: password,
          apiKey: token ?? '',
          jellyfinUserId: id,
          settingsId: Value(settingsId),
          serverId: Value(serverId));
      return _database.userAppDao.createUser(userCompanion);
    });
  }

  // Helper

  User _getSharedPrefUser() {
    final userAsString = _sharedPreferences.getString(_spUserKey);
    if (userAsString == null) return User.empty;
    return User.fromJson(jsonDecode(userAsString));
  }

  Future<void> _setSharedPrefUser(User user) => _sharedPreferences.setString(_spUserKey, json.encode(user.toJson()));

  Server _getSharedPreServer() {
    final serverAsString = _sharedPreferences.getString(_spServerKey);
    if (serverAsString == null) return Server.empty;
    return Server.fromJson(jsonDecode(serverAsString));
  }

  Future<void> _setSharedPrefServer(Server server) =>
      _sharedPreferences.setString(_spServerKey, json.encode(server.toJson()));
}

/// Error thrown when there is no current user saved in shared preferences
class NoCurrentUserException implements Exception {}

/// Error thrown when there is no current server saved in shared preferences
class NoCurrentServerException implements Exception {}

/// Error thrown when there is an error while storing auth infos
class AuthenticationStorageException implements Exception {}
