import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  Future<bool> login(String username, String password) async {
    // For development: Mock authentication
    // In production, this would call the real API
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock successful login for any non-empty credentials
    if (username.isNotEmpty && password.isNotEmpty) {
      final mockUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: '$username@necrolight.com',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _currentUser = mockUser;
      await _saveUserToPrefs(mockUser);
      return true;
    }
    
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    // For development: Mock registration
    // In production, this would call the real API
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock successful registration for valid input
    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final mockUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      _currentUser = mockUser;
      await _saveUserToPrefs(mockUser);
      return true;
    }
    
    return false;
  }

  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, user.token);
    await prefs.setString(AppConstants.userIdKey, user.id);
    await prefs.setString(AppConstants.usernameKey, user.username);
    await prefs.setString(AppConstants.emailKey, user.email);
  }

  Future<bool> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    final token = prefs.getString(AppConstants.userTokenKey);
    final id = prefs.getString(AppConstants.userIdKey);
    final username = prefs.getString(AppConstants.usernameKey);
    final email = prefs.getString(AppConstants.emailKey);
    
    if (token != null && id != null && username != null && email != null) {
      _currentUser = User(
        id: id,
        username: username,
        email: email,
        token: token,
      );
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.usernameKey);
    await prefs.remove(AppConstants.emailKey);
  }

  String? getUserToken() {
    return _currentUser?.token;
  }
}
