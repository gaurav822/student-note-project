import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyAccess = 'access';
  static const _keyRefresh = 'refresh';
  static const _gAuthKey = 'gauthkey';

  static Future setUserDetails(
      {String username, String email, String access, String refresh}) async {
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  static Future setAccess(String access) async {
    await _storage.write(key: _keyAccess, value: access);
  }

  static Future setRefresh(String refresh) async {
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  static Future<String> getUserName() async =>
      await _storage.read(key: _keyUsername);

  static Future<String> getEmail() async => await _storage.read(key: _keyEmail);

  static Future<String> getAccess() async =>
      await _storage.read(key: _keyAccess);

  static Future<String> getRefresh() async =>
      await _storage.read(key: _keyRefresh);

  static Future clear() async {
    await _storage.deleteAll();
  }

  static Future setGAuthKey(String authKey) async {
    await _storage.write(key: _gAuthKey, value: authKey);
  }

  static Future<String> getGAuthKey() async =>
      await _storage.read(key: _gAuthKey);
}
