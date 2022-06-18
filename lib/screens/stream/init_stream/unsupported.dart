import 'package:flutter/cupertino.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class InitStreamingItemUtil {
  static Future<Widget> initFromItem({required Item item}) async {
    throw UnsupportedError(
        'No suitable player controller implementation was found.');
  }

  static Future<dynamic> initControllerFromItem({required Item item}) async {
    throw UnsupportedError(
        'No suitable player controller implementation was found.');
  }
}

class InitStreamingUrlUtil {
  static Future<Widget> initFromUrl(
      {required String url, required String streamName}) async {
    throw UnsupportedError(
        'No suitable player controller implementation was found.');
  }

  static Future<dynamic> initControllerFromUrl(
      {required String url, required String streamName}) async {
    throw UnsupportedError(
        'No suitable player controller implementation was found.');
  }
}
