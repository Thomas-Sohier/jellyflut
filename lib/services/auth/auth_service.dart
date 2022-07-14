import 'dart:convert';
import 'package:authentication_repository/authentication_repository.dart' hide User;
import 'package:jellyflut/services/dio/dio_helper.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart' hide Server;
import 'package:universal_io/io.dart';

import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final user = await db.userAppDao.getUserById(userId);
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
    return db.userAppDao.getUserByNameAndServerId(name, serverId).then((value) => value.id).catchError((e) async {
      // Create default settings if not present
      final settingsCompanion = SettingsCompanion.insert();
      final settingsId = await db.settingsDao.createSettings(settingsCompanion);

      // Create default user if not present
      final userCompanion = UserAppCompanion.insert(
          name: name,
          password: password,
          apiKey: authenticationResponse.accessToken,
          jellyfinUserId: authenticationResponse.user.id,
          settingsId: Value(settingsId),
          serverId: Value(serverId));
      return db.userAppDao.createUser(userCompanion);
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
    userApp = await db.userAppDao.getUserById(userAppId!);
    apiKey = sharedPreferences.getString('apiKey');
    final user = User.fromMap(json.decode(sharedPreferences.getString('user')!));
    userJellyfin = user;
    return;
  }

  static Future<Response> _isAccountStillAuthorized() async {
    final authKeys = '/Auth/Keys';
    return dio.get('${server.url}$authKeys');
  }

  /// Reset every fields
  static Future<void> logout() async {
    // final context = context.router.root.navigatorKey.currentContext!;
    // HomeCategoryProvider().clear();
    // await context.read<MusicPlayerRepository>().reset();
    // BlocProvider.of<AuthBloc>(context).add(ResetStates());
    // await AutoRouter.of(context).push(r.AuthRouter());
  }

  static Future<void> changeUser(
    final String username,
    final String password,
    final String serverUrl,
    final String serverName,
    final int serverId,
    final int settingsId,
    final int userId,
  ) async {
    // Try to connect first
    // If there is an error then an exception is thrown
    // or we juste flush all data on connect with second account
    // final context = context.router.root.navigatorKey.currentContext!;
    // await context.read<AuthenticationRepository>().logIn(
    //       username: username,
    //       password: password,
    //       serverUrl: serverUrl,
    //       serverName: serverName,
    //     );
    // HomeCategoryProvider().clear();
    // await context.read<MusicPlayerRepository>().reset();
    // await AutoRouter.of(context).replace(r.HomeRouter());
    throw UnimplementedError('Need to FIX this method');
  }
}
