// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SecureStorage {
//   final _storage = FlutterSecureStorage();

//   final _keyToken = 'auth_token';
//   final _keyRefreshToken = 'refresh_token';

//   Future<void> saveToken(String token) async {
//     await _storage.write(key: _keyToken, value: token);
//   }

//   Future<void> saveRefreshToken(String refreshToken) async {
//     await _storage.write(key: _keyRefreshToken, value: refreshToken);
//   }

//   Future<String?> getToken() async {
//     return await _storage.read(key: _keyToken);
//   }

//   Future<String?> getRefreshToken() async {
//     return await _storage.read(key: _keyRefreshToken);
//   }

//   Future<void> deleteToken() async {
//     await _storage.delete(key: _keyToken);
//   }

//   Future<void> clearAll() async {
//     await _storage.deleteAll();
//   }
// }
