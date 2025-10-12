import "dart:developer";
import "package:shared_preferences/shared_preferences.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static LocalStorageService? _instance;

  static LocalStorageService get instance {
    _instance ??= LocalStorageService._privateConstructor();
    return _instance!;
  }

  Future<void> writeString({required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
    log('String written to local storage');
  }

  Future<void> writeSecureString({required String key, required String value}) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: key, value: value);
    log('String written to secure storage');
  }

  Future<String?> readString({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<String?> readSecureString({required String key}) async {
    final secureStorage = FlutterSecureStorage();
    return await secureStorage.read(key: key);
  }

  Future<void> deleteKey({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    log('deleted from local storage');
  }

  Future<void> deleteSecureKey({required String key}) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: key);
    log('deleted from secure storage');
  }
}




