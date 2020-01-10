import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/exercise/views/exercise_list.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/workout/views/workout_exercise_metrics.dart';
import 'package:gomotive/workout/views/workout_schedule.dart';
import 'package:gomotive/workout/workout_utils.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutProgressionBuild extends StatelessWidget {
  final int clientId;
  final int engagementId; // "engagement_id" or "group_id
  final int workoutId; // "workout_id" or "program_id"
  final int progressionId; // progression id

  WorkoutProgressionBuild({
    this.clientId,
    this.engagementId,
    this.workoutId,
    this.progressionId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutProgressionBuild( 
          clientId: this.clientId,
          engagementId: this.engagementId,
          workoutId: this.workoutId,
          progressionId: this.progressionId        
        ),
      ),
    );
  }
}

class _WorkoutProgressionBuild extends StatefulWidget {
  final int clientId;
  final int engagementId; // "engagement_id" or "group_id
  final int workoutId; // "workout_id" or "program_id"
  final int progressionId; // progression id

  _WorkoutProgressionBuild({
    this.clientId,
    this.engagementId,
    this.workoutId,
    this.progressionId
  });

  @override
  _WorkoutProgressionBuildState createState() => new _WorkoutProgressionBuildState();
}

class _WorkoutProgressionBuildState extends State<_WorkoutProgressionBuild> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _getWorkoutProgressionAPI, 
      _saveWorkoutProgressionAPI, 
      _clearWorkoutProgressionActionCreator,
      _deleteExerciseFromWorkoutProgressionActionCreator;

  Map _workoutProgression, _businessPartner, _workout;

  String _name;
  int _duration, _mobilityDuration, _strengthDuration, _metabolicDuration, _powerDuration;

  _saveWorkoutProgressionHandleSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = new Map();
      if(widget.progressionId != null) {
        params["id"] = widget.progressionId;          
      }
      if(_businessPartner["progression_count"] == "s") {
        params["name"] = _workoutProgression["name"];
      } else {
        params["name"] = _name;
      }
      params["days"] = _workoutProgression["days"];
      params["duration"] = _duration;
      params["mobility_duration"] = _mobilityDuration;
      params["strength_duration"] = _strengthDuration;
      params["metabolic_duration"] = _metabolicDuration;
      params["power_duration"] = _powerDuration;
      params["exercises"] = _workoutProgression["exercises"];
      params["workout_id"] = widget.workoutId;      
      params["workout_type"] = "engagement";
      params["engagement_id"] = widget.engagementId;
      params["client_id"] = widget.clientId;
      params["partner_progression_count"] = _businessPartner["progression_count"];
      _saveWorkoutProgressionAPI(context, params);            
    } else {
      CustomDialog.alertDialog(context, "Error", "Fix all the errors before submitting");
    }
  }

  List<Widget> _listWorkoutProgressionExercises() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_workoutProgression["exercises"].length; i++) {
      Map _exercise = _workoutProgression["exercises"][i];
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu slideMenu = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          title: new Container( 
            height: 80,                                      
            decoration: new BoxDecoration(                          
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ 
                new Row(
                  children: <Widget>[
                    _exercise["exercise_thumbnail_url"] != null 
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        width: MediaQuery.of(context).size.width*0.2,
                        height: 60,
                        child: new Thumbnail(                                    
                          url: _exercise["exercise_thumbnail_url"],
                        )
                      )
                    : new Container(
                      width: MediaQuery.of(context).size.width*0.2,
                      height: 60,
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      width: MediaQuery.of(context).size.width*0.8,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            child: new Text(
                              _exercise["name"],
                              maxLines: 2,
                            ),
                          ),
                          new Container(                            
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    _exercise["sets"] != null ? "Sets: " + _exercise["sets"].toString() : "Sets: 0",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w100,
                                    )
                                  )
                                ),
                                _exercise["metric"] == 1
                                ? new Container(
                                    child: new Text(
                                      _exercise["reps"] != null ? "Reps: " + _exercise["reps"].toString() : "Reps: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),
                                _exercise["metric"] == 2
                                ? new Container(
                                    child: new Text(
                                      _exercise["distance"] != null ? "Distance: " +  _exercise["distance"].toString() + " " + _exercise["__distance_unit"].toString() : "Distance: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),
                                _exercise["metric"] == 3
                                ? new Container(
                                    child: new Text(
                                      _exercise["duration"] != null ? "Duration: " + _exercise["duration"].toString() + " " + _exercise["__duration_unit"].toString() : "Duration: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),

                              ],
                            )
                          )
                        ],
                      )                                                
                    ),                                
                  ],
                )                                                                                                                              
              ]                            
            )
          )                        
        ),      
        menuItems: <Widget>[
          new GestureDetector(
            onTap: () {  
              CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to delete this exercise from workout progression", "Yes, I am", "No").then((int response){
                if(response == 1) {
                  this._deleteExerciseFromWorkoutProgressionActionCreator(i);
                }
              });              
            },
            child: new Container(
              color:Colors.redAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.delete,
                    color: Colors.white
                  ),                
                  new Text(
                    "DELETE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500
                    )
                  )              
                ]
              )
            ),
          ),
          new GestureDetector(
            onTap: () {  
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new WorkoutExerciseMetrics(
                    exerciseIndex: i,
                  ),
                ),
              );
            },
            child: new Container(
              color:Colors.greenAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.metric,
                    color: Colors.white
                  ),                
                  new Text(
                    "METRICS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                    )
                  )              
                ]
              )
            ),
          ),          
        ]
      );
      _list.add(slideMenu);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getWorkoutProgressionAPI = stateObject["getWorkoutProgression"];
        _saveWorkoutProgressionAPI = stateObject["saveWorkoutProgression"];  
        _clearWorkoutProgressionActionCreator = stateObject["clearWorkoutProgression"]; 
        _deleteExerciseFromWorkoutProgressionActionCreator = stateObject["deleteExerciseFromWorkoutProgressionActionCreator"];     
        Map params = new Map();
        params["workout_id"] = widget.workoutId;        
        if(widget.progressionId != null) {
          params["id"] = widget.progressionId;          
        }
        _getWorkoutProgressionAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutProgression"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutProgression(context, params));
        returnObject["saveWorkoutProgression"] = (BuildContext context, Map params) =>
            store.dispatch(saveWorkoutProgression(context, params));                
        returnObject["clearWorkoutProgression"] = () =>
            store.dispatch(WorkoutProgressionClearActionCreator());                            
        returnObject["deleteExerciseFromWorkoutProgressionActionCreator"] = (int exerciseIndex) =>
            store.dispatch(DeleteExerciseFromWorkoutProgressionActionCreator(exerciseIndex));                            
        returnObject["workout"] = store.state.workoutState.workoutObj;                
        returnObject["workoutProgression"] = store.state.workoutState.workoutProgressionObj;    
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) { 
        _workout = stateObject["workout"];
        _workoutProgression = stateObject["workoutProgression"];
        _businessPartner = stateObject["businessPartner"];
        if(_workout != null && _workout.keys.length > 0 && _workoutProgression != null && _workoutProgression.keys.length > 0) {
          _duration = _workoutProgression["duration"];       
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(   
              backgroundColor: Colors.white,
              title: new Text(
                'Workout',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                       
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  this._clearWorkoutProgressionActionCreator();
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: new FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      _businessPartner["progression_count"] == "m" ? "SAVE" : "PUBLISH",
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () {                      
                      _saveWorkoutProgressionHandleSubmitted();  
                    },
                  ),
                ),                
              ]
            ), 
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Map params = new Map();
                params['partners'] = [2];
                params['my_exercises'] = false;
                params['my_practice_exercise'] = false;
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ExerciseList(
                      usageType: "from_workout",  
                      exerciseSearchParams: params, 
                      clientId: widget.clientId,
                      engagementId: widget.engagementId,                
                    ),
                  ),
                );             
              },
              child: new Text(
                "ADD",
                style: TextStyle(
                  color: primaryTextColor
                )
              ),            
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,         
            body: new LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 48.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                          
                          _businessPartner["progression_count"] == "m" 
                          ? new Container(
                              width: MediaQuery.of(context).size.width,   
                              decoration: BoxDecoration(
                                color: Colors.blueGrey
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: new Center(
                                child: new Text(
                                  "Workout Progression Details.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white
                                  )
                                )
                              ),
                            )
                          : new Container(),
                          new Container(                    
                            child: new Form(
                              key: _formKey,
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _businessPartner["progression_count"] == "m"
                                  ? new Container(                            
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: new TextFormField(
                                        autofocus: false,
                                        initialValue: _workoutProgression["name"],
                                        style: new TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(                  
                                          labelText: 'Name',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if(_businessPartner["progression_count"] == "m") {
                                            if(value == "" || value == null) {
                                              return 'Please enter the workout name';
                                            }
                                          }
                                        },
                                        onSaved: (value) {
                                          _name = value;
                                        },
                                      ),
                                    )
                                  : new Container(),                                
                                  _workoutProgression["schedule_type"] == 1
                                  ?  new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),                             
                                      child: new Row(
                                        children: <Widget>[
                                          new Expanded(
                                            child: new TextFormField(
                                              enabled: false,
                                              // initialValue: _workout["start_date"],
                                              decoration: new InputDecoration(
                                                labelText: 'Select Dates',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              keyboardType: TextInputType.datetime,
                                              onSaved: (value) { 
                                              },
                                            )
                                          ),
                                          new Container(                                  
                                            child: new IconButton(
                                              icon: new Icon(Icons.calendar_today),
                                              tooltip: 'Choose date',
                                              onPressed: (() {
                                                Map _workoutDateList = WorkoutUtils.getWorkoutScheduleDateList(
                                                  _workout, _workoutProgression
                                                );                                                
                                                Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (context) => new WorkoutSchedule(
                                                      workout: _workout,
                                                      workoutProgression: _workoutProgression,
                                                      dateList: _workoutDateList,
                                                    ),
                                                  ),
                                                );                                              
                                              }),
                                            )
                                          )
                                        ]
                                      )
                                    )             
                                  : new Container(),
                                  new Container(                            
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: new TextFormField(   
                                      initialValue: _duration.toString(),                                     
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      style: new TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(                  
                                        labelText: 'Duration in minutes',
                                        labelStyle: new TextStyle(
                                          color: Colors.black87,
                                        ),
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),           
                                      validator: (value) {
                                        if(value == "" || value == null) {
                                          return 'Please enter the workout duration';
                                        }
                                      },                           
                                      onSaved: (value) {
                                        if(value != "" && value != null) {
                                          _duration = int.parse(value);                                          
                                        }
                                      },
                                    ),
                                  ),    
                                  _businessPartner != null && _businessPartner['show_movement_graph']
                                  ? new Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            width: MediaQuery.of(context).size.width,   
                                            decoration: BoxDecoration(
                                              color: Colors.black12
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                            child: new Text(
                                              "Contribution to Weekly Movement Goals",
                                              textAlign: TextAlign.center,
                                            )
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(          
                                              initialValue: _workoutProgression["mobility_duration"].toString(),                              
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Mobility in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),                                      
                                              onSaved: (value) {
                                                if(value != "" && value != null) {
                                                  _mobilityDuration = int.parse(value);                                          
                                                }
                                              },
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(        
                                              initialValue: _workoutProgression["strength_duration"].toString(),                                
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Strength in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {                                          
                                              },
                                              onSaved: (value) {
                                                if(value != "" && value != null) {
                                                  _strengthDuration = int.parse(value);                                          
                                                }
                                              },
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(          
                                              initialValue: _workoutProgression["metabolic_duration"].toString(),                              
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Metabolic in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {                                          
                                              },
                                              onSaved: (value) {
                                                if(value != "" && value != null) {
                                                  _metabolicDuration = int.parse(value);                                          
                                                }
                                              },
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(    
                                              initialValue: _workoutProgression["power_duration"].toString(),                                    
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Power in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {                                          
                                              },
                                              onSaved: (value) {
                                                if(value != "" && value != null) {
                                                  _powerDuration = int.parse(value);                                          
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    )
                                  : new Container(),                                                                
                                  new Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: new Column(
                                      children: <Widget>[
                                        new Text(
                                          "Add / Remove Exercises",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0
                                          )
                                        ),
                                        new Text(
                                          "Click on add button in bottom right corner to add new exercise. Right swipe the selected exercise and click on delete to remove an exercise from this progression.",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w100,
                                          )
                                        )
                                      ],
                                    ) 
                                  ),                                  
                                  _workoutProgression["exercises"] != null
                                  ? new Container(
                                      child: new Column(
                                        children: _listWorkoutProgressionExercises()
                                      )
                                    )
                                  : new Container(),                                  
                                ]
                              )
                            )
                          )
                        ]
                      )                                          
                    )
                  )
                );
              }
            )
          );
        } else {
          return new Container();
        }
      }       
    );
  }
}
