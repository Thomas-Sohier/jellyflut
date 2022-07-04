import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class UserService {
  static Future<User> getUserById({required String userID}) async {
    var url = '${server.url}/Users/$userID';

    Response response;
    var currentUser;
    try {
      response = await dio.get(url);
      currentUser = User.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
    return currentUser;
  }

  static Future<User> getCurrentUser() async {
    var url = '${server.url}/Users/${userJellyfin!.id}';

    Response response;
    var currentUser;
    try {
      response = await dio.get(url);
      currentUser = User.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
    return currentUser;
  }
}
