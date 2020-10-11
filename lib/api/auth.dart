import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

// or new Dio with a BaseOptions instance.
BaseOptions options = new BaseOptions(
  connectTimeout: 30000,
  receiveTimeout: 30000,
);
Dio dio = new Dio(options);

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<AuthenticationResponse> login(String username, String password) async {
  var body = new Map<String, dynamic>();
  body["Username"] = username;
  body["PW"] = password;

  String login = "/Users/AuthenticateByName";
  var headers = new Map<String, dynamic>();
  headers["X-Emby-Authorization"] = await authHeader();
  headers["Content-Type"] = "application/json";

  FormData formData = new FormData.fromMap(body);

  dio.options.headers = headers;

  Response response;
  AuthenticationResponse authenticationResponse;
  try {
    response = await dio.post('${server.url}${login}', data: formData);
    authenticationResponse = AuthenticationResponse.fromMap(response.data);
    await setGlobals(authenticationResponse);
  } catch (e) {
    print(e);
    return null;
  }
  return authenticationResponse;
}
