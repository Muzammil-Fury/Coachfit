import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/workout/workout_network.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/workout/views/video_play.dart';
import 'package:homefit/workout/workout_actions.dart';
import 'package:homefit/utils/gomotive_icons.dart';

class WorkoutPreview extends StatelessWidget {
  final int workoutId;
  WorkoutPreview({this.workoutId});

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
          child: _WorkoutPreview(
            workoutId: this.workoutId
          ),
        )        
      ),
    );
  }
}

class _WorkoutPreview extends StatefulWidget {
  final int workoutId;
  _WorkoutPreview({this.workoutId});

  @override
  _WorkoutPreviewState createState() => new _WorkoutPreviewState();
}

class _WorkoutPreviewState extends State<_WorkoutPreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _getWorkout, _toggleWorkoutFavorite, _workoutGetSuccessActionCreator;
  var _workout;
  var _isFavorite;

  @override
  void deactivate() {   
    _workoutGetSuccessActionCreator(null, null);
    super.deactivate(); 
  }

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    return new Scaffold(
      key: _scaffoldKey,
      body: new LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return new Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.6), 
                  BlendMode.darken
                ),
                image: NetworkImage(
                  _workout["thumbnail_url"]
                ),
                fit: BoxFit.cover
              ),
            ),
            child: new Column(                        
              children: <Widget>[
                new Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.fromLTRB(64, 64, 64, 4),
                        child: new Text(
                          _workout['name'], 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                          )
                        ),
                      ),
                      new Container(                              
                        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 4),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _workout['coach']['name'] != null ? 
                              new Container(  
                                child: new Text(
                                  _workout['coach']['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  )
                                ),                                    
                              )
                            : new Container(),
                            _workout['coach']['contact'] != null ? 
                              new Container(                                                       
                                child: new Text(
                                  _workout['coach']['contact'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )
                                )
                              )
                            : new Container(),
                            _workout['coach']['website'] != null ?
                              new Container(                                                       
                                child: new Text(
                                  _workout['coach']['website'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )
                                )
                              )
                            : new Container(),
                          ],
                        )
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0, 
                          horizontal: 64.0
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container (                                    
                              child: new Text(
                                "Duration: ${_workout['workout_duration']} mins",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )
                              ),
                            ),
                            _workout['mobility_duration'] > 0 ?
                              new Container(
                                width: 24.0,
                                height: 24.0,
                                child: new Image.asset(
                                  "assets/images/mobility.png",
                                  color: Colors.lightBlue
                                ),
                              )
                            : new Container(),
                            _workout['strength_duration'] > 0 ?
                              new Container(
                                width: 24.0,
                                height: 24.0,
                                child: new Image.asset(
                                  "assets/images/strength.png",
                                  color: Colors.lightGreen
                                ),
                              )
                            : new Container(),
                            _workout['metabolic_duration'] > 0 ?
                              new Container(
                                width: 24.0,
                                height: 24.0,
                                child: new Image.asset(
                                  "assets/images/metabolic.png",
                                  color: Colors.yellow
                                ),
                              )
                            : new Container(),
                            _workout['power_duration'] > 0 ?
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
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0, 
                          horizontal: 64.0
                        ),
                        child: new Text(
                          _workout['description'],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white70
                          ),
                        )
                      )
                    ],
                  ),
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0, 
                          horizontal: 64.0
                        ),
                        child: new MaterialButton(                                
                          height: 50.0, 
                          minWidth: 400.0,
                          color: Colors.grey,
                          highlightColor: dhfYellow,                                
                          child: new Text(
                            'Play Workout',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black, 
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => VideoPlay(
                                videoURL: _workout['video_url'],
                                videoType: "workout",
                                workoutId: _workout["id"],
                                workoutName: _workout["name"]
                              )),
                            );                                  
                          },
                        ),
                      ),
                      _workout['intro_video_guid'] != null ?
                        new Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0, 
                            horizontal: 64.0
                          ),
                          child: new MaterialButton(                                
                            height: 50.0, 
                            minWidth: 400.0,
                            color: Colors.grey,
                            highlightColor: dhfYellow,                                
                            child: new Text(
                              'Play Intro Video',
                              textScaleFactor: 1.5,
                            ),
                            textColor: Colors.black, 
                            onPressed: () {
                              Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => VideoPlay(
                                videoURL: _workout['intro_video_url'],
                                videoType: "intro_video",
                                workoutId: _workout["id"],
                                workoutName: _workout["name"]
                              )),
                            );
                            },
                          ),
                        )
                      : new Container(),
                      token != null ? 
                        _isFavorite ?                             
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, 
                              horizontal: 64.0
                            ),
                            child: new MaterialButton(                                
                              height: 50.0, 
                              minWidth: 400.0,
                              color: Colors.grey,
                              highlightColor: dhfYellow,                                
                              child: new Text(
                                'Remove from Favorites',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black, 
                              onPressed: () {
                                var params = new Map();
                                params["workout_id"] = _workout["id"];
                                params["is_favorite"] = _isFavorite;
                                _toggleWorkoutFavorite(context, params);
                              },
                            ),
                          ) 
                        : new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, 
                              horizontal: 64.0
                            ),
                            child: new MaterialButton(                                
                              height: 50.0, 
                              minWidth: 400.0,
                              color: Colors.grey,
                              highlightColor: dhfYellow,                                
                              child: new Text(
                                'Add to Favorites',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black, 
                              onPressed: () {
                                var params = new Map();
                                params["workout_id"] = _workout["id"];
                                params["is_favorite"] = _isFavorite;
                                _toggleWorkoutFavorite(context, params);
                              },
                            ),
                          )
                      : new Container(),
                      new Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0, 
                          horizontal: 64.0
                        ),                              
                        child: new MaterialButton(                                
                          height: 50.0, 
                          minWidth: 400.0,
                          color: Colors.grey,
                          highlightColor: dhfYellow,                                
                          child: new Text(
                            'Back',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black, 
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          );
        },
      ),
    );
  }


  Widget _drawSmallerDeviceWidget() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            "Preview"
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
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.6), 
                      BlendMode.darken
                    ),
                    image: NetworkImage(
                      _workout["thumbnail_url"]
                    ),
                    fit: BoxFit.cover
                  ),
                ),
                child: new Column(                        
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.fromLTRB(8, 32, 8, 4),
                            child: new Text(
                              _workout['name'], 
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              )
                            ),
                          ),
                          new Container(                              
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _workout['coach']['name'] != null ? 
                                  new Container(  
                                    child: new Text(
                                      _workout['coach']['name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      )
                                    ),                                    
                                  )
                                : new Container(),
                                _workout['coach']['contact'] != null ? 
                                  new Container(                                                       
                                    child: new Text(
                                      _workout['coach']['contact'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100
                                      )
                                    )
                                  )
                                : new Container(),
                                _workout['coach']['website'] != null ?
                                  new Container(                                                       
                                    child: new Text(
                                      _workout['coach']['website'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100
                                      )
                                    )
                                  )
                                : new Container(),
                              ],
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.0, 
                              horizontal: 8.0
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Container (                                    
                                  child: new Text(
                                    "Duration: ${_workout['workout_duration']} mins",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )
                                  ),
                                ),
                                _workout['mobility_duration'] > 0 ?
                                  new Container(
                                    width: 24.0,
                                    height: 24.0,
                                    child: new Image.asset(
                                      "assets/images/mobility.png",
                                      color: Colors.lightBlue
                                    ),
                                  )
                                : new Container(),
                                _workout['strength_duration'] > 0 ?
                                  new Container(
                                    width: 24.0,
                                    height: 24.0,
                                    child: new Image.asset(
                                      "assets/images/strength.png",
                                      color: Colors.lightGreen
                                    ),
                                  )
                                : new Container(),
                                _workout['metabolic_duration'] > 0 ?
                                  new Container(
                                    width: 24.0,
                                    height: 24.0,
                                    child: new Image.asset(
                                      "assets/images/metabolic.png",
                                      color: Colors.yellow
                                    ),
                                  )
                                : new Container(),
                                _workout['power_duration'] > 0 ?
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
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0, 
                              horizontal: 8.0
                            ),
                            child: new Text(
                              _workout['description'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white70
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                    new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, 
                              horizontal: 64.0
                            ),
                            child: new MaterialButton(                                
                              height: 50.0, 
                              minWidth: 400.0,
                              color: Colors.grey,
                              highlightColor: dhfYellow,                                
                              child: new Text(
                                'Play Workout',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black, 
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(builder: (context) => VideoPlay(
                                    videoURL: _workout['video_url'],
                                    videoType: "workout",
                                    workoutId: _workout["id"],
                                    workoutName: _workout["name"]
                                  )),
                                );                                  
                              },
                            ),
                          ),
                          _workout['intro_video_guid'] != null ?
                            new Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0, 
                                horizontal: 64.0
                              ),
                              child: new MaterialButton(                                
                                height: 50.0, 
                                minWidth: 400.0,
                                color: Colors.grey,
                                highlightColor: dhfYellow,                                
                                child: new Text(
                                  'Play Intro Video',
                                  textScaleFactor: 1.5,
                                ),
                                textColor: Colors.black, 
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  new MaterialPageRoute(builder: (context) => VideoPlay(
                                    videoURL: _workout['intro_video_url'],
                                    videoType: "intro_video",
                                    workoutId: _workout["id"],
                                    workoutName: _workout["name"]
                                  )),
                                );
                                },
                              ),
                            )
                          : new Container(),
                          token != null ? 
                            _isFavorite ?                             
                              new Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0, 
                                  horizontal: 64.0
                                ),
                                child: new MaterialButton(                                
                                  height: 50.0, 
                                  minWidth: 400.0,
                                  color: Colors.grey,
                                  highlightColor: dhfYellow,                                
                                  child: new Text(
                                    'Remove from Favorites',
                                    textScaleFactor: 1.5,
                                  ),
                                  textColor: Colors.black, 
                                  onPressed: () {
                                    var params = new Map();
                                    params["workout_id"] = _workout["id"];
                                    params["is_favorite"] = _isFavorite;
                                    _toggleWorkoutFavorite(context, params);
                                  },
                                ),
                              ) 
                            : new Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0, 
                                  horizontal: 64.0
                                ),
                                child: new MaterialButton(                                
                                  height: 50.0, 
                                  minWidth: 400.0,
                                  color: Colors.grey,
                                  highlightColor: dhfYellow,                                
                                  child: new Text(
                                    'Add to Favorites',
                                    textScaleFactor: 1.5,
                                  ),
                                  textColor: Colors.black, 
                                  onPressed: () {
                                    var params = new Map();
                                    params["workout_id"] = _workout["id"];
                                    params["is_favorite"] = _isFavorite;
                                    _toggleWorkoutFavorite(context, params);
                                  },
                                ),
                              )
                          : new Container(),                          
                        ],
                      ),
                    )
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
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.landscapeLeft,
    //      DeviceOrientation.landscapeRight,
    //      DeviceOrientation.portraitDown,
    //      DeviceOrientation.portraitUp]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getWorkout = stateObject["getWorkout"];
        _toggleWorkoutFavorite = stateObject["toggleWorkoutFavorite"];
        _workoutGetSuccessActionCreator = stateObject["homeFitWorkoutGetSuccessActionCreator"];
        var params = new Map();
        params['move_video_id'] = widget.workoutId;
        _getWorkout(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkout"] = (BuildContext context, Map params) =>
          store.dispatch(getWorkout(context, params));       
        returnObject["toggleWorkoutFavorite"] = (BuildContext context, Map params) =>
          store.dispatch(toggleWorkoutFavorite(context, params)); 
        returnObject["homeFitWorkoutGetSuccessActionCreator"] = (Map workout, bool isFavorite) =>
          store.dispatch(homeFitWorkoutGetSuccessActionCreator(workout, isFavorite)
        );                 
        returnObject["workout"] = store.state.homeFitWorkoutState.workout;
        returnObject["isFavorite"] = store.state.homeFitWorkoutState.isFavoriteWorkout;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workout = stateObject["workout"];
        _isFavorite = stateObject["isFavorite"];
        if(_workout != null) {
          if(mobileLayout) {
            return this._drawSmallerDeviceWidget();
          } else {
            return this._drawLargerDeviceWidget();
          }                    
        }else {
          return new Container();
        }
      }
    );
  }
}
