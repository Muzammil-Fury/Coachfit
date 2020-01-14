import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gomotive/utils/external.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gomotive/utils/preferences.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_routes.dart';
import 'package:gomotive/core/app_reducer.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/color_utils.dart';
import 'package:gomotive/auth/views/signin.dart';
import 'package:gomotive/auth/views/verify_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'dart:async';

import 'homefit/core/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  

  bool isInDebugMode = false;
  FlutterError.onError = (FlutterErrorDetails details) {    
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {      
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  await FlutterCrashlytics().initialize(); 
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.getToken().then((String tokenStr) {        
    assert(tokenStr != null); 
    notificationStr = tokenStr;              
  }); 
  
  loadInitialURL = await getInitialLink();
  
  final store = Store<AppState>(
    appReducer,
    initialState: new AppState(),
    middleware: [thunkMiddleware],
  );

  token = await Preferences.getAccessToken();
  deviceId = await Utils.getDeviceId();
  packageName = await Utils.getPackageName();
  partnerSubdomain = packageName.replaceAll(new RegExp("com.gomotive"), "");
  if(partnerSubdomain != "") {
    List<String> partnerSubdomainList = partnerSubdomain.split(".");
    partnerSubdomain = partnerSubdomainList[1];
  }
  var params = new Map();
  params["subdomain"] = partnerSubdomain;
  params["app_version"] = appVersion;
  params["package_version"] = 1;
  var finalUrl = apiURL + "authorize/partner_branding_details";
  try {
    final response =
        await http.post(finalUrl, body: json.encode(params), headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': token
        });
    Map responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map businessPartner = responseData["business_partner"];
      primaryColor = Color(ColorUtils.getColorFromHex(businessPartner["primary_color"]));
      primaryTextColor = Color(ColorUtils.getColorFromHex(businessPartner["text_color"]));
      partnerAppType = businessPartner["app_type"];
    }
        
    if (token == "" || token == null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ])
      .then((_) {
        runZoned<Future<Null>>(() async {
          runApp(
            StoreProvider(
              store: store,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme:
                  ThemeData(
                    primaryColor: primaryColor,                
                    accentColor: accentColor,              
                  ),
                home: SignIn(),
                routes: routes,
                builder: (context, child) {
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  mobileLayout = shortestSide < 600;
                  getLinksStream().listen((String link) {                  
                    External.parseURL(link);                  
                  }, onError: (err) {                  
                  });                  
                  return MediaQuery(
                    child: child,
                    data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
                  );
                },
              ),
            ),
          );
        }, onError: (error, stackTrace) async {          
          await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
        });                        
      });      
    } else {            
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ])
      .then((_) async {   
        runZoned<Future<Null>>(() async {
          runApp(
            StoreProvider(
              store: store,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme:
                    ThemeData(
                      primaryColor: primaryColor, 
                      accentColor: accentColor
                    ),
                home: new VerifyUser(),
                routes: routes,
                builder: (context, child)  {
                  var shortestSide = MediaQuery.of(context).size.shortestSide;
                  mobileLayout = shortestSide < 600;
                  getLinksStream().listen((String link) {
                    External.parseURL(link);
                  }, onError: (err) {                  
                  });                                               
                  return MediaQuery(
                    child: child,
                    data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
                  );                
                },
              ),
            ),
          );
        }, onError: (error, stackTrace) async {          
          await FlutterCrashlytics().reportCrash(error, stackTrace, forceCrash: false);
        });        
      });        
    }
  } catch(exception) {
    Fluttertoast.showToast(
      msg: "App is not able to contact the server. Kindly send an email to support@gomotive.com",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 5,
      backgroundColor: primaryColor,
      textColor: primaryTextColor,
      fontSize: 16.0
    );
  }  
}
