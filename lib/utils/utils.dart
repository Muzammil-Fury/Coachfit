import 'package:flutter/material.dart';
import 'package:gomotive/utils/preferences.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  
  static void showInSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }


  static void userSignout() {
    token = null;
    selectedUser = null;
    selectedRoleId = null;
    Preferences.deleteAccessToken();
  }

  static List<Map<String, dynamic>> parseList(Map mapObject, String key) {
    List<Map<String, dynamic>> list;
    list = mapObject[key].map<Map<String, dynamic>>((option) {
      return Map<String, dynamic>.from(option);
    }).toList();
    return list;
  }

  static DateTime convertStringToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  static String convertDateStringToDisplayStringDateAndTime(String date) {
    return new DateFormat.yMMMMd("en_US").add_jm().format(DateTime.parse(date));
  }

  static String convertDateStringToDisplayStringDate(String date) {
    return new DateFormat.yMMMMd("en_US").format(DateTime.parse(date));
  }


  static String convertDateToDisplayString(DateTime date){
    return new DateFormat.yMMMMd("en_US").format(date);
  }

  static String convertDateToValueString(DateTime date){
    return new DateFormat("yyyy-MM-dd").format(date);
  }

  static Future<String> getPackageName() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.packageName;
  }

  static Future<String> getDeviceId() async {      
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo; 
      identifier = build.androidId;       
      return identifier;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;        
      identifier = data.identifierForVendor;//UUID for iOS
      return identifier;
    } else {
      return null;
    }   
  }

  static String base64Encode(String inputStr) {
    var bytes = utf8.encode(inputStr);
    var base64Str = base64.encode(bytes);
    return base64Str;
  }

  static Future<Null> launchInWebViewOrVC(url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  
}
