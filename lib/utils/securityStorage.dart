import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStorage {
  static FlutterSecureStorage _storage = new FlutterSecureStorage();

  static Future<void> writeToStorage(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> writeAllToStorage(Map<String, String> valueByKey) async {
    valueByKey.forEach((key, value) {
      _storage.write(key: key, value: value);
    });
  }

  static Future<String> readFromStorage(String key) {
    return _storage.read(key: key);
  }

  static Future<void> deleteFromStorage(String key) {
    return _storage.delete(key: key);
  }

  static Future<void> deleteAllFromStorage() {
    return _storage.deleteAll();
  }

  static Future<Map<String, String>> readAllFromStorage() {
    return _storage.readAll();
  }

  static Future<bool> storageContainsKey(String key) {
    return _storage.containsKey(key: key);
  }
}
