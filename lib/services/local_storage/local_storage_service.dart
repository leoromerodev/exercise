import "dart:developer";
import "package:shared_preferences/shared_preferences.dart";

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static LocalStorageService? _instance;

  static LocalStorageService get instance {
    _instance ??= LocalStorageService._privateConstructor();
    return _instance!;
  }

  Future<void> writeString({required String key, required String value}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString(key, value);
    log('String written to local storage');
  }

  Future<String?> readString({required String key}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(key);
  }

  Future<void> deleteKey({required String key}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(key);
    log('deleted from local storage');
  }
}
