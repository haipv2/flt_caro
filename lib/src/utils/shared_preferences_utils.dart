import 'dart:convert';

import 'package:ticcar5/src/common/common.dart';
import 'package:ticcar5/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonStr = jsonEncode(user);
    prefs.setString(USER_PREFS_KEY, jsonStr);
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonStr = prefs.getString(USER_PREFS_KEY);
    User result = User.fromJson(jsonDecode(jsonStr));
    return result;
  }

  static Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }


}
