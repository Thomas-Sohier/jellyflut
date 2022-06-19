import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late final SharedPreferences _sharedPrefs;

  SharedPreferences get sharedPrefs => _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    if (_sharedPrefs.getBool('isLoggedIn') ?? false) {
      await _sharedPrefs.setBool('isLoggedIn', true);
    }
  }
}

final sharedPrefs = SharedPrefs();
