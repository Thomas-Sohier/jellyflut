import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut/api/dio.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/models/settingsDB.dart';
import 'package:jellyflut/models/userDB.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<AuthenticationResponse> login(String username, String password) async {
  var body = <String, dynamic>{};
  body['Username'] = username;
  body['PW'] = password;

  var login = '/Users/AuthenticateByName';
  var headers = <String, dynamic>{};
  headers['Content-Type'] = 'application/json';

  var formData = FormData.fromMap(body);

  dio.options.headers = headers;

  Response response;
  AuthenticationResponse authenticationResponse;
  try {
    response = await dio.post('${server.url}${login}', data: formData);
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
  var databaseService = DatabaseService();
  var serverId = await databaseService.insertServer(server);
  var settingId = await databaseService.insertSettings(SettingsDB());
  userDB = UserDB(
      settingsId: settingId,
      serverId: serverId,
      name: name,
      apiKey: authenticationResponse.accessToken);
  var userId = await databaseService.insertUser(userDB);
  userDB.id = userId;
  await saveToSharedPreferences(serverId, settingId,
      authenticationResponse.user.id, authenticationResponse.accessToken);
  await saveToGlobals();
}

Future<void> saveToSharedPreferences(
    int serverId, int settingId, String userId, String apiKey) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString('apiKey', apiKey);
  await sharedPreferences.setBool('isLoggedIn', true);
  await sharedPreferences.setInt('serverId', serverId);
  await sharedPreferences.setInt('settingId', settingId);
  await sharedPreferences.setString('userId', userId);
  await sharedPreferences.setInt('userDBID', userDB.id);
}

Future<void> saveToGlobals() async {
  var databaseService = DatabaseService();
  var sharedPreferences = await SharedPreferences.getInstance();
  var serverID = sharedPreferences.getInt('serverId');
  server = await databaseService.getServer(serverID);
  var userDBID = sharedPreferences.getInt('userDBID');
  userDB = await databaseService.getUser(userDBID);
  apiKey = sharedPreferences.getString('apiKey');
  var userID = sharedPreferences.getString('userId');
  user = await getUserById(userID: userID);
}
