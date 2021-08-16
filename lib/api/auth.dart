import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/dio.dart';
import 'package:jellyflut/api/interceptor.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/screens/start/loginForm.dart';
import 'package:jellyflut/screens/start/parentStart.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthenticationResponse> login(String username, String password) async {
  final login = '/Users/authenticatebyname';
  final data = jsonEncode({'Username': username, 'Pw': password});
  final authEmby = await authHeader();

  Response response;
  AuthenticationResponse authenticationResponse;
  try {
    response = await dio.post('${server.url}$login',
        data: data,
        // X-Emby-Authorization needs to be set manually here
        // I don't know why...
        options: Options(headers: {'X-Emby-Authorization': authEmby}));
    authenticationResponse = AuthenticationResponse.fromMap(response.data);
  } on DioError catch (dioError, stacktrace) {
    log(dioError.message, stackTrace: stacktrace, level: 5);
    rethrow;
  } catch (e, stacktrace) {
    log(e.toString(), stackTrace: stacktrace, level: 5);
    rethrow;
  }
  return authenticationResponse;
}

void create(String name, AuthenticationResponse authenticationResponse) async {
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
  await saveToSharedPreferences(serverId, settingsId, userId,
      authenticationResponse.user.id, authenticationResponse.accessToken);
  await saveToGlobals();
}

Future<void> saveToSharedPreferences(int serverId, int settingId, int userAppId,
    String userJellyfinId, String apiKey) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('apiKey', apiKey);
  await sharedPreferences.setBool('isLoggedIn', true);
  await sharedPreferences.setInt('serverId', serverId);
  await sharedPreferences.setInt('settingId', settingId);
  await sharedPreferences.setString('userJellyfinId', userJellyfinId);
  await sharedPreferences.setInt('userAppId', userAppId);
}

Future<void> saveToGlobals() async {
  final db = AppDatabase().getDatabase;
  final sharedPreferences = await SharedPreferences.getInstance();
  final serverID = sharedPreferences.getInt('serverId');
  server = await db.serversDao.getServerById(serverID!);
  final userAppId = sharedPreferences.getInt('userAppId');
  userApp = await db.usersDao.getUserById(userAppId!);
  apiKey = sharedPreferences.getString('apiKey');
  final userJellyfinId = sharedPreferences.getString('userJellyfinId');
  userJellyfin = await getUserById(userID: userJellyfinId!);
}

/// Reset every fields
Future<void> logout() async {
  // delete from database
  final sharedPreferences = await SharedPreferences.getInstance();
  // final userJellyfinId = sharedPreferences.getString('userJellyfinId');
  // final db = AppDatabase().getDatabase;
  // final userAppId = sharedPreferences.getInt('userAppId');
  // final serverId = await db.serversDao.createServer(serverCompanion);
  // final settingsId = await db.settingsDao.createSettings(SettingsCompanion());
  // final userCompanion = await db.usersDao.(userAppId!);
  // final userId = await db.usersDao.deleteUser(userCompanion);

  // delete preferences
  server = Server(id: 0, url: 'http://localhost', name: 'localhost');
  userApp = null;
  apiKey = null;
  userJellyfin = null;
  await sharedPreferences.clear().then((_) => Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => ParentStart())));
}
