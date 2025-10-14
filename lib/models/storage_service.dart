import 'package:shared_preferences/shared_preferences.dart';

// Kelas ini mengelola semua interaksi dengan penyimpanan lokal perangkat.
class StorageService {
  static const _tokenKey = 'auth_token';

  /// Menyimpan token autentikasi ke SharedPreferences.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Mengambil token autentikasi dari SharedPreferences.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Menghapus token autentikasi dari SharedPreferences.
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

// Anda bisa menambahkan fungsi lain di sini, misalnya untuk menyimpan data air minum, dll.
}
