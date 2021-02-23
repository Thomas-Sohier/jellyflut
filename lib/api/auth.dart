import 'package:dio/dio.dart';
import 'package:jellyflut/api/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/shared/shared.dart';
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
    await setGlobals(authenticationResponse);
  } catch (e) {
    print(e);
    return null;
  }
  return authenticationResponse;
}
