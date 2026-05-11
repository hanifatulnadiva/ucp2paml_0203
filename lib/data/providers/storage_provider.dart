import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageProvider {
  final _storage = const FlutterSecureStorage();
  static const _tokenkey = 'jwt_token';

  Future <void> saveToken(String token) async =>
  await _storage.write(key: _tokenkey, value: token);
  Future <String?> getToken() async => await _storage.read(key: _tokenkey);
  Future <void> deleteToken() async => await _storage.delete(key: _tokenkey);
}