import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences _sharedPrefs;

  static SharedPreferences get sharedPrefs => _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  static Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }
}

const sharedPrefs = SharedPrefs;
