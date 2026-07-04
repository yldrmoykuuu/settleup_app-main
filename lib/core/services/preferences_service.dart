import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const _isDarkModeKey = 'isDarkMode';

  Future<bool> loadHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> saveHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  Future<bool> loadIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> saveIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, value);
  }
}
