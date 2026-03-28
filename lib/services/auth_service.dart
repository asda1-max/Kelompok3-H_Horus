import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usernameKey = 'auth_username';
  static const _passwordKey = 'auth_password';

  /// Cek apakah user sudah pernah register.
  static Future<bool> hasRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) != null &&
        prefs.getString(_passwordKey) != null;
  }

  /// Simpan akun baru dari halaman register.
  static Future<void> register({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username.trim());
    await prefs.setString(_passwordKey, password);
  }

  /// Validasi login dengan akun yang sudah diregister.
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_usernameKey);
    final savedPassword = prefs.getString(_passwordKey);

    return username.trim() == savedUsername && password == savedPassword;
  }
}
