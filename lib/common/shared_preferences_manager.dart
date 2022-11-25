
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final _manager = SharedPreferencesManager._internal();

  factory SharedPreferencesManager() => _manager;

  SharedPreferencesManager._internal();

  SharedPreferences? _prefs;

  Future init() async{
    await SharedPreferences.getInstance().then((value){
      _prefs = value;
    });
  }

  Future remove(String key) async{
    await _prefs?.remove(key);
  }

  Future<void> setString(String key, String value) async{
    await _prefs?.setString(key, value);
  }

  Future<String?> getString(String key) async{
    return _prefs?.getString(key);
  }
}

const phoneKey = 'phoneKey';


final sharedPrefs = SharedPreferencesManager();
