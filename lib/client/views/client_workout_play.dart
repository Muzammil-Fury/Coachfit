import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/core/app_config.dart';

class ClientWorkoutPlay extends StatelessWidget {
  final int workoutId;
  final String fetchType;
  final bool displayVideo;

  ClientWorkoutPlay({
    this.workoutId,
    this.fetchType,
    this.displayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientWorkoutPlay(
          displayVideo: this.displayVideo,
        ),
      ),
    );
  }
}

class _ClientWorkoutPlay extends StatefulWidget {
  final int workoutId;
  final String fetchType;
  final bool displayVideo;

  _ClientWorkoutPlay({
    this.workoutId,
    this.fetchType,
    this.displayVideo,
  });

  @override
  _ClientWorkoutPlayState createState() => new _ClientWorkoutPlayState();
}

class _ClientWorkoutPlayState extends State<_ClientWorkoutPlay> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _trackWorkout, _clearWorkoutProgression;
  Map _workoutProgression;  
  List<Map> _exercises;  

  Widget videoOrThumbnailWidget;
  int _currentExerciseCount = 0;
  int _totalExercise = 0;

  bool _showExerciseDetails = false;
  String _exerciseFlow = "sequence";
  String displayTab = "metrics";

  _trackResponse() async {
    CustomDialog.trackDialog(context).then((int trackResponse) {
      if(trackResponse != 0) {
        Map params = new Map();
        params["back"] = true;
        params["program_id"] = widget.workoutId;
        params["fetch_type"] = widget.fetchType;
        params["progression_id"] = _workoutProgression["id"];    
        params["has_tracked"] = trackResponse;
        params["date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
        _trackWorkout(context, params);
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _trackWorkout = stateObject["trackWorkout"];  
        _clearWorkoutProgression = stateObject["clearWorkoutProgression"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["trackWorkout"] = (BuildContext context, Map params) =>
            store.dispatch(trackWorkout(context, params));
        returnObject["clearWorkoutProgression"] = () =>
          store.dispatch(WorkoutProgressionClearActionCreator()
        );            
        returnObject["workoutProgression"] = store.state.clientState.selectedWorkoutProgression;       
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workoutProgression = stateObject["workoutProgression"]; 
        if(_workoutProgression != null && _workoutProgression.keys.length > 0) {
          _exercises = Utils.parseList(_workoutProgression, "exercises");
          _totalExercise = _exercises.length;
          String setsText, repsText, distanceText, durationText, weightText, pauseText, holdText, heartRateText;
          List<Map> cueList, equipmentList;
          if(_workoutProgression["exercises"][_currentExerciseCount]["sets"] != null) {
            setsText = "Sets: " + _workoutProgression["exercises"][_currentExerciseCount]["sets"].toString();
          } else {
            setsText = "Sets: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["reps"] != null) {
            repsText = "Reps: " + _workoutProgression["exercises"][_currentExerciseCount]["reps"].toString();
          } else {
            repsText = "Reps: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["distance"] != null) {
            distanceText = "Distance: " + _workoutProgression["exercises"][_currentExerciseCount]["distance"].toString() + " " + _workoutProgression["exercises"][_currentExerciseCount]["distance_unit"].toString();
          } else {
            distanceText = "Distance: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["duration"] != null) {
            durationText = "Duration: " + _workoutProgression["exercises"][_currentExerciseCount]["duration"].toString() + " " + _workoutProgression["exercises"][_currentExerciseCount]["__duration_unit"].toString();
          } else {
            durationText = "Duration: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["weight"] != null) {
            weightText = "Weight: " + _workoutProgression["exercises"][_currentExerciseCount]["weight"].toString() + " " + _workoutProgression["exercises"][_currentExerciseCount]["__weight_unit"].toString();
          } else {
            weightText = "Weight: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["hold"] != null) {
            holdText = "Hold: " + _workoutProgression["exercises"][_currentExerciseCount]["hold"].toString() + " " + _workoutProgression["exercises"][_currentExerciseCount]["__hold_unit"].toString();
          } else {
            holdText = "Hold: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["pause"] != null) {
            pauseText = "Rest betw. Sets: " + _workoutProgression["exercises"][_currentExerciseCount]["pause"].toString() + " " + _workoutProgression["exercises"][_currentExerciseCount]["__pause_unit"].toString();
          } else {
            pauseText = "Rest betw. Sets: 0";
          }
          if(_workoutProgression["exercises"][_currentExerciseCount]["heart_rate"] != null) {
            heartRateText = "Heart rate: " + _workoutProgression["exercises"][_currentExerciseCount]["heart_rate"].toString() ;
          } else {
            heartRateText = "Heart rate: 0";
          }
          cueList = Utils.parseList(_workoutProgression["exercises"][_currentExerciseCount], "cues");
          equipmentList = Utils.parseList(_workoutProgression["exercises"][_currentExerciseCount], "equipments");
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
                  this._clearWorkoutProgression();
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                _workoutProgression["program_or_workout_name"],            
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[                
              ],
            ),   
            body: new Container(
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  widget.displayVideo && _exercises[_currentExerciseCount]['video_url'] != null
                  ? new Container(                    
                      child: new VideoApp(                        
                        videoUrl: _exercises[_currentExerciseCount]['video_url'],
                        autoPlay: true,                        
                        endOfVideo: () {                         
                          if(_exerciseFlow == "sequence") {                                                                                 
                            if((_currentExerciseCount+1) < _totalExercise){
                              setState((){
                                _currentExerciseCount = _currentExerciseCount + 1;
                                displayTab = "metrics";
                              });                              
                            } else {
                              _trackResponse();
                            }
                          }
                        },
                      )
                    )
                  : new Container(
                      height: MediaQuery.of(context).size.height/3,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_workoutProgression["exercises"][_currentExerciseCount]['exercise_thumbnail_url']),
                        ),
                      ),
                    ),
                  new Container(
                    decoration: new BoxDecoration(
                      color: Colors.grey[200],
                      border: new Border(
                        bottom: new BorderSide(
                          color: Colors.black12
                        ),
                      ),                              
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            if(_currentExerciseCount > 0) {
                              setState((){
                                _currentExerciseCount = _currentExerciseCount - 1;
                              });
                            }
                          },  
                          child: new Column(
                            children: <Widget>[
                              new Icon(                              
                                GomotiveIcons.back,
                                size: 20.0,
                                color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                child: new Text(
                                  'Previous',
                                  style: TextStyle(
                                    color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                                    fontSize: 12.0,
                                  ),
                                )
                              ),
                            ],
                          )                          
                        ),                                
                        new GestureDetector(
                          onTap: () {
                            if((_currentExerciseCount+1) < _totalExercise) {
                              setState((){
                                _currentExerciseCount = _currentExerciseCount + 1;
                              });
                            }                               
                          },  
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                GomotiveIcons.next,
                                size: 20.0,
                                color: ((_currentExerciseCount+1) == _totalExercise) ? Colors.grey : Colors.blue,
                              ),   
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                child: new Text(
                                  'Next',
                                  style: TextStyle(
                                    color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                                    fontSize: 12.0,
                                  ),
                                )
                              ),
                            ],
                          )                          
                        ),
                        new GestureDetector(
                          onTap: () {
                            setState(() {
                              _showExerciseDetails = !_showExerciseDetails;
                            });                               
                          },  
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                _showExerciseDetails ? GomotiveIcons.up_arrow : GomotiveIcons.down_arrow,
                                size: 20.0,
                                color: Colors.blue
                              ),  
                              new Container(
                                padding: EdgeInsets.fromLTRB(8, 6, 0, 0),   
                                child: new Text(
                                  _showExerciseDetails ? 'Hide Info' : 'Show Info',
                                  style: TextStyle(
                                    color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                                    fontSize: 12.0,
                                  ),
                                )
                              ),
                            ],
                          )                          
                        ),
                        new GestureDetector(
                          onTap: () {
                            setState(() {
                              if(_exerciseFlow == "sequence") {
                                _exerciseFlow = "loop";
                              } else {
                                _exerciseFlow = "sequence";
                              }
                            });                               
                          },  
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                _exerciseFlow == "sequence" ? GomotiveIcons.loop : GomotiveIcons.sequence,
                                size: 20.0,
                                color: Colors.blue
                              ),   
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                child: new Text(
                                  _exerciseFlow == "sequence" ? 'Loop' : 'Sequence',
                                  style: TextStyle(
                                    color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                                    fontSize: 12.0,
                                  ),
                                )
                              ),
                            ],
                          )                          
                        ),
                        new GestureDetector(
                          onTap: () async {
                            _trackResponse();
                          },  
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                GomotiveIcons.checkin,
                                size: 20.0,
                                color: Colors.blue
                              ),   
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                                child: new Text(
                                  'Track',
                                  style: TextStyle(
                                    color: _currentExerciseCount != 0 ? Colors.blue : Colors.grey,   
                                    fontSize: 12.0,
                                  ),
                                )
                              ),
                            ],
                          )                          
                        ),
                      ],
                    ),
                  ),
                  _showExerciseDetails ? 
                    new Container(      
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            color: Colors.black12,            
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new GestureDetector(
                                  onTap:() {
                                    setState(() {
                                      displayTab = "metrics";  
                                    });
                                  },
                                  child: new Container(
                                    child: new Text(
                                      'Metrics',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: displayTab == "metrics" ? Colors.black : Colors.blueGrey,
                                      )
                                    ),
                                  )
                                ),
                                new GestureDetector(
                                  onTap:() {
                                    setState(() {
                                      displayTab = "info";  
                                    });
                                  },
                                  child: new Container(
                                    child: new Text(
                                      'Info',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: displayTab == "info" ? Colors.black : Colors.blueGrey,
                                      )
                                    ),
                                  )
                                ),
                                new GestureDetector(
                                  onTap:() {
                                    setState(() {
                                      displayTab = "cues";  
                                    });
                                  },
                                  child: new Container(
                                    child: new Text(
                                      'Cues',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: displayTab == "cues" ? Colors.black : Colors.blueGrey,
                                      )
                                    ),
                                  )
                                ),
                                new GestureDetector(
                                  onTap:() {
                                    setState(() {
                                      displayTab = "equipment";  
                                    });
                                  },
                                  child: new Container(
                                    child: new Text(
                                      'Equipment',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: displayTab == "equipment" ? Colors.black : Colors.blueGrey,
                                      )
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          displayTab == "metrics"
                          ? new Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              height: 200,
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                          child: new Chip( 
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                            label: new Text(
                                              setsText,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),
                                        ),
                                        _workoutProgression["exercises"][_currentExerciseCount]['metric'] == 1
                                        ? new Container(
                                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                            child: new Chip( 
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                              label: new Text(
                                                repsText,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),                                            
                                          )
                                        : new Container(),
                                        _workoutProgression["exercises"][_currentExerciseCount]['metric'] == 2
                                        ? new Container(
                                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                            child: new Chip( 
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                              label: new Text(
                                                distanceText,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),                                            
                                          )
                                        : new Container(),
                                        _workoutProgression["exercises"][_currentExerciseCount]['metric'] == 3
                                        ? new Container(
                                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                            child: new Chip( 
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                              label: new Text(
                                                durationText,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),                                            
                                          )
                                        : new Container(),                                            
                                      ],
                                    )
                                  ),
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                          child: new Chip( 
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                            label: new Text(
                                              holdText,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                          child: new Chip( 
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                            label: new Text(
                                              pauseText,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),                                            
                                        ),                                            
                                      ],
                                    )
                                  ),
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                          child: new Chip( 
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                            label: new Text(
                                              weightText,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),
                                        ),                                         
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                          child: new Chip( 
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                            label: new Text(
                                              heartRateText,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              )
                                            ),
                                          ),                                            
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              )                                  
                            )
                          : new Container(),
                          displayTab == "info"
                          ? new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              height: 200,
                              child: new Text(
                                _workoutProgression["exercises"][_currentExerciseCount]["description"] != null ? _workoutProgression["exercises"][_currentExerciseCount]["description"] : ""
                              )
                            )
                          : new Container(),
                          displayTab == "cues"
                          ? new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              height: 200,
                              child: cueList.length > 0
                              ? new ListView.builder(                                    
                                  shrinkWrap: true,
                                  itemCount: cueList.length,
                                  itemBuilder: (context, i) {
                                    return new Container(
                                      child: new Center(
                                        child: new Text(
                                          cueList[i]["name"].toString()
                                        )
                                      )
                                    );
                                  }
                                )
                              : new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  child: new Text(
                                    "No cues have been assigned for this exercise.",
                                    textAlign: TextAlign.center,
                                  )
                                ),
                            )
                          : new Container(),
                          displayTab == "equipment"
                          ? new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              height: 200,
                              child: equipmentList.length > 0
                              ? new ListView.builder(                                    
                                  shrinkWrap: true,
                                  itemCount: equipmentList.length,
                                  itemBuilder: (context, i) {
                                    return new Container(
                                      child: new Center(
                                        child: new Text(
                                          equipmentList[i]["name"].toString()
                                        )
                                      ),
                                    );
                                  }
                                )
                              : new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  child: new Text(
                                    "No equipment have been assigned for this exercise.",
                                    textAlign: TextAlign.center
                                  )
                                ),
                            )
                          : new Container(),
                        ],
                      )
                    )
                  : new Container(),
                  new Expanded(
                    child: new SafeArea(
                      bottom: false,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _exercises.length,
                        itemBuilder: (context, i) {                  
                          return new GestureDetector(                      
                            onTap: () {
                              setState((){
                                _currentExerciseCount = i;
                                displayTab = "metrics";
                              });                                  
                            },
                            child: Container(                                  
                              decoration: new BoxDecoration(
                                color: _currentExerciseCount == i ? Colors.green[100] : Colors.transparent,
                                border: new Border(
                                  bottom: new BorderSide(
                                    color: Colors.black12
                                  ),
                                ),                              
                              ),
                              child: new Row(    
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container (
                                    width: 100,
                                    height: 80,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: new Thumbnail(
                                      url: _exercises[i]["exercise_thumbnail_url"]
                                    )                                        
                                  ),
                                  new Expanded (
                                    child: new Container(                                           
                                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),                                       
                                      child: new Text(
                                        _exercises[i]["name"]
                                      )                                      
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          );
                        },
                      )
                    )
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 32.0),
                  )
                ],
              )
            ),         
          );
        } else {
          return new Container();
        }
      }
    );
  }
}