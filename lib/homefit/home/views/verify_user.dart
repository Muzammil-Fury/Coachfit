import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/home/home_network.dart';
import 'package:homefit/core/app_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homefit/core/app_constants.dart';

class VerifyUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: new _VerifyUser(),
        )        
      ),
    );
  }
}

class _VerifyUser extends StatefulWidget {
  _VerifyUserState createState() => new _VerifyUserState();  
}

class _VerifyUserState extends State<_VerifyUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _verifyUserAPI;

  @override
  void initState() {    
    super.initState();    
  }
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _verifyUserAPI = stateObject["verifyUserAction"]; 
        Map _params = new Map();
        _params["notification_token"] = notificationStr;      
        _verifyUserAPI(context, _params);      
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();        
        returnObject["verifyUserAction"] = (BuildContext context, Map params) =>
            store.dispatch(homefitVerifyUser(context, params));
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.requestNotificationPermissions(
              const IosNotificationSettings(sound: true, badge: true, alert: true));
        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings) {
        });          
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {       
            Fluttertoast.showToast(
              msg: message["aps"]["alert"]["body"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 10,
              backgroundColor: dhfYellow,
              textColor: Colors.black,
              fontSize: 16.0
            );
          },
          onLaunch: (Map<String, dynamic> message) async {      
          },
          onResume: (Map<String, dynamic> message) async {
          },
        );   
             
        return new Scaffold(
          key: _scaffoldKey,          
          body: new LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ), 
                  child: new Container(
                    padding: EdgeInsets.symmetric(vertical: 24.0),  
                  )
                )
              );
            }
          )
        );        
      },
    );
  }
}
