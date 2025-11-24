import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future<void> saveCredentials(String email, String password) async {
    await _saveCredentials(email, password);
  }

  Future<Map<String, String>?> getCredentials() async {
    return await _getCredentials();
  }

  Future<void> deleteCredentials() async {
    await _deleteCredentials();
  }

  Future<void> _saveCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String>?> _getCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (email == null || password == null) return null;

    return {
      'email': email,
      'password': password,
    };
  }

  Future<void> _deleteCredentials() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }
}
