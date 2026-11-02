import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Model User
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class ApiService {
  static const String _baseUrl = 'https://reqres.in/api'; // ATAU URL API kamu
  static const String _jsonplaceholderUrl = 'https://jsonplaceholder.typicode.com';

  // 1. DUA METHOD LOGIN YANG DIPANGGIL LOGIN SCREEN
  Future<String> login(String email, String password) async {
    try {
      // Mengirim POST request ke endpoint login
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Mengembalikan token (sesuai respon API, contoh: data['token'])
        return data['token'] ?? 'dummy_token_12345';
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Gagal login, periksa kembali email & password');
      }
    } on TimeoutException {
      throw Exception('Request timeout saat login. Periksa koneksi internet Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }


  Future<List<User>> getUsers({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$_jsonplaceholderUrl/users'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat data (Status: ${response.statusCode})',
        );
      }
    } on TimeoutException {
      final durasiTeks = timeout.inSeconds > 0
          ? '${timeout.inSeconds} detik'
          : '${timeout.inMilliseconds} milidetik';

      throw Exception(
        'Request timeout setelah $durasiTeks. Periksa koneksi internet Anda.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}