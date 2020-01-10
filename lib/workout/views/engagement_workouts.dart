import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/views/workout_setup.dart';
import 'package:gomotive/workout/views/workout_template_list.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementWorkouts extends StatelessWidget {
  final int clientId;
  final int engagementId;
  EngagementWorkouts({
    this.clientId,
    this.engagementId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementWorkouts(
          clientId: this.clientId,
          engagementId: this.engagementId
        ),
      ),
    );
  }
}

class _EngagementWorkouts extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _EngagementWorkouts({
    this.clientId,
    this.engagementId
  });

  @override
  _EngagementWorkoutsState createState() => new _EngagementWorkoutsState();
}

class _EngagementWorkoutsState extends State<_EngagementWorkouts> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getClientEngagementWorkoutsAPI, _deleteWorkoutAPI;
  List<Map> _workouts;

  List<Widget> _listEngagementWorkouts() {
    List<Widget> _list = new List<Widget>();
    if(_workouts != null) {
      for(int i=0; i<_workouts.length; i++) {
        String workoutStatus = "";
        Color chipBackgroundColor = Colors.green;
        if(!_workouts[i]["published"]) {
          workoutStatus = "DRAFT";
          chipBackgroundColor = Colors.yellow;
        } else if(_workouts[i]["published"] && _workouts[i]["is_being_used"] && !_workouts[i]["is_completed"]) {
          workoutStatus = "ACTIVE";
        } else if(_workouts[i]["published"] && !_workouts[i]["is_being_used"]) {
          workoutStatus = "FUTURE";
        } else if(_workouts[i]["published"] && _workouts[i]["is_completed"]) {
          workoutStatus = "COMPLETED";
        }
        Container workoutContainer = new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blueGrey,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: new Text(
                  _workouts[i]["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                )
              ),
              new Container(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                child: new Text(
                  "Created By: " + _workouts[i]["practitioner"]["name"],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200
                  ),
                  textAlign: TextAlign.start,
                )
              ),
              _workouts[i]["workout_start_date"] != null ?
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  child: new Text(
                    "Start Date: " + Utils.convertDateStringToDisplayStringDate(_workouts[i]["workout_start_date"]),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200
                    ),
                    textAlign: TextAlign.start,
                  )
                )
              : new Container(),              
              _workouts[i]["image_url"] != null ?
                new Container(
                  child: new Stack(
                    alignment: AlignmentDirectional.topCenter,                              
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height/3,
                        decoration: new BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_workouts[i]["image_url"]),
                          ),
                        ),                        
                      ),              
                      new Positioned(  
                        child: new Chip(
                          backgroundColor: chipBackgroundColor,
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                                
                          label: new Text(
                            workoutStatus,
                            style: TextStyle(
                              fontSize: 16.0
                            )
                          ),
                        ),                                                            
                      ),
                    ],
                  )                
                )
              : new Container(
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new FlatButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new WorkoutSetup(
                              clientId: widget.clientId,
                              engagementId: widget.engagementId,
                              workoutId: _workouts[i]["id"],
                            ),
                          ),
                        );
                      },
                      child: new Text(
                        'EDIT',
                        style: TextStyle(
                          color:primaryTextColor
                        )
                      ),
                      color: primaryColor
                    ),
                    new FlatButton(
                      onPressed: () {
                        CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to delete this client workout?", "Yes, I am", "No").then((int response) {
                          if(response == 1) {
                            Map _params = new Map();
                            _params["id"] = _workouts[i]["id"];
                            _params["engagement_id"] = widget.engagementId;                        
                            _deleteWorkoutAPI(context, _params);                        
                          }
                        });                        
                      },
                      child: new Text(
                        'DELETE',
                        style: TextStyle(
                          color:primaryTextColor
                        )
                      ),
                      color:primaryColor,                      
                    ),                                        
                  ],
                )
              )
            ],
          )

        );
        _list.add(workoutContainer);
      }
    }    
    return _list;
  }
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getClientEngagementWorkoutsAPI = stateObject["getClientEngagementWorkouts"];
        _deleteWorkoutAPI = stateObject["deleteWorkout"];
        Map params = new Map();
        params["engagement_id"] = widget.engagementId;
        _getClientEngagementWorkoutsAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClientEngagementWorkouts"] = (BuildContext context, Map params) =>
            store.dispatch(getClientEngagementWorkouts(context, params));    
        returnObject["deleteWorkout"] = (BuildContext context, Map params) =>
            store.dispatch(deleteWorkout(context, params));    
        returnObject["workouts"] = store.state.workoutState.engagementWorkouts;    
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _workouts = stateObject["workouts"];
        if(_workouts != null) {
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new PractitionerClientHome(
                        clientId: widget.clientId,                          
                      ),
                    ),
                  );
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                'Workouts',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                     
              actions: <Widget>[                
              ],
            ),  
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {
                int trackResponse = await CustomDialog.createWorkout(context);
                if(trackResponse == 2) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new WorkoutTemplateList(
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                        searchParams: null,
                      ),
                    ),
                  );
                } else if(trackResponse == 1) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new WorkoutSetup(
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                        workoutId: null,
                      ),
                    ),
                  );
                }                
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),
                      child: _workouts.length > 0
                      ? new Column(
                          children: _listEngagementWorkouts()
                        )
                      : new Center(
                        child: new Text(
                          'There is no workouts assigned, please assign workout.',
                          textAlign: TextAlign.center,
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
