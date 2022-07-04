import 'dart:convert';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:universal_io/io.dart';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_repository/users_repository.dart';

class AuthService {
  static Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      // If error then we clear prefs
      try {
        await _saveToGlobals();
      } catch (e) {
        await prefs.clear();
        return false;
      }

      // If account still authorized (API do not respond 401) then we continue
      // else we return false
      return await _isAccountStillAuthorized().then<bool>((value) async {
        // If error 401 then we can contact server and we don't have access to API
        // else we define status as offline mode
        if (value.statusCode == HttpStatus.unauthorized) {
          await logout();
          return false;
        } else if (value.statusCode == HttpStatus.ok) {
          offlineMode = false;
          return true;
        } else {
          offlineMode = true;
          return true;
        }
      }).catchError((onError) {
        // If we catch an error (host lookup or anything else) we still continue
        // to respond as if user is authenticated to go in offline mode
        offlineMode = true;
        return true;
      });
    }
    return false;
  }

  static Future<void> storeAccountData(
      String name, Server server, AuthenticationResponse authenticationResponse, String password) async {
    final db = AppDatabase().getDatabase;

    final serverId = await createOrGetServer(server);
    final userId = await createOrGetUser(name, authenticationResponse, password, serverId);
    final user = await db.usersAppDao.getUserById(userId);
    await _saveToSharedPreferences(user.serverId, user.settingsId, user.id, authenticationResponse);
    return await _saveToGlobals();
  }

  static Future<int> createOrGetServer(final Server server) async {
    final db = AppDatabase().getDatabase;

    return db.serversDao.getServerByUrl(server.url).then((value) => value.id).catchError((e) {
      // Create server if not present
      final serverCompanion = ServersCompanion.insert(url: server.url, name: server.name);
      return db.serversDao.createServer(serverCompanion);
    });
  }

  static Future<int> createOrGetUser(
      String name, AuthenticationResponse authenticationResponse, String password, int serverId) async {
    final db = AppDatabase().getDatabase;
    return db.usersAppDao.getUserByNameAndServerId(name, serverId).then((value) => value.id).catchError((e) async {
      // Create default settings if not present
      final settingsCompanion = SettingsCompanion.insert();
      final settingsId = await db.settingsDao.createSettings(settingsCompanion);

      // Create default user if not present
      final userCompanion = UserAppCompanion.insert(
          name: name,
          password: password,
          apiKey: authenticationResponse.accessToken,
          settingsId: Value(settingsId),
          serverId: Value(serverId));
      return db.usersAppDao.createUser(userCompanion);
    });
  }

  static Future<void> _saveToSharedPreferences(
      int serverId, int settingId, int userAppId, AuthenticationResponse authenticationResponse) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('apiKey', authenticationResponse.accessToken);
    await sharedPreferences.setBool('isLoggedIn', true);
    await sharedPreferences.setInt('serverId', serverId);
    await sharedPreferences.setInt('settingId', settingId);
    await sharedPreferences.setString('user', json.encode(authenticationResponse.user.toMap()));
    await sharedPreferences.setInt('userAppId', userAppId);
  }

  static Future<void> _saveToGlobals() async {
    final db = AppDatabase().getDatabase;
    final sharedPreferences = await SharedPreferences.getInstance();
    final serverId = sharedPreferences.getInt('serverId');
    server = await db.serversDao.getServerById(serverId!);
    final userAppId = sharedPreferences.getInt('userAppId');
    userApp = await db.usersAppDao.getUserById(userAppId!);
    apiKey = sharedPreferences.getString('apiKey');
    final user = User.fromMap(json.decode(sharedPreferences.getString('user')!));
    userJellyfin = user;
    return;
  }

  static Future<void> _removeGlobals() async {
    // delete globals variable
    server = Server(id: 0, url: 'http://localhost', name: 'localhost');
    userApp = null;
    apiKey = null;
    userJellyfin = null;
    return;
  }

  static Future<void> _removeSharedPreferences() async {
    // get shared preferences instance
    final sharedPreferences = await SharedPreferences.getInstance();
    // delete shared preferences
    // reset state of authentication bloc
    // then redirect to login page
    await sharedPreferences.clear();
  }

  static Future<Response> _isAccountStillAuthorized() async {
    final authKeys = '/Auth/Keys';
    return dio.get('${server.url}$authKeys');
  }

  /// Reset every fields
  static Future<void> logout() async {
    await _removeGlobals();
    await _removeSharedPreferences();
    HomeCategoryProvider().clear();
    MusicProvider().reset();
    BlocProvider.of<AuthBloc>(customRouter.navigatorKey.currentContext!).add(ResetStates());
    await AutoRouter.of(customRouter.navigatorKey.currentContext!).replace(AuthParentRoute());
  }

  static Future<void> changeUser(
    final String username,
    final String password,
    final String serverUrl,
    final int serverId,
    final int settingsId,
    final int userId,
  ) async {
    // Try to connect first
    // If there is an error then an exception is thrown
    // or we juste flush all data on connect with second account
    final response = await customRouter.navigatorKey.currentContext!
        .read<UsersRepository>()
        .login(username: username, password: password, serverUrl: serverUrl);
    await _removeGlobals();
    await _removeSharedPreferences();
    await _saveToSharedPreferences(serverId, settingsId, userId, response);
    await _saveToGlobals();
    HomeCategoryProvider().clear();
    MusicProvider().reset();
    await AutoRouter.of(customRouter.navigatorKey.currentContext!).replace(HomeRouter());
  }
}
