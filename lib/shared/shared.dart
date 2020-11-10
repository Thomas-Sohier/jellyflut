import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/authenticationResponse.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/server.dart';
import 'package:jellyflut/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<bool> isAuth() async {
  var prefs = await SharedPreferences.getInstance();
  var isLogged = await isLoggedIn();
  var s = await getLastUsedServer();
  if (isLogged && s != null) {
    server = s;
    var _user = User();
    _user.id = prefs.getString('userId');
    user = _user;
    apiKey = prefs.getString('apiKey');
    return true;
  }
  return false;
}

void setServer(Server s) {
  server = s;
}

Future<Server> getLastUsedServer() async {
  var databaseService = DatabaseService();
  var prefs = await SharedPreferences.getInstance();
  return prefs.getInt('serverId') != null
      ? databaseService.getServer(prefs.getInt('serverId'))
      : null;
}

void setGlobals(AuthenticationResponse response) async {
  // Permet de rendre les informations nécessaires global
  user = response.user;
  apiKey = response.accessToken;

  // Permet de garder la personne connecté
  var prefs = await SharedPreferences.getInstance();
  await prefs?.setBool('isLoggedIn', true);
  await prefs?.setString('apiKey', apiKey);
  await prefs?.setString('userId', user.id);
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

double aspectRatio({String type}) {
  if (type == 'MusicAlbum') {
    return 1 / 1;
  }
  if (type == 'Backdrop') {
    return 16 / 9;
  }
  return 2 / 3;
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String removeAllHtmlTags(String htmlText) {
  var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

String getCollectionItemType(String collectionType) {
  if (collectionType == 'movies') {
    return 'movie';
  } else if (collectionType == 'tvshows') {
    return 'Series';
  } else if (collectionType == 'music') {
    return 'MusicAlbum';
  } else if (collectionType == 'books') {
    return 'Book';
  } else {
    return '';
  }
}

String returnImageId(Item item) {
  if (item.type == 'Season' || item.type == 'Episode') {
    return item.seriesId;
  }
  return item.id;
}

String correctImageTags(Item item, {String type = 'Primary'}) {
  if (type.toLowerCase().trim() == 'logo' &&
      (item.type == 'Season' ||
          item.type == 'Episode' ||
          item.type == 'Album')) {
    if (item.type == 'Season' || item.type == 'Episode') {
      return item.seriesPrimaryImageTag;
    } else if (item.type == 'Album') {
      return item.albumPrimaryImageTag;
    }
  } else if (item.imageTags
      .toMap()
      .values
      .every((element) => element == null)) {
    if (item.type == 'Season') {
      return item.seriesPrimaryImageTag;
    } else if (item.type == 'Album') {
      return item.albumPrimaryImageTag;
    } else {
      return null;
    }
  } else {
    return item.imageTags.primary;
  }
}

String correctImageId(Item item, {String type = 'Primary'}) {
  if (type.toLowerCase().trim() == 'logo' &&
      (item.type == 'Season' ||
          item.type == 'Episode' ||
          item.type == 'Album')) {
    if (item.type == 'Season' || item.type == 'Episode') {
      return item.seriesId;
    } else if (item.type == 'Album') {
      return item.albumId;
    }
  } else if (item.imageTags
      .toMap()
      .values
      .every((element) => element == null)) {
    if (item.type == 'Season') {
      return item.seriesId;
    } else if (item.type == 'Album') {
      return item.albumId;
    } else {
      return item.id;
    }
  } else {
    return item.id;
  }
}
