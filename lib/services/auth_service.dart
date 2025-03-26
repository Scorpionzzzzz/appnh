import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  static Future<void> saveLoggedInUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastLoggedInUser', username);
  }

  static Future<String?> getLastLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastLoggedInUser');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastLoggedInUser');
  }
} 