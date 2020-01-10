import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/movement_circle.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/user/views/user_movement_meter_weekly_graph.dart';

class ClientTrackingMovementMeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientTrackingMovementMeter(),
      ),
    );
  }
}

class _ClientTrackingMovementMeter extends StatefulWidget {
  @override
  _ClientTrackingMovementMeterState createState() => new _ClientTrackingMovementMeterState();
}

class _ClientTrackingMovementMeterState extends State<_ClientTrackingMovementMeter> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  Map _currentWeekMovementMeters, _userObj;

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["currentWeekMovementMeters"] = store.state.clientState.currentWeekMovementMeters;
        returnObject["user"] = store.state.authState.user;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _currentWeekMovementMeters = stateObject["currentWeekMovementMeters"];
        _userObj = stateObject["user"];
        if(_currentWeekMovementMeters != null && _userObj != null) {
          double _totalPoints = _currentWeekMovementMeters["mobility_total"] +
                                _currentWeekMovementMeters["strength_total"] +
                                _currentWeekMovementMeters["metabolic_total"] +
                                _currentWeekMovementMeters["power_total"];
          double _totalMinutes = _totalPoints * 5;
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                'Movement Meter',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),
              actions: <Widget>[              
              ],
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
                      child: new Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Center(
                                child: new Text(
                                  "CURRENT WEEK",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )
                                )
                              )
                            ),
                            new Container(    
                              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),                              
                              height: 200.0,
                              width: 200.0,
                              child: _currentWeekMovementMeters != null && _currentWeekMovementMeters.keys.length > 0 
                                ? new CustomPaint(
                                  foregroundPainter: new MovementCirclePainter(
                                    mobilityPercentage: _currentWeekMovementMeters['mobility_percentage'].toDouble(),
                                    strengthPercentage: _currentWeekMovementMeters['strength_percentage'].toDouble(),
                                    metabolicPercentage: _currentWeekMovementMeters['metabolic_percentage'].toDouble(),
                                    powerPercentage: _currentWeekMovementMeters['power_percentage'].toDouble(),
                                  )
                                )
                                : new Container()
                            ),
                            new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                    child: new Chip(       
                                      backgroundColor: Colors.green[100],         
                                      label: Text(
                                        _totalMinutes.toString() + ' minutes / week',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    ),                      
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                    child: new Chip(       
                                      backgroundColor: Colors.green[100],                         
                                      label: Text(
                                        _totalPoints.toString() + ' points',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    ),                      
                                  )
                                ],
                              )
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: new FlatButton(
                                color: primaryColor,                                
                                child: new Text(
                                  'Weekly Progress Graph',
                                  style: TextStyle(
                                    color: primaryTextColor
                                  )
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new UserMovementMeterWeeklyGraph(
                                        userId: _userObj["id"]
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: new FlatButton(
                                color: primaryColor,                                
                                child: new Text(
                                  'Add Activity',
                                  style: TextStyle(
                                    color: primaryTextColor
                                  )
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "/client/tracking/movement_meter/add");
                                },
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                      'assets/images/dhf_mobility.png',
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                            "Mobility: " + _currentWeekMovementMeters['mobility_percentage'].toString() + "%",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            _currentWeekMovementMeters['mobility'].toString() + " / " + _currentWeekMovementMeters['mobility_total'].toInt().toString() + " points",
                                            style: TextStyle(
                                              fontSize: 12.0
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            (_currentWeekMovementMeters['mobility']*5).toString() + " / " + (_currentWeekMovementMeters['mobility_total']*5).toInt().toString() + " mins / week",
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
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                      'assets/images/dhf_strength.png',
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                            "Strength: " + _currentWeekMovementMeters['strength_percentage'].toString() + "%",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            _currentWeekMovementMeters['strength'].toString() + " / " + _currentWeekMovementMeters['strength_total'].toInt().toString() + " points",
                                            style: TextStyle(
                                              fontSize: 12.0
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            (_currentWeekMovementMeters['strength']*5).toString() + " / " + (_currentWeekMovementMeters['strength_total']*5).toInt().toString() + " mins / week",
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
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                      'assets/images/dhf_metabolic.png',
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                            "Metabolic: " + _currentWeekMovementMeters['metabolic_percentage'].toString() + "%",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            _currentWeekMovementMeters['metabolic'].toString() + " / " + _currentWeekMovementMeters['metabolic_total'].toInt().toString() + " points",
                                            style: TextStyle(
                                              fontSize: 12.0
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            (_currentWeekMovementMeters['metabolic']*5).toString() + " / " + (_currentWeekMovementMeters['metabolic_total']*5).toInt().toString() + " mins / week",
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
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                      'assets/images/dhf_power.png',
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  new Container(
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(
                                            "Power: " + _currentWeekMovementMeters['power_percentage'].toString() + "%",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            _currentWeekMovementMeters['power'].toString() + " / " + _currentWeekMovementMeters['power_total'].toInt().toString() + " points",
                                            style: TextStyle(
                                              fontSize: 12.0
                                            ), 
                                            textAlign: TextAlign.start,
                                          )
                                        ),
                                        new Container(
                                          child: new Text(
                                            (_currentWeekMovementMeters['power']*5).toString() + " / " + (_currentWeekMovementMeters['power_total']*5).toInt().toString() + " mins / week",
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
                            )
                          ],
                        )                              
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
