import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/views/workout_progression_build.dart';
import 'package:gomotive/workout/views/workout_schedule.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/workout/workout_utils.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutProgressions extends StatelessWidget {
  final int clientId;
  final int engagementId; // "engagement_id" or "group_id
  final int workoutId; // "workout_id" or "program_id"

  WorkoutProgressions({
    this.clientId,    
    this.engagementId,
    this.workoutId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutProgressions(
          clientId: this.clientId,
          engagementId: this.engagementId,
          workoutId: this.workoutId,          
        ),
      ),
    );
  }
}

class _WorkoutProgressions extends StatefulWidget {

  final int clientId;
  final int engagementId; // "engagement_id" or "group_id
  final int workoutId; // "workout_id" or "program_id"

  _WorkoutProgressions({
    this.clientId,    
    this.engagementId,
    this.workoutId
  });

  @override
  _WorkoutProgressionsState createState() => new _WorkoutProgressionsState();
}

class _WorkoutProgressionsState extends State<_WorkoutProgressions> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _deleteWorkoutProgressionAPI, _workoutPublishToggleAPI;

  Map _workout;  
  Map _clientObj;

  List<Widget> _listProgressions() {
    List<Widget> _list = new List<Widget>();
    if(_workout["progressions"] != null) {
      for(int i=0; i<_workout["progressions"].length; i++) {
        Container container = new Container(  
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[            
              new Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black12
                ),
                child: new Text(
                  _workout["progressions"][i]["name"],
                  style: TextStyle(
                    fontSize: 16.0,                  
                  ),
                  textAlign: TextAlign.center,
                ),
              ),                
              _workout["progressions"][i]["thumbnail_url"] != null
              ? new Container(
                  height: MediaQuery.of(context).size.height/3,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new NetworkImage(_workout["progressions"][i]["thumbnail_url"]),
                    ),
                  ),
                )              
              : new Container(),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _workout["schedule_type"] == 1 
                    ? new FlatButton(
                        onPressed: () { 
                          Map _workoutDateList = WorkoutUtils.getWorkoutScheduleDateList(_workout, _workout["progressions"][i]);
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new WorkoutSchedule(
                                workout:_workout,
                                workoutProgression: _workout["progressions"][i],
                                dateList: _workoutDateList,
                              ),
                            ),
                          );
                        },
                        color: primaryColor,  
                        child: new Text(
                          "SCHEDULE",
                          style: TextStyle(
                            color: primaryTextColor
                          )
                        ),                        
                      )
                    : new Container(),    
                    new FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new WorkoutProgressionBuild(
                              clientId: widget.clientId,
                              engagementId: widget.engagementId,
                              workoutId: widget.workoutId,
                              progressionId: _workout["progressions"][i]["id"],                   
                            ),
                          ),
                        );                    
                      },
                      color: primaryColor,  
                      child: new Text(
                        "EDIT",
                        style: TextStyle(
                          color: primaryTextColor
                        )
                      ),                      
                    ),                              
                    new FlatButton(
                      onPressed: () { 
                        CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to delete this workout progression?", "Yes, I am", "No").then((int response){
                          if(response == 1){
                            Map params = new Map();
                            params["workout_id"] = widget.workoutId;                            
                            params["workout_type"] = "engagement";
                            params["workout_type_id"] = widget.engagementId;
                            params["id"] = _workout["progressions"][i]["id"];
                            _deleteWorkoutProgressionAPI(context, params);                               
                          }
                        });                        
                      },
                      color: primaryColor,  
                      child: new Text(
                        "DELETE",
                        style: TextStyle(
                          color: primaryTextColor
                        )
                      ),                      
                    ),                                        
                  ],
                )
              )
            ],
          )         
        );
        _list.add(container);
      }
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _deleteWorkoutProgressionAPI = stateObject["deleteWorkoutProgression"];
        _workoutPublishToggleAPI = stateObject["workoutPublishToggleAPI"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["deleteWorkoutProgression"] = (BuildContext context, Map params) =>
            store.dispatch(deleteWorkoutProgression(context, params)); 
        returnObject["workoutPublishToggleAPI"] = (BuildContext context, Map params) =>
            store.dispatch(workoutPublishToggle(context, params));         
        returnObject["workout"] = store.state.workoutState.workoutObj;
        returnObject["clientObj"] = store.state.practitionerState.clientObj;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workout = stateObject["workout"];
        _clientObj = stateObject["clientObj"];
        if(_workout != null && _workout.keys.length > 0) {
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
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
              backgroundColor: Colors.white,
              title: new Text(
                'Workout',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                    
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: new FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      _workout["published"] ? 'UNPUBLISH' : 'PUBLISH',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () {
                      Map params = new Map();
                      params["id"] = _workout["id"];
                      params["is_publish"] = !_workout["published"];
                      params["client_id"] = widget.clientId;
                      params["engagement_id"] = widget.engagementId;                    
                      _workoutPublishToggleAPI(context, params);                                                
                    },
                  ),
                ),                              
              ]
            ), 
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new WorkoutProgressionBuild(
                      clientId: widget.clientId,
                      engagementId: widget.engagementId,
                      workoutId: widget.workoutId,
                      progressionId: null,                   
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
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                          
                          new Container(
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Center(
                              child: new Text(
                                "Create multiple workout progressions and click on Publish.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                )
                              )
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),    
                            child: new Column(   
                              crossAxisAlignment: CrossAxisAlignment.stretch,                         
                              children: _listProgressions(),
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
