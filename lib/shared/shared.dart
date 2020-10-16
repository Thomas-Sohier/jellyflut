import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/server.dart';
import 'package:jellyflut/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<void> init() async {
  isAuth().then((bool resp) => {
        if (resp)
          {navigatorKey.currentState.pushReplacementNamed('/home')}
        else
          {navigatorKey.currentState.pushReplacementNamed('/login')}
      });
}

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn") == null
      ? false
      : prefs.getBool("isLoggedIn");
}

Future<bool> isAuth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogged = await isLoggedIn();
  Server s = await getLastUsedServer();
  if (isLogged && s != null) {
    server = s;
    User _user = new User();
    _user.id = prefs.getString("userId");
    user = _user;
    apiKey = prefs.getString("apiKey");
    return true;
  }
  return false;
}

void setServer(Server s) {
  server = s;
}

Future<Server> getLastUsedServer() async {
  DatabaseService databaseService = new DatabaseService();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt("serverId") != null
      ? databaseService.getServer(prefs.getInt("serverId"))
      : null;
}

setGlobals(AuthenticationResponse response) async {
  // Permet de rendre les informations nécessaires global
  user = response.user;
  apiKey = response.accessToken;

  // Permet de garder la personne connecté
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs?.setBool("isLoggedIn", true);
  prefs?.setString("apiKey", apiKey);
  prefs?.setString("userId", user.id);
}

void showToast(String msg) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[300],
      textColor: Colors.black,
      fontSize: 16.0);
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0)
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  else
    return "$twoDigitMinutes:$twoDigitSeconds";
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

String returnImageId(Item item) {
  if (item.type == "Season" || item.type == "Episode") {
    return item.seriesId;
  }
  return item.id;
}
