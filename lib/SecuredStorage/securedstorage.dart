import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyAccess = 'access';
  static const _keyRefresh = 'refresh';

  static Future setUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  static Future<String> getUserName() async =>
      await _storage.read(key: _keyUsername);

  static Future setEmail(String email) async {
    await _storage.write(key: _keyEmail, value: email);
  }

  static Future<String> getEmail() async => await _storage.read(key: _keyEmail);

  static Future setAccess(String access) async {
    await _storage.write(key: _keyAccess, value: access);
  }

  static Future<String> getAccess() async =>
      await _storage.read(key: _keyAccess);

  static Future setRefresh(String refresh) async {
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  static Future<String> getRefresh() async =>
      await _storage.read(key: _keyRefresh);

  static Future clear() async {
    await _storage.delete(key: 'email');
  }
}
