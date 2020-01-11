import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/workout/views/workout_preview.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/workout/workout_actions.dart';
import 'package:gomotive/homefit/user/views/user_profile_ipad.dart';
import 'package:gomotive/homefit/utils/movement_circle.dart';
import 'package:gomotive/homefit/utils/menu_utils.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/user/views/user_movement_meter_weekly_graph.dart';

class Dashboard extends StatelessWidget {

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
          child: _Dashboard(),
        )        
      ),
    );
  }
}

class _Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<_Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getDashboardDetails, _getDashboardNewWorkouts, _getDashboardFavoriteWorkouts; 
  var _user;
  List<Map> _workouts;
  var _currentWeekMovementMeters;
  int _currentPoints;
  int _totalPoints;
  List<Map> _newWorkouts;
  List<Map> _favoriteWorkouts;
  Map _favoriteWorkoutsPaginateInfo;
  double width = 300;
  double height = 200;

  ScrollController _favoriteWorkoutsController;

  _favoriteWorkoutsScrollListener() {
    if (_favoriteWorkoutsController.offset >= _favoriteWorkoutsController.position.maxScrollExtent && !_favoriteWorkoutsController.position.outOfRange) {
      if(_favoriteWorkoutsPaginateInfo.containsKey("total_pages") && ((_favoriteWorkoutsPaginateInfo["page"]+1) < _favoriteWorkoutsPaginateInfo["total_pages"])){                
        var params = new Map();
        params["page"] = _favoriteWorkoutsPaginateInfo["page"] + 1;    
        _getDashboardFavoriteWorkouts(context, params);    
      }
    }
  }

  @override
  void initState() {
    _favoriteWorkoutsController = ScrollController();
    _favoriteWorkoutsController.addListener(_favoriteWorkoutsScrollListener);       
    super.initState();
  }  

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitDown
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
                      child: Utils.drawMenu(context, "home")
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.85,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[                                
                          new Container (
                            width: MediaQuery.of(context).size.width*0.5,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[   
                                new GestureDetector(
                                  onTap:() {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new UserMovementMeterWeeklyGraph(
                                          userId: _user["id"]
                                        ),
                                      ),
                                    );                                              
                                  },
                                  child: new Container(
                                    height: 250.0,
                                    width: 250.0,
                                    child: new CustomPaint(
                                      foregroundPainter: new MovementCirclePainter(                                              
                                          mobilityPercentage: this._currentWeekMovementMeters['mobility_percentage'].toDouble(),
                                          strengthPercentage: this._currentWeekMovementMeters['strength_percentage'].toDouble(),
                                          metabolicPercentage: this._currentWeekMovementMeters['metabolic_percentage'].toDouble(),
                                          powerPercentage: this._currentWeekMovementMeters['power_percentage'].toDouble(),
                                      )
                                    )
                                  ),
                                ),                                                                                                         
                                new Container(                                    
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,                                  
                                    children: <Widget>[                                    
                                      new Container(
                                        width: 400.0,
                                        height: 25.0,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0
                                        ),                                              
                                        decoration: new BoxDecoration(
                                          color: Colors.lightBlue[100]
                                        ),
                                        child: new Stack(                                                
                                          children: <Widget> [                                                  
                                            new Positioned(
                                              width: this._currentWeekMovementMeters['mobility_percentage'].toDouble()*4.0,
                                              height: 25.0,
                                              child: new Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.lightBlue,                            
                                                ),
                                                child: new Text('')
                                              )
                                            ),                                                  
                                            new Positioned(
                                              left: 5,
                                              top: 5,
                                              child: new Text('Mobility')
                                            ),                                                   
                                            new Positioned(
                                              right: 0.0,
                                              top: 5,
                                              child: new Text("Points ${this._currentWeekMovementMeters['mobility'].round()}/${this._currentWeekMovementMeters['mobility_total'].round()}")
                                            ), 
                                          ]
                                        )                                     
                                      ),
                                      new Container(
                                        width: 400.0,
                                        height: 25.0,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.lightGreen[100]
                                        ),
                                        child: new Stack(                                                
                                          children: <Widget> [                                                  
                                            new Positioned(
                                              width: this._currentWeekMovementMeters['strength_percentage'].toDouble()*4.0,
                                              height: 25.0,
                                              child: new Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.green,                            
                                                ),
                                                child: new Text('')
                                              )
                                            ),                                                  
                                            new Positioned(
                                              left: 5.0,
                                              top: 5.0,
                                              child: new Text('Strength')
                                            ),                                                   
                                            new Positioned(
                                              right: 0.0,
                                              top: 5.0,
                                              child: new Text("Points ${this._currentWeekMovementMeters['strength'].round()}/${this._currentWeekMovementMeters['strength_total'].round()}")
                                            ), 
                                          ]
                                        )                                     
                                      ),
                                      new Container(
                                        width: 400.0,
                                        height: 25.0,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.yellow[100]
                                        ),
                                        child: new Stack(                                                
                                          children: <Widget> [                                                  
                                            new Positioned(
                                              width: this._currentWeekMovementMeters['metabolic_percentage'].toDouble()*4.0,
                                              height: 25.0,
                                              child: new Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.yellow,                            
                                                ),
                                                child: new Text('')
                                              )
                                            ),                                                  
                                            new Positioned(
                                              left: 5.0,
                                              top: 5.0,
                                              child: new Text('Metabolic')
                                            ),                                                   
                                            new Positioned(
                                              right: 0.0,
                                              top: 5.0,
                                              child: new Text("Points ${this._currentWeekMovementMeters['metabolic'].round()}/${this._currentWeekMovementMeters['metabolic_total'].round()}")
                                            ), 
                                          ]
                                        )                                     
                                      ),
                                      new Container(
                                        width: 400.0,
                                        height: 25.0,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.red[100],                                                
                                        ),
                                        child: new Stack(                                                
                                          children: <Widget> [                                                  
                                            new Positioned(
                                              width: this._currentWeekMovementMeters['power_percentage'].toDouble()*4,
                                              height: 25.0,
                                              child: new Container(
                                                decoration: new BoxDecoration(
                                                  color: Colors.red,                            
                                                ),
                                                child: new Text('')
                                              )
                                            ),                                                  
                                            new Positioned(
                                              left: 5.0,
                                              top: 5.0,
                                              child: new Text('Power')
                                            ),                                                   
                                            new Positioned(
                                              right: 0.0,
                                              top: 5.0,
                                              child: new Text("Points ${this._currentWeekMovementMeters['power'].round()}/${this._currentWeekMovementMeters['power_total'].round()}")
                                            ), 
                                          ]
                                        )                                     
                                      ),
                                      new Container(
                                        width: 400.0,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 0.0
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 0.0
                                        ),
                                        child: new Center(
                                          child: Text(
                                            "Total Points:  $_currentPoints / $_totalPoints"
                                          ),                                
                                        ),
                                      ),                                      
                                      new Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[                                                                                                
                                          new Container(
                                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                                            child: new Text(
                                              "Modify Weekly Movement Goals",
                                              style: TextStyle(
                                                fontSize: 28.0
                                              ),
                                            ),                                              
                                          ), 
                                          new IconButton(
                                            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                                            icon: Icon(Icons.settings),
                                            color: Colors.blueGrey,
                                            iconSize: 32.0,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                  builder: (context) => UserProfileIpad()
                                                ),
                                              ); 
                                            },
                                          )
                                        ],
                                      ),  
                                      new Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 0.0
                                        ),
                                        child: new MaterialButton( 
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8.0
                                          ),                       
                                          color: dhfYellow,
                                          child: new Text(
                                            'Track Activities',
                                            textScaleFactor: 2.0,
                                          ),
                                          textColor: Colors.black87, 
                                          onPressed: () {
                                            Navigator.pushNamed(context, "/user/activity_track");                              
                                          },
                                        ),
                                      ),                                                                            
                                      // new Container(
                                      //   padding: EdgeInsets.symmetric(
                                      //     vertical: 24.0, horizontal: 32.0
                                      //   ),
                                      //   child: new MaterialButton(
                                      //     height: 60.0,
                                      //     minWidth: 180.0,
                                      //     color: dhfYellow,
                                      //     child: new Text(
                                      //       'Weekly Progress Graph',
                                      //       textScaleFactor: 2.5,
                                      //     ),
                                      //     textColor: Colors.black87, 
                                      //     onPressed: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         new MaterialPageRoute(
                                      //           builder: (context) => new UserMovementMeterWeeklyGraph(
                                      //             userId: _user["id"]
                                      //           ),
                                      //         ),
                                      //       );                                              
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),                                        
                                ), 
                              ],
                            ),
                          ),
                          new Container (
                            width: MediaQuery.of(context).size.width*0.5,
                            padding: EdgeInsets.fromLTRB(0, 64, 0, 0),
                            child: new Builder(
                              builder: (BuildContext context) {                                                                  
                                return new Container(
                                  child: new Column(
                                    children: <Widget>[   
                                      new Container(                                                    
                                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),                                        
                                        child: new Center(
                                          child: new Text(
                                            "NEW WORKOUTS",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        )
                                      ), 
                                      _newWorkouts != null
                                      ? new Container(
                                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                          height: height,
                                          child: new ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: _newWorkouts.length,
                                            itemBuilder: (context, i) {
                                              return new Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                                                child: new GestureDetector(
                                                  onTapDown: (TapDownDetails details) {          
                                                  },
                                                  onTap: () {                        
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                        builder: (context) => 
                                                        WorkoutPreview(workoutId: _newWorkouts[i]["id"])
                                                      ),
                                                    );                                                                                                                       
                                                  },
                                                  child: Utils.drawWorkout(context, _newWorkouts[i], _user, width, height)
                                                )
                                              );
                                            }
                                          )
                                        ) 
                                      : new Container(
                                          height: height,
                                        ),
                                      _favoriteWorkouts != null && _favoriteWorkouts.length > 0
                                      ? new Column(
                                          children: <Widget>[
                                            new Container(                                                    
                                              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),                                              
                                              child: new Center(
                                                child: new Text(
                                                  "FAVORITE WORKOUTS",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              )
                                            ),                         
                                            new Container(
                                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                              height: height,
                                              child: new ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: _favoriteWorkouts.length,
                                                controller: _favoriteWorkoutsController,                                
                                                itemBuilder: (context, i) {
                                                  return new Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                                                    child: new GestureDetector(
                                                      onTapDown: (TapDownDetails details) {          
                                                      },
                                                      onTap: () {                        
                                                        Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                            builder: (context) => 
                                                            WorkoutPreview(workoutId: _favoriteWorkouts[i]["id"])
                                                          ),
                                                        );                                                                                                                       
                                                      },
                                                      child: Utils.drawWorkout(context, _favoriteWorkouts[i], _user, width, height)
                                                    )
                                                  );
                                                }
                                              )
                                            ) 
                                          ],
                                        )                          
                                      : new Container(                            
                                        ),                                         
                                                                     
                                    ],
                                  ),
                                );  
                              },
                            ),
                          ),                              
                        ],
                      )
                    )
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft
    // ]);
    return new Scaffold(      
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),                
                width: 228,
                child:Image.asset(
                  "assets/images/homefit_logo.png"
                ),
              ),                    
            ],
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () {
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: MenuUtils.buildNavigationMenuBar("home"),
        onTap: (int index) {
          if(index != 0) {
            MenuUtils.menubarTap(
              context, "home", index
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
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "WEEKLY MOVEMENT GOALS",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                      height: 200.0,
                      width: 200.0,
                      child: new CustomPaint(
                        foregroundPainter: new MovementCirclePainter(                                              
                            mobilityPercentage: this._currentWeekMovementMeters['mobility_percentage'].toDouble(),
                            strengthPercentage: this._currentWeekMovementMeters['strength_percentage'].toDouble(),
                            metabolicPercentage: this._currentWeekMovementMeters['metabolic_percentage'].toDouble(),
                            powerPercentage: this._currentWeekMovementMeters['power_percentage'].toDouble(),
                        )
                      )
                    ),
                    new Container(    
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),                                
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,                                  
                        children: <Widget>[                                    
                          new Container(
                            width: 400.0,
                            height: 25.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0
                            ),                                              
                            decoration: new BoxDecoration(
                              color: Colors.lightBlue[100]
                            ),
                            child: new Stack(                                                
                              children: <Widget> [                                                  
                                new Positioned(
                                  width: this._currentWeekMovementMeters['mobility_percentage'].toDouble()*4.0,
                                  height: 25.0,
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.lightBlue,                            
                                    ),
                                    child: new Text('')
                                  )
                                ),                                                  
                                new Positioned(
                                  left: 5,
                                  top: 5,
                                  child: new Text('Mobility')
                                ),                                                   
                                new Positioned(
                                  right: 0.0,
                                  top: 5,
                                  child: new Text("Points ${this._currentWeekMovementMeters['mobility'].round()}/${this._currentWeekMovementMeters['mobility_total'].round()}")
                                ), 
                              ]
                            )                                     
                          ),
                          new Container(
                            width: 400.0,
                            height: 25.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.lightGreen[100]
                            ),
                            child: new Stack(                                                
                              children: <Widget> [                                                  
                                new Positioned(
                                  width: this._currentWeekMovementMeters['strength_percentage'].toDouble()*4.0,
                                  height: 25.0,
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.green,                            
                                    ),
                                    child: new Text('')
                                  )
                                ),                                                  
                                new Positioned(
                                  left: 5.0,
                                  top: 5.0,
                                  child: new Text('Strength')
                                ),                                                   
                                new Positioned(
                                  right: 0.0,
                                  top: 5.0,
                                  child: new Text("Points ${this._currentWeekMovementMeters['strength'].round()}/${this._currentWeekMovementMeters['strength_total'].round()}")
                                ), 
                              ]
                            )                                     
                          ),
                          new Container(
                            width: 400.0,
                            height: 25.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.yellow[100]
                            ),
                            child: new Stack(                                                
                              children: <Widget> [                                                  
                                new Positioned(
                                  width: this._currentWeekMovementMeters['metabolic_percentage'].toDouble()*4.0,
                                  height: 25.0,
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.yellow,                            
                                    ),
                                    child: new Text('')
                                  )
                                ),                                                  
                                new Positioned(
                                  left: 5.0,
                                  top: 5.0,
                                  child: new Text('Metabolic')
                                ),                                                   
                                new Positioned(
                                  right: 0.0,
                                  top: 5.0,
                                  child: new Text("Points ${this._currentWeekMovementMeters['metabolic'].round()}/${this._currentWeekMovementMeters['metabolic_total'].round()}")
                                ), 
                              ]
                            )                                     
                          ),
                          new Container(
                            width: 400.0,
                            height: 25.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.red[100],                                                
                            ),
                            child: new Stack(                                                
                              children: <Widget> [                                                  
                                new Positioned(
                                  width: this._currentWeekMovementMeters['power_percentage'].toDouble()*4,
                                  height: 25.0,
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.red,                            
                                    ),
                                    child: new Text('')
                                  )
                                ),                                                  
                                new Positioned(
                                  left: 5.0,
                                  top: 5.0,
                                  child: new Text('Power')
                                ),                                                   
                                new Positioned(
                                  right: 0.0,
                                  top: 5.0,
                                  child: new Text("Points ${this._currentWeekMovementMeters['power'].round()}/${this._currentWeekMovementMeters['power_total'].round()}")
                                ), 
                              ]
                            )                                     
                          ),
                          new Container(
                            width: 400.0,
                            margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 0.0
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 0.0
                            ),
                            child: new Center(
                              child: Text(
                                "Total Points:  $_currentPoints / $_totalPoints"
                              ),                                
                            ),
                          ), 
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: new MaterialButton(
                              color: dhfYellow,                                
                              child: new Text(
                                'Weekly Progress Graph',
                                style: TextStyle(
                                  color: Colors.black87
                                )
                              ),
                              onPressed: () { 
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new UserMovementMeterWeeklyGraph(
                                      userId: _user["id"]
                                    ),
                                  ),
                                );                               
                              },
                            ),
                          ),                   
                        ],
                      ),                                        
                    ),                    
                    new Column(
                      children: <Widget>[
                        new Container(                                                    
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey
                          ),
                          child: new Center(
                            child: new Text(
                              "TRACK ACTIVITIES",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          )
                        ),                                           
                        new Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black12
                          ),
                          child: new Center(
                            child: new Text(
                              "Track additional movements not associated with workout videos by tapping track button below",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            )
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: new MaterialButton(
                            color: dhfYellow,
                            child: new Text(
                              'TRACK',
                            ),
                            textColor: Colors.black87, 
                            onPressed: () {  
                              Navigator.pushNamed(context, "/user/activity_track");                              
                            },
                          ),
                        ),
                        new Container(                                                    
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey
                          ),
                          child: new Center(
                            child: new Text(
                              "NEW WORKOUTS",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            )
                          )
                        ), 
                        _newWorkouts != null
                        ? new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            height: height,
                            child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _newWorkouts.length,
                              itemBuilder: (context, i) {
                                return new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                                  child: new GestureDetector(
                                    onTapDown: (TapDownDetails details) {          
                                    },
                                    onTap: () {                        
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => 
                                          WorkoutPreview(workoutId: _newWorkouts[i]["id"])
                                        ),
                                      );                                                                                                                       
                                    },
                                    child: Utils.drawWorkout(context, _newWorkouts[i], _user, width, height)
                                  )
                                );
                              }
                            )
                          ) 
                        : new Container(
                            height: height,
                          ),
                        _favoriteWorkouts != null && _favoriteWorkouts.length > 0
                        ? new Column(
                            children: <Widget>[
                              new Container(                                                    
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey
                                ),
                                child: new Center(
                                  child: new Text(
                                    "FAVORITE WORKOUTS",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                )
                              ),                         
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                                height: height,
                                child: new ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: _favoriteWorkouts.length,
                                  controller: _favoriteWorkoutsController,                                
                                  itemBuilder: (context, i) {
                                    return new Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                                      child: new GestureDetector(
                                        onTapDown: (TapDownDetails details) {          
                                        },
                                        onTap: () {                        
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) => 
                                              WorkoutPreview(workoutId: _favoriteWorkouts[i]["id"])
                                            ),
                                          );                                                                                                                       
                                        },
                                        child: Utils.drawWorkout(context, _favoriteWorkouts[i], _user, width, height)
                                      )
                                    );
                                  }
                                )
                              ) 
                            ],
                          )                          
                        : new Container(                            
                          ),                                         
                      ]
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
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getDashboardDetails = stateObject["getDashboardDetails"];
        _getDashboardNewWorkouts = stateObject["getDashboardNewWorkouts"];   
        _getDashboardFavoriteWorkouts = stateObject["getDashboardFavoriteWorkouts"];     
        _getDashboardDetails(context, {});
        _getDashboardNewWorkouts(context, {});
        _getDashboardFavoriteWorkouts(context, {});
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getDashboardDetails"] = (BuildContext context, Map params) =>
          store.dispatch(getDashboardDetails(context, params));  
        returnObject["recommendedWorkoutListSuccessActionCreator"] = (List<Map> workouts) =>
          store.dispatch(RecommendedWorkoutListSuccessActionCreator(workouts)
        );               
        returnObject["getDashboardNewWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getDashboardNewWorkouts(context, params));    
        returnObject["getDashboardFavoriteWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getDashboardFavoriteWorkouts(context, params));    
        returnObject["welcomeVideoURL"] = store.state.homeFitHomeState.welcomeVideoURL;
        returnObject["welcomeVideoThumbnailURL"] = store.state.homeFitHomeState.welcomeVideoThumbnailURL;
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["workouts"] = store.state.homeFitWorkoutState.recommendedWorkouts;
        returnObject["currentWeekMovementMeters"] = store.state.homeFitHomeState.currentWeekMovementPoints;
        returnObject["newWorkouts"] = store.state.homeFitHomeState.newWorkouts;
        returnObject["favoriteWorkouts"] = store.state.homeFitHomeState.favoriteWorkouts;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        bool _loadPage = false;       
        _totalPoints = 0;
        _currentWeekMovementMeters = stateObject["currentWeekMovementMeters"]; 
        _user = stateObject["user"];
        _workouts = stateObject["workouts"];
        _newWorkouts = stateObject["newWorkouts"];
        _favoriteWorkouts = stateObject["favoriteWorkouts"];
        if(_user != null && _workouts != null && _currentWeekMovementMeters != null) {
          _currentPoints = _currentWeekMovementMeters['mobility'].round() + _currentWeekMovementMeters['strength'].round() + _currentWeekMovementMeters['metabolic'].round() + _currentWeekMovementMeters['power'].round();
          _totalPoints = _currentWeekMovementMeters['mobility_total'].round() + _currentWeekMovementMeters['strength_total'].round() + _currentWeekMovementMeters['metabolic_total'].round() + _currentWeekMovementMeters['power_total'].round();
          _loadPage = true;
        }
        if(_loadPage) {
          if(mobileLayout) {
            return _drawSmallerDeviceWidget();
          } else {
            return _drawLargerDeviceWidget();
          }
        } else {
          return new Container();
        }
      } 
    );
  }
}