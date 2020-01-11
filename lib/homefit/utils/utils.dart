import 'package:flutter/material.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/utils/preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';

class Utils {
  static void showInSnackBar(
      GlobalKey<ScaffoldState> _scaffoldKey, String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  static String getDeviceType() {
    if(Platform.isIOS) {
      return "ios";
    } else if(Platform.isAndroid) {
      return "android";
    } else {
      return null;
    }
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

  static Future<int> alertDialog(BuildContext context, String title, String content) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            title,
          ),
          content: new Text(content),
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new RaisedButton(
                    child: new Text(
                      'OK',
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: dhfYellow,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static Future<int> confirmDialog(
    BuildContext context, 
    String title, 
    String content,
    String okButton,
    String cancelButton
  ) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            title,
          ),
          content: new Text(content),
          actions: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new RaisedButton(
                    child: new Text(
                      okButton,
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: dhfYellow,
                    onPressed: () {
                      Navigator.of(context).pop(1); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: new RaisedButton(
                    child: new Text(
                      cancelButton,
                      style: new TextStyle(color: Colors.black),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(0); // Pops the confirmation dialog but not the page.
                    },
                  ),
                ),                  
              ],
            ),
          ],
        );
      },
    ) ??
    0;
  }

  static void userSignout() {
    token = null;
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

  static String convertDateToDisplayString(DateTime date){
    return new DateFormat.yMMMMd("en_US").format(date);
  }

  static String convertDateToValueString(DateTime date){
    return new DateFormat("yyyy-MM-dd").format(date);
  }

  static Widget drawWorkout(
    BuildContext context, 
    Map workout, 
    Map user, 
    double width, 
    double height
  ) {    
    return new Container(      
      width: width,
      height: height,      
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage(workout["thumbnail_url"]),
          fit: BoxFit.cover,
        ),
      ),
      child: new Stack(
        children: <Widget>[            
          new Positioned(
            left: 0.0,
            bottom: 0.0,
            child: new Container(
              width: width,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.black54
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    workout["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600
                    )
                  ),                  
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        "Duration: " + workout["workout_duration"].toString() + " min ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300
                        )
                      ),
                      workout['mobility_duration'] > 0 ?
                        new Container(
                          width: 24.0,
                          height: 24.0,
                          child: new Image.asset(
                            "assets/images/mobility.png",
                            color: Colors.lightBlue
                          ),
                        )
                      : new Container(),
                      workout['strength_duration'] > 0 ?
                        new Container(
                          width: 24.0,
                          height: 24.0,
                          child: new Image.asset(
                            "assets/images/strength.png",
                            color: Colors.lightGreen
                          ),
                        )
                      : new Container(),
                      workout['metabolic_duration'] > 0 ?
                        new Container(
                          width: 24.0,
                          height: 24.0,
                          child: new Image.asset(
                            "assets/images/metabolic.png",
                            color: Colors.yellow
                          ),
                        )
                      : new Container(),
                      workout['power_duration'] > 0 ?
                        new Container(
                          width: 24.0,
                          height: 24.0,
                          child: new Image.asset(
                            "assets/images/power.png",
                            color: Colors.red
                          ),
                        )
                      : new Container(),
                    ],
                  )      
                ],
              ),
            ),            
          )
        ],
      )
    );
  }

  static Widget drawMenu(BuildContext context, String _currentMenu) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            if(_currentMenu != "home") {
              Navigator.of(context).pushNamed("/dashboard"); 
            }
          },
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: new Text(
              "Home",
              style: new TextStyle(
                fontSize: 36.0,
                color: _currentMenu == "home" ? dhfYellow : Colors.black
              ),
            ),
          ),
        ),
        new GestureDetector(
          onTap: () {     
            if(_currentMenu != "workouts") {
              Navigator.of(context).pushNamed("/workouts"); 
            }
          },
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: new Text(
              "Workouts",
              style: new TextStyle(
                fontSize: 36.0,
                color: _currentMenu == "workouts" ? dhfYellow : Colors.black
              ),
            ),
          ),
        ),        
        token != null && token != ""? 
          new GestureDetector(
            onTap: () {    
              if(_currentMenu != "subscribe") {                                
                Navigator.of(context).pushNamed("/my_plan");                                   
              }
            },
            child: new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: new Text(
                "Subscribe",
                style: new TextStyle(
                  fontSize: 36.0,
                  color: _currentMenu == "subscribe" ? dhfYellow : Colors.black
                ),
              ),
            )
          )
          : new Container(),
        token != null && token != ""? 
          new GestureDetector(
            onTap: () {     
              if(_currentMenu != "profile") {
                Navigator.of(context).pushNamed("/user_ipad");                                   
              }
            },
            child: new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: new Text(
                "Profile",
                style: new TextStyle(
                  fontSize: 36.0,
                  color: _currentMenu == "profile" ? dhfYellow : Colors.black
                ),
              ),
            ),
          )
          : new Container()
      ],
    );
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
