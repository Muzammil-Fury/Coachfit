import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_state.dart';

class UserAbout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: _UserAbout(),
      ),
    );
  }
}

class _UserAbout extends StatefulWidget {
  @override
  UserAboutState createState() => new UserAboutState();
}

class UserAboutState extends State<_UserAbout> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {    
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(                  
              icon: Icon(
                GomotiveIcons.back,
                size: 30.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: new Text(
              "About",                
              style: TextStyle(
                color: Colors.black87,
              )
            ),
            actions: <Widget>[
            ],
          ),            
          body: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(                    
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width*.6,                            
                            child:Image.asset(
                              "assets/images/logo_big.png"
                            ),
                          ),
                          new Container(   
                            padding:EdgeInsets.fromLTRB(0, 8, 0, 0),                         
                            child: new Text(
                              "Version " + appVersion,
                              style: TextStyle(
                                fontSize: 24.0,
                              )
                            )
                          ),
                          new Container(   
                            padding:EdgeInsets.fromLTRB(0, 8, 0, 0),                         
                            child: new Text(
                              "Copyright 2014-2019",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w100,
                              )
                            )
                          ),
                          new Container(   
                            padding:EdgeInsets.fromLTRB(0, 8, 0, 0),                         
                            child: new Text(
                              "GoMotive, Inc.",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w100,
                              )
                            )
                          ),
                          new Container(   
                            padding:EdgeInsets.fromLTRB(0, 8, 0, 0),                         
                            child: new Text(
                              "All rights reserved",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w100,
                              )
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}
