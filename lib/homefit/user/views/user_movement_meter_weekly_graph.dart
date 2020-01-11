import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:homefit/user/user_network.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/utils/gomotive_icons.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/utils/movement_circle.dart';
import 'package:homefit/core/app_config.dart';

class UserMovementMeterWeeklyGraph extends StatelessWidget {
  final int userId;
  UserMovementMeterWeeklyGraph({
    this.userId
  });

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
          child: _UserMovementMeterWeeklyGraph(
            userId: this.userId,
          ),
        )        
      ),
    );
  }
}

class _UserMovementMeterWeeklyGraph extends StatefulWidget {
  final int userId;
  _UserMovementMeterWeeklyGraph({
    this.userId
  });
  
  @override
  UserMovementMeterWeeklyGraphState createState() => new UserMovementMeterWeeklyGraphState();
}

class UserMovementMeterWeeklyGraphState extends State<_UserMovementMeterWeeklyGraph> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getUserMovementMeterWeeklyGraphAPI;
  List<Map> movementMeterWeeklyGraph;

  List<Map> _mobilityData, _strengthData, _metabolicData, _powerData;

  int displayWeek;  

  
  @override
  void initState() {
    displayWeek = 0;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getUserMovementMeterWeeklyGraphAPI = stateObject["getUserMovementMeterWeeklyGraph"];
        Map _params = new Map();
        _params["user_id"] = widget.userId;
        _getUserMovementMeterWeeklyGraphAPI(context, _params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getUserMovementMeterWeeklyGraph"] = (BuildContext context, Map params) =>
            store.dispatch(getUserMovementMeterWeeklyGraph(context, params));          
        returnObject["movementMeterWeeklyGraph"] = store.state.userState.movementMeterWeeklyGraph;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        movementMeterWeeklyGraph = stateObject["movementMeterWeeklyGraph"];
        if(movementMeterWeeklyGraph != null && movementMeterWeeklyGraph.length > 0) {
          _mobilityData = new List<Map>();
          for(int i=0;i<movementMeterWeeklyGraph.length;i++) {
            Map _obj = new Map();
            if(i == 0) {
              _obj["week"] = 0;
            } else {
              _obj["week"] = (0 - i);
            }     
            _obj["duration"] = movementMeterWeeklyGraph[i]["mobility_points"];
            _mobilityData.add(_obj);
          }
          _strengthData = new List<Map>();
          for(int i=0;i<movementMeterWeeklyGraph.length;i++) {
            Map _obj = new Map();
            if(i == 0) {
              _obj["week"] = 0;
            } else {
              _obj["week"] = 0-i;
            }
            _obj["duration"] = movementMeterWeeklyGraph[i]["strength_points"];
            _strengthData.add(_obj);
          }
          _metabolicData = new List<Map>();
          for(int i=0;i<movementMeterWeeklyGraph.length;i++) {
            Map _obj = new Map();
            if(i == 0) {
              _obj["week"] = 0;
            } else {
              _obj["week"] = 0-i;
            }
            _obj["duration"] = movementMeterWeeklyGraph[i]["metabolic_points"];
            _metabolicData.add(_obj);
          }
          _powerData = new List<Map>();
          for(int i=0;i<movementMeterWeeklyGraph.length;i++) {
            Map _obj = new Map();
            if(i == 0) {
              _obj["week"] = 0;
            } else {
              _obj["week"] = 0-i;
            }
            _obj["duration"] = movementMeterWeeklyGraph[i]["power_points"];
            _powerData.add(_obj);
          }
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
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
              title: new Text(
                "Weekly Progress",                
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
                      child: new Column(
                        children: <Widget>[
                          // new Container(    
                          //   width: MediaQuery.of(context).size.width,   
                          //   decoration: BoxDecoration(
                          //     color: Colors.blueGrey
                          //   ),                       
                          //   padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          //   child: new Container(                                  
                          //     child: new Text(
                          //       "MOVEMENT METER",
                          //       textAlign: TextAlign.center,
                          //       style: TextStyle(  
                          //         fontSize: 20.0,
                          //         color: Colors.white,                                  
                          //       ),
                          //     )
                          //   ),                              
                          // ),
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            child: new Container(                                  
                              child: new Text(
                                "Movement Meter progress for last 12 weeks. Tap left or right arrow to view the same for other weeks",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  fontSize: 16.0,
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          new Container(    
                            width: MediaQuery.of(context).size.width,                                                      
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            child: new Container(                                  
                              child: new Text(
                                movementMeterWeeklyGraph[displayWeek]["date_display_str"],
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  fontSize: 16.0,
                                  color: Colors.black,                                  
                                ),
                              )
                            ),                              
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconButton(                  
                                icon: Icon(
                                  GomotiveIcons.back,
                                  size: 50.0,
                                  color: displayWeek < 11 ? Colors.black : Colors.black12,
                                ),
                                onPressed: () {
                                  if(displayWeek < 11) {
                                    setState(() {
                                      displayWeek = displayWeek + 1;
                                    });                                  
                                  }
                                },
                              ),
                              new Container(    
                                margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),                              
                                height: 250.0,
                                width: 250.0,
                                child: new CustomPaint(
                                  foregroundPainter: new MovementCirclePainter(
                                    mobilityPercentage: movementMeterWeeklyGraph[displayWeek]['mobility_percentage'].toDouble(),
                                    strengthPercentage: movementMeterWeeklyGraph[displayWeek]['strength_percentage'].toDouble(),
                                    metabolicPercentage: movementMeterWeeklyGraph[displayWeek]['metabolic_percentage'].toDouble(),
                                    powerPercentage: movementMeterWeeklyGraph[displayWeek]['power_percentage'].toDouble(),
                                  )
                                )                            
                              ),
                              new Flexible(
                                child: new IconButton(                  
                                  icon: Icon(
                                    GomotiveIcons.next,
                                    size: 50.0,
                                    color: displayWeek > 0 ? Colors.black : Colors.black12,
                                  ),
                                  onPressed: () { 
                                    if(displayWeek > 0) {
                                      setState((){
                                        displayWeek = displayWeek - 1;
                                      });
                                    }                                 
                                  },
                                ),
                              )
                            ],
                          ),  
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: mobileLayout ? 8.0 : 256.0),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                              
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.lightBlue
                              )                        
                            ),
                            child: new Row(   
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,                             
                              children: <Widget>[
                                new Container(                                    
                                  child: new Image.asset(
                                    'assets/images/mobility.png',
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                new Container(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          "Mobility: " + movementMeterWeeklyGraph[displayWeek]['mobility_percentage'].toString() + "%",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          movementMeterWeeklyGraph[displayWeek]['mobility_points'].toString() + " / " + movementMeterWeeklyGraph[displayWeek]['mobility_duration_total'].toInt().toString() + " points",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          (movementMeterWeeklyGraph[displayWeek]['mobility_points']*5).toString() + " / " + (movementMeterWeeklyGraph[displayWeek]['mobility_duration_total']*5).toInt().toString() + " mins / week",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            ),
                          ),      
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: mobileLayout ? 8.0 : 256.0),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                              
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.lightGreen
                              )                        
                            ),
                            child: new Row(   
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,                             
                              children: <Widget>[
                                new Container(                                    
                                  child: new Image.asset(
                                    'assets/images/strength.png',
                                    color: Colors.lightGreen,
                                  ),
                                ),
                                new Container(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          "Strength: " + movementMeterWeeklyGraph[displayWeek]['strength_percentage'].toString() + "%",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          movementMeterWeeklyGraph[displayWeek]['strength_points'].toString() + " / " + movementMeterWeeklyGraph[displayWeek]['strength_duration_total'].toInt().toString() + " points",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          (movementMeterWeeklyGraph[displayWeek]['strength_points']*5).toString() + " / " + (movementMeterWeeklyGraph[displayWeek]['strength_duration_total']*5).toInt().toString() + " mins / week",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            ),
                          ),  
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: mobileLayout ? 8.0 : 256.0),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                              
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.yellow
                              )                        
                            ),
                            child: new Row(   
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,                             
                              children: <Widget>[
                                new Container(                                    
                                  child: new Image.asset(
                                    'assets/images/metabolic.png',
                                    color: Colors.yellow,
                                  ),
                                ),
                                new Container(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          "Metabolic: " + movementMeterWeeklyGraph[displayWeek]['metabolic_percentage'].toString() + "%",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          movementMeterWeeklyGraph[displayWeek]['metabolic_points'].toString() + " / " + movementMeterWeeklyGraph[displayWeek]['metabolic_duration_total'].toInt().toString() + " points",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          (movementMeterWeeklyGraph[displayWeek]['metabolic_points']*5).toString() + " / " + (movementMeterWeeklyGraph[displayWeek]['metabolic_duration_total']*5).toInt().toString() + " mins / week",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            ),
                          ),  
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: mobileLayout ? 8.0 : 256.0),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                              
                            decoration: new BoxDecoration(
                              border: new Border.all(
                                color: Colors.redAccent
                              )                        
                            ),
                            child: new Row(   
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,                             
                              children: <Widget>[
                                new Container(                                    
                                  child: new Image.asset(
                                    'assets/images/power.png',
                                    color: Colors.redAccent,
                                  ),
                                ),
                                new Container(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          "Power: " + movementMeterWeeklyGraph[displayWeek]['power_percentage'].toString() + "%",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          movementMeterWeeklyGraph[displayWeek]['power_points'].toString() + " / " + movementMeterWeeklyGraph[displayWeek]['power_duration_total'].toInt().toString() + " points",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          (movementMeterWeeklyGraph[displayWeek]['power_points']*5).toString() + " / " + (movementMeterWeeklyGraph[displayWeek]['power_duration_total']*5).toInt().toString() + " mins / week",
                                          style: TextStyle(
                                            fontSize: 12.0
                                          ), 
                                          textAlign: TextAlign.start,
                                        )
                                      )
                                    ],
                                  )
                                )
                              ],
                            ),
                          ),              
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0),
                          )
                        ],
                      )                                      
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
