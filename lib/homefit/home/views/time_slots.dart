import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/utils/utils.dart';
import 'package:homefit/home/home_network.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/utils/gomotive_icons.dart';

class TimeSlots extends StatelessWidget {
  final String type;
  TimeSlots({this.type});
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
          child: _TimeSlots(
            type: this.type
          ),
        )        
      ),
    );
  }
}

class _TimeSlots extends StatefulWidget {
  final String type;
  _TimeSlots({this.type});

  @override
  _TimeSlotsState createState() => new _TimeSlotsState();
}

class _TimeSlotsState extends State<_TimeSlots> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _trackActivities;
  int _minute = -1;

  void _onClickMinute(int _minute) async {
    this._minute = _minute;
    String content = "";
    if(widget.type == "dla") {
      content = "Did you carry out any activities like gardening, shopping, etc., for a duration of ${this._minute} minutes";
    } else {
      content = "Did you play sports for a duration of ${this._minute} minutes";
    }
    int responseValue = await Utils.confirmDialog(context, "Confirm?", content, "Yes, I Confirm", "No");
    if(responseValue == 1) {
      Map params = new Map();
      Map activityObj = new Map();
      if(widget.type == "dla") {
        activityObj['key'] = "dla_duration";
        activityObj['name'] = "Daily Life Activities";
      } else {
        activityObj['key'] = "sports_duration";
        activityObj['name'] = "Sports";
      }
      params['activity_obj'] = activityObj;
      params["selected_duration"] = _minute;
      _trackActivities(context, params);
    } else {
      Navigator.pop(context);
    }    
  }

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[  
                    new Builder(
                      builder: (BuildContext context) {
                        String title = "";
                        if(widget.type == "dla"){
                          title = "Daily Life Activities";
                        } else {
                          title = "Sports";
                        }
                        return Container(                              
                          alignment: Alignment(0, -1),
                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 48.0),
                          child: Text(
                            title,
                            style: new TextStyle(
                                fontSize: 48.0,
                              ),
                          )
                        );
                      },
                    ),
                    new Container(                              
                      alignment: Alignment(0, -1),
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 12.0),
                      child: Text(
                        "How much time did you spend?",
                        style: new TextStyle(
                          fontSize: 24.0,
                        ),
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 48.0),
                      child: Wrap(                          
                        spacing: 48.0, // gap between adjacent chips
                        runSpacing: 48.0,
                        alignment: WrapAlignment.center,
                        children: [
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 5;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(5);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                ' 5 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 5 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 10;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(10);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '10 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 10 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 15;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(15);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '15 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 15 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 20;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(20);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '20 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 20 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 25;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(25);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '25 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 25 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 30;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(30);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '30 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 30 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 35;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(35);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '35 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 35 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 40;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(40);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '40 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 40 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 45;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(45);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '45 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 45 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 50;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(50);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '50 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 50 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 55;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(55);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '55 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 55 ? Colors.green : Colors.white,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 60;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(65);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                              label: Text(
                                '60 minutes',
                                style: new TextStyle(
                                  fontSize: 48.0,
                                ),
                              ),
                              backgroundColor: this._minute == 60 ? Colors.green : Colors.white,
                            ),
                          ),
                        ]
                      ),
                    ), 
                    new Container(
                      alignment: Alignment(0, -1),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0
                      ),
                      child: new MaterialButton(
                        height: 60.0,
                        minWidth: 180.0,
                        color: dhfYellow,
                        child: new Text(
                          'Back',
                          textScaleFactor: 2.5,
                        ),
                        textColor: Colors.black87, 
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),                                             
                  ],
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
            'Select time slot'
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[  
                    new Builder(
                      builder: (BuildContext context) {
                        String title = "";
                        if(widget.type == "dla"){
                          title = "Daily Life Activities";
                        } else {
                          title = "Sports";
                        }
                        return Container(                              
                          decoration: BoxDecoration(
                            color: Colors.blueGrey
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                          child: Text(
                            title,
                            style: new TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        );
                      },
                    ),
                    new Container(                              
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                      child: Text(
                        "How much time did you spend?",
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Wrap(                          
                        spacing: 12.0, // gap between adjacent chips
                        runSpacing: 12.0,
                        alignment: WrapAlignment.center,
                        children: [
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 5;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(5);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                ' 5 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 5 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 10;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(10);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '10 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 10 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 15;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(15);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '15 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 15 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 20;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(20);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '20 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 20 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 25;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(25);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '25 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 25 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 30;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(30);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '30 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 30 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 35;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(35);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '35 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 35 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 40;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(40);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '40 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 40 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 45;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(45);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '45 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 45 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 50;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(50);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '50 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 50 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 55;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(55);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '55 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 55 ? Colors.green : Colors.black12,
                            ),
                          ),
                          GestureDetector (
                            onTapDown: (TapDownDetails details) {
                              setState((){
                                _minute = 60;
                              });
                            },
                            onTap: () {
                              this._onClickMinute(65);
                            },
                            child: new Chip(
                              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                              label: Text(
                                '60 minutes',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              backgroundColor: this._minute == 60 ? Colors.green : Colors.black12,
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
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
         DeviceOrientation.portraitDown,
         DeviceOrientation.portraitUp]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _trackActivities = stateObject['trackActivities'];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["trackActivities"] = (BuildContext context, Map params) =>
          store.dispatch(trackActivities(context, params));          
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
