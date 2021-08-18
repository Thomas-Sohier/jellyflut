import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/services/dio/authHeader.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/authenticationResponse.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/user/userservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<AuthenticationResponse> login(
      String username, String password) async {
    final login = '/Users/authenticatebyname';
    final data = jsonEncode({'Username': username, 'Pw': password});
    final authEmby = await authHeader();

    try {
      final response = await dio.post('${server.url}$login',
          data: data,
          // X-Emby-Authorization needs to be set manually here
          // I don't know why...
          options: Options(headers: {'X-Emby-Authorization': authEmby}));
      return AuthenticationResponse.fromMap(response.data);
    } on DioError catch (dioError, stacktrace) {
      log(dioError.message, stackTrace: stacktrace, level: 5);
      rethrow;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      await _saveToGlobals();
      return true;
    }
    return false;
  }

  static Future<void> create(
      String name, AuthenticationResponse authenticationResponse) async {
    final db = AppDatabase().getDatabase;
    final serverCompanion =
        ServersCompanion.insert(url: server.url, name: server.name);

    final serverId = await db.serversDao.createServer(serverCompanion);
    final settingsId = await db.settingsDao.createSettings(SettingsCompanion());

    final userCompanion = UsersCompanion.insert(
        name: name,
        apiKey: authenticationResponse.accessToken,
        settingsId: settingsId,
        serverId: serverId);
    final userId = await db.usersDao.createUser(userCompanion);
    await _saveToSharedPreferences(serverId, settingsId, userId,
        authenticationResponse.user.id, authenticationResponse.accessToken);
    return await _saveToGlobals();
  }

  static Future<void> _saveToSharedPreferences(int serverId, int settingId,
      int userAppId, String userJellyfinId, String apiKey) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('apiKey', apiKey);
    await sharedPreferences.setBool('isLoggedIn', true);
    await sharedPreferences.setInt('serverId', serverId);
    await sharedPreferences.setInt('settingId', settingId);
    await sharedPreferences.setString('userJellyfinId', userJellyfinId);
    await sharedPreferences.setInt('userAppId', userAppId);
  }

  static Future<void> _saveToGlobals() async {
    final db = AppDatabase().getDatabase;
    final sharedPreferences = await SharedPreferences.getInstance();
    final serverID = sharedPreferences.getInt('serverId');
    server = await db.serversDao.getServerById(serverID!);
    final userAppId = sharedPreferences.getInt('userAppId');
    userApp = await db.usersDao.getUserById(userAppId!);
    apiKey = sharedPreferences.getString('apiKey');
    final userJellyfinId = sharedPreferences.getString('userJellyfinId');
    userJellyfin = await UserService.getUserById(userID: userJellyfinId!);
  }

  /// Reset every fields
  static Future<void> logout() async {
    // delete from database
    final sharedPreferences = await SharedPreferences.getInstance();

    // delete preferences
    server = Server(id: 0, url: 'http://localhost', name: 'localhost');
    userApp = null;
    apiKey = null;
    userJellyfin = null;

    await sharedPreferences.clear().then((_) =>
        AutoRouter.of(customRouter.navigatorKey.currentContext!)
            .replace(AuthParentRoute()));
  }
}
