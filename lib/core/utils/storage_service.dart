import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Private constructor
  StorageService._internal();
  // Static instance
  static final StorageService _instance = StorageService._internal();
  // Factory constructor to return the same instance
  factory StorageService() {
    return _instance;
  }

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  static const String _tokenKey = 'token';

  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  Future<void> saveToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_tokenKey);
  }

  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
