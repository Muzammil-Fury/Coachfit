import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/home/views/time_slots.dart';
import 'package:homefit/utils/utils.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/utils/gomotive_icons.dart';
import 'package:homefit/utils/menu_utils.dart';

class Track extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _Track(),
        )        
      ),
    );
  }
}

class _Track extends StatefulWidget {
  @override
  _TrackState createState() => new _TrackState();
}

class _TrackState extends State<_Track> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover
                  ),
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: new BoxDecoration(
                        color: Colors.black26
                      ),
                      child: Utils.drawMenu(context, "track")
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.85,
                      child: new Column(                         
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 64.0),
                            child: new Center(
                              child: new Text(
                                "Track additional movements not associated with workout videos by selecting an option below",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0
                                ),
                              )
                            )
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget> [
                              new GestureDetector(
                                onTap: () {       
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => 
                                      TimeSlots(type: "dla")
                                    ),
                                  );                                                             
                                },
                                child: new Container(
                                  width: MediaQuery.of(context).size.height*0.5,
                                  child: new Column(
                                    children: <Widget>[
                                      new Image.asset(
                                        'assets/images/dla.png', 
                                      ),
                                      new Container(
                                        child: new Text(
                                          "Daily Life Activities",
                                          style: TextStyle(
                                            fontSize: 32.0,
                                            color: Colors.black87
                                          )
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              new GestureDetector(
                                onTap: () {  
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => 
                                      TimeSlots(type: "sports")
                                    ),
                                  );                                                                                             
                                },
                                child: new Container(
                                  width: MediaQuery.of(context).size.height*0.5,
                                  child: new Column(
                                    children: <Widget>[
                                      new Image.asset(
                                        'assets/images/sports.png', 
                                      ),
                                      new Container(
                                        child: new Text(
                                          "Sports",
                                          style: TextStyle(
                                            fontSize: 32.0,
                                            color: Colors.black87
                                          )
                                        )
                                      )
                                    ],
                                  ),                                  
                                )
                              ),
                            ]
                          )
                        ],
                      )
                    )
                  ]
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _drawSmallerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new Scaffold(      
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Track'
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: dhfYellow,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: MenuUtils.buildNavigationMenuBar("track"),
        onTap: (int index) {
          if(index != 2) {
            MenuUtils.menubarTap(
              context, "track", index
            );
          }
        },
      ),     
      body: new LayoutBuilder(  
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "Track additional movements not associated with workout videos by selecting an option below",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        )
                      )
                    ),
                    new GestureDetector(
                      onTap: () {       
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => 
                            TimeSlots(type: "dla")
                          ),
                        );                                                             
                      },
                      child: new Container(        
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),                          
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black12
                              ),
                              child: new Text(
                                "Daily Life Activities",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black87
                                ),
                                textAlign: TextAlign.center,
                              )
                            ),
                            new Image.asset(
                              'assets/images/dla.png', 
                            ),                          
                          ],
                        ),
                      ),
                    ),
                    new GestureDetector(
                      onTap: () {       
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => 
                            TimeSlots(type: "sports")
                          ),
                        );                                                             
                      },
                      child: new Container(        
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),                          
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.black12
                              ),
                              child: new Text(
                                "Sports",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.black87
                                ),
                                textAlign: TextAlign.center,
                              )
                            ),
                            new Image.asset(
                              'assets/images/sports.png', 
                            ),                          
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              )
            )
          );
        }
      )
    );
  }
 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft,
         DeviceOrientation.landscapeRight,
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        if(mobileLayout) {
          return this._drawSmallerDeviceWidget();
        } else {
          return this._drawLargerDeviceWidget();
        }        
      } 
    );
  }
}
