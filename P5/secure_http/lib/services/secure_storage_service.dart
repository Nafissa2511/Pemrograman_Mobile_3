import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _keyToken = 'auth_token';

  // Menyimpan token ke secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Mengambil token dari secure storage
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Memeriksa apakah token ada
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _keyToken);
    return token != null && token.isNotEmpty;
  }

  // Menghapus token dari secure storage
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}