import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/models/jellyfin/user.dart' as jellyfin_user;
import 'package:jellyflut/screens/auth/bloc/auth_bloc.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/services/dio/auth_header.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/authentication_response.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:moor/moor.dart';
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
      switch (dioError.response?.statusCode ?? 500) {
        case 401:
          throw ('Authentication error, check your login, password and server\'s url');
        case 404:
          throw ('Url error, check that your\e using the correct url and/or subpath');
        case 500:
          throw ('Server error, check that you can connect to your server');
        default:
          throw ('Cannot access to the server, check your url and/or your server');
      }
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

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
      String name, AuthenticationResponse authenticationResponse) async {
    final db = AppDatabase().getDatabase;
    final serverCompanion =
        ServersCompanion.insert(url: server.url, name: server.name);

    final serverId = await db.serversDao.createServer(serverCompanion);
    final settingsId = await db.settingsDao.createSettings(SettingsCompanion());

    final userCompanion = UsersCompanion.insert(
        name: name,
        apiKey: authenticationResponse.accessToken,
        settingsId: Value(settingsId),
        serverId: Value(serverId));
    final userId = await db.usersDao.createUser(userCompanion);
    await _saveToSharedPreferences(
        serverId, settingsId, userId, authenticationResponse);
    return await _saveToGlobals();
  }

  static Future<void> _saveToSharedPreferences(int serverId, int settingId,
      int userAppId, AuthenticationResponse authenticationResponse) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'apiKey', authenticationResponse.accessToken);
    await sharedPreferences.setBool('isLoggedIn', true);
    await sharedPreferences.setInt('serverId', serverId);
    await sharedPreferences.setInt('settingId', settingId);
    await sharedPreferences.setString(
        'user', json.encode(authenticationResponse.user.toMap()));
    await sharedPreferences.setInt('userAppId', userAppId);
  }

  static Future<void> _saveToGlobals() async {
    final db = AppDatabase().getDatabase;
    final sharedPreferences = await SharedPreferences.getInstance();
    final serverId = sharedPreferences.getInt('serverId');
    server = await db.serversDao.getServerById(serverId!);
    final userAppId = sharedPreferences.getInt('userAppId');
    userApp = await db.usersDao.getUserById(userAppId!);
    apiKey = sharedPreferences.getString('apiKey');
    final user = jellyfin_user.User.fromMap(
        json.decode(sharedPreferences.getString('user')!));
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
    BlocProvider.of<AuthBloc>(customRouter.navigatorKey.currentContext!)
        .add(ResetStates());
    await AutoRouter.of(customRouter.navigatorKey.currentContext!)
        .replace(AuthParentRoute());
  }
}
