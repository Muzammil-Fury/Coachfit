import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:gomotive/core/app_config.dart';

class Preferences {
  static void setAccessToken(_accessToken) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString("token", _accessToken);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("token");
  }

  static void deleteAccessToken() async {
    token = "";
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("token");
  }
}
