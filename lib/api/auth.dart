import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut/api/dio.dart';
import 'package:jellyflut/api/interceptor.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthenticationResponse> login(String username, String password) async {
  var login = '/Users/authenticatebyname';
  var data = jsonEncode({'Username': username, 'Pw': password});
  var authEmby = await authHeader();

  Response response;
  AuthenticationResponse authenticationResponse;
  try {
    response = await dio.post('${server.url}$login',
        data: data,
        // X-Emby-Authorization needs to be set manually here
        // I don't know why...
        options: Options(headers: {'X-Emby-Authorization': authEmby}));
    authenticationResponse = AuthenticationResponse.fromMap(response.data);
  } on DioError catch (dioError, _) {
    log(dioError.message);
    return Future.error(dioError.error);
  } catch (e) {
    log(e);
    return Future.error(e);
  }
  return authenticationResponse;
}

void create(String name, AuthenticationResponse authenticationResponse) async {
  var db = AppDatabase().getDatabase;
  var serverCompanion =
      ServersCompanion.insert(url: server.url, name: server.name);

  var serverId = await db.serversDao.createServer(serverCompanion);
  var settingsId = await db.settingsDao.createSettings(SettingsCompanion());

  var userCompanion = UsersCompanion.insert(
      name: name,
      apiKey: authenticationResponse.accessToken,
      settingsId: settingsId,
      serverId: serverId);
  var userId = await db.usersDao.createUser(userCompanion);
  await saveToSharedPreferences(serverId, settingsId, userId,
      authenticationResponse.user.id, authenticationResponse.accessToken);
  await saveToGlobals();
}

Future<void> saveToSharedPreferences(int serverId, int settingId, int userAppId,
    String userJellyfinId, String apiKey) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('apiKey', apiKey);
  await sharedPreferences.setBool('isLoggedIn', true);
  await sharedPreferences.setInt('serverId', serverId);
  await sharedPreferences.setInt('settingId', settingId);
  await sharedPreferences.setString('userJellyfinId', userJellyfinId);
  await sharedPreferences.setInt('userAppId', userAppId);
}

Future<void> saveToGlobals() async {
  var db = AppDatabase().getDatabase;
  var sharedPreferences = await SharedPreferences.getInstance();
  var serverID = sharedPreferences.getInt('serverId');
  server = await db.serversDao.getServerById(serverID);
  var userAppId = sharedPreferences.getInt('userAppId');
  userApp = await db.usersDao.getUserById(userAppId);
  apiKey = sharedPreferences.getString('apiKey');
  var userJellyfinId = sharedPreferences.getString('userJellyfinId');
  userJellyfin = await getUserById(userID: userJellyfinId);
}
