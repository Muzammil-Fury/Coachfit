import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/workout/views/workout_progressions.dart';
import 'package:gomotive/workout/views/workout_progression_build.dart';
import 'package:gomotive/workout/views/engagement_workouts.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutSetup extends StatelessWidget {
  final int clientId;
  final int engagementId; // "engagement_id" or "group_id
  final int workoutId; // "workout_id" or "program_id"

  WorkoutSetup({
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
        child: _WorkoutSetup(
          clientId: this.clientId,
          engagementId: this.engagementId,
          workoutId: this.workoutId
        ),
      ),
    );
  }
}

class _WorkoutSetup extends StatefulWidget {
  final int clientId;
  final int engagementId;
  final int workoutId;  

  _WorkoutSetup({
    this.clientId,
    this.engagementId,
    this.workoutId
  });

  @override
  _WorkoutSetupState createState() => new _WorkoutSetupState();
}

class _WorkoutSetupState extends State<_WorkoutSetup> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  


  final TextEditingController _controller = new TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = Utils.convertStringToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: new DateTime(2100),
    );

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMMMMd().format(result);
      _workoutStartDate = new DateFormat("yyyy-MM-dd").format(result);
    });
  }


  String _name;
  String _description;
  int _introVideoId;
  String _workoutScheduleType = "2";
  int _workoutDuration;
  String _workoutStartDate;
  int _perDay = 0;
  int _perWeek = 0;

  Map _workout;
  List<Map> _introVideos, _workoutSchedules;
  Map _businessPartner;

  var _getWorkout, _saveWorkout, _clearWorkout;


  _workoutSetupSubmitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = new Map();
      params["name"] = _name;
      params["description"] = _description;
      params["total_days"] = _workoutDuration;
      params["start_date"] = _workoutStartDate;
      params["schedule_type"] = _workoutScheduleType;
      params["per_day"] = _perDay;
      params["per_week"] = _perWeek;
      params["intro"] = _introVideoId;      
      params["client_id"] = widget.clientId;            
      params["workout_type"] = "engagement";
      params["engagement_id"] = widget.engagementId;      
      if(widget.workoutId != null) {
        params["id"] = widget.workoutId;
      }
      params["partner_progression_count"] =_businessPartner["progression_count"];
      _saveWorkout(context, params);                 
    } else {
      CustomDialog.alertDialog(context, "Error", "Fix all the errors before submitting");
    }
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
        _getWorkout = stateObject["getWorkout"];
        _saveWorkout = stateObject["saveWorkout"];
        _clearWorkout = stateObject["clearWorkout"];
        Map params = new Map();
        params["workout_type"] = "engagement";
        params["engagement_id"] = widget.engagementId;              
        if(widget.workoutId != null) {
          params["id"] = widget.workoutId;          
        }
        _getWorkout(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkout"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkout(context, params));        
        returnObject["saveWorkout"] = (BuildContext context, Map params) =>
          store.dispatch(saveWorkout(context, params));
        returnObject["clearWorkout"] = () => 
          store.dispatch(WorkoutClearActionCreator());
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        returnObject["workout"] = store.state.workoutState.workoutObj;
        Map _supportingData = store.state.workoutState.supportingData;
        if(_supportingData != null) {
          if(_supportingData.containsKey("intro")) {
            returnObject["introVideos"] = Utils.parseList(_supportingData, "intro");
          }
          if(_supportingData.containsKey("schedule_type")) {
            returnObject["workoutSchedules"] = Utils.parseList(_supportingData, "schedule_type");
          }
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workout = stateObject["workout"];
        _introVideos = stateObject["introVideos"];
        _workoutSchedules = stateObject["workoutSchedules"];
        _businessPartner = stateObject["businessPartner"];
        if(_workout != null && _workout.keys.length > 0) {
          if(_workout["schedule_type"] != null) {
            _workoutScheduleType = _workout["schedule_type"].toString();
          }
          if(_workout["start_date"] != null) {
            _controller.text = Utils.convertDateStringToDisplayStringDate(_workout["start_date"]);
            _workoutStartDate = _workout["start_date"];
          }
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
                  this._clearWorkout();
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new EngagementWorkouts(
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                      ),
                    ),
                  );
                },
              ),
              actions: <Widget>[                
              ]
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
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          children: <Widget>[
                            new Container(    
                              width: MediaQuery.of(context).size.width,   
                              decoration: BoxDecoration(
                                color: Colors.blueGrey
                              ),                       
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: new Container(                                  
                                child: new Text(
                                  "Enter workout details and click on Save button.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(  
                                    color: Colors.white,                                  
                                  ),
                                )
                              ),                              
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                initialValue: _workout["name"],
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
                                  if(value == "" || value == null) {
                                    return 'Please enter the workout name';
                                  }
                                },
                                onSaved: (value) {
                                  _name = value;
                                },
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                initialValue: _workout["description"],
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,                                
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Description',
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
                                  _description = value;
                                },
                              ),
                            ),
                            _introVideos != null
                            ? new Container(
                                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                child: new DropdownFormField(
                                  initialValue: _workout["intro"],
                                  labelKey: "title",
                                  valueKey: "id",
                                  decoration: InputDecoration(
                                    border: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    labelText: 'Select Intro Video',
                                    labelStyle: new TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  options: _introVideos,
                                  onSaved: (value) {
                                    if(value != null && value != "") {
                                      _introVideoId = int.parse(value);
                                    }
                                  },
                                ),
                              )
                            : new Container(),
                            _workoutSchedules != null
                            ? new Container(
                                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                child: new DropdownFormField(
                                  decoration: InputDecoration(                                    
                                    border: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    labelText: 'Workout Type',
                                    labelStyle: new TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  options: _workoutSchedules,
                                  initialValue: _workoutScheduleType,                
                                  autovalidate: true,
                                  validator: (value) {                                  
                                    if(value != _workoutScheduleType) {
                                      _workoutScheduleType = value;
                                    }
                                  },                                  
                                ),
                              )
                            : new Container(),
                            _workoutScheduleType == "1" 
                            ? new Container(                            
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: new TextFormField(
                                  initialValue: _workout["total_days"].toString(),
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(                  
                                    labelText: 'Length in days',
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
                                      return 'Please select the workout duration';
                                    }
                                  },
                                  onSaved: (value) {
                                    if(value != "" && value != null) {
                                      _workoutDuration = int.parse(value);
                                    }
                                  },
                                ),
                              )
                            : new Container(),
                            _workoutScheduleType == "2" 
                            ? new Container(
                                child: new Column(
                                  children: <Widget>[
                                    new Container(                            
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: new TextFormField(
                                        initialValue: _workout["per_day"].toString(),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        style: new TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(                  
                                          labelText: 'Per Day',
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
                                            return 'Please enter per day numer';
                                          }
                                        },
                                        onSaved: (value) {
                                          if(value != "" && value != null) {
                                            _perDay = int.parse(value);
                                          }
                                        },
                                      ),
                                    ),
                                    new Container(                            
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: new TextFormField(
                                        initialValue: _workout["per_week"].toString(),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        style: new TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(                  
                                          labelText: 'Per Week',
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
                                            return 'Please enter per week numer';
                                          }
                                        },
                                        onSaved: (value) {
                                          if(value != "" && value != null) {
                                            _perWeek = int.parse(value);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                )  
                              )
                            : new Container(),
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),                             
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new TextFormField(
                                      // initialValue: _workout["start_date"],
                                      decoration: new InputDecoration(
                                        labelText: 'Start Date',
                                        labelStyle: new TextStyle(
                                          color: Colors.black87,
                                        ),
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      controller: _controller,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) { 
                                        if(value == "" || value == null) {
                                          return 'Please select the start date';
                                        }
                                      },
                                      onSaved: (value) { 
                                      },
                                    )
                                  ),
                                  new Container(                                  
                                    child: new IconButton(
                                      icon: new Icon(Icons.calendar_today),
                                      tooltip: 'Choose date',
                                      onPressed: (() {
                                        _chooseDate(context, _controller.text);
                                      }),
                                    )
                                  )
                                ]
                              ),             
                            ),
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 16, 8, 32),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: new FlatButton(
                                      color: primaryColor,                                
                                      child: new Text(
                                        'SAVE',
                                        style: TextStyle(
                                          color: primaryTextColor
                                        )
                                      ),
                                      onPressed: () {
                                        _workoutSetupSubmitForm();                                  
                                      },
                                    ),
                                  ),
                                  _workout["id"] != null
                                  ? new Container(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: new FlatButton(
                                        color: Colors.black12,                                
                                        child: new Text(
                                          'NEXT',
                                          style: TextStyle(
                                            color: Colors.black
                                          )
                                        ),
                                        onPressed: () {
                                          if(_businessPartner["progression_count"] == "m") {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder: (context) => new WorkoutProgressions(
                                                  clientId: widget.clientId,
                                                  engagementId: widget.engagementId,                              
                                                  workoutId: _workout["id"]       
                                                ),
                                              ),
                                            );                                  
                                          } else {
                                            int _progressionId;
                                            if(_workout["progressions"].length > 0){
                                              _progressionId = _workout["progressions"][0]["id"];                                              
                                            } else {
                                              _progressionId = null;
                                            }
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                builder: (context) => new WorkoutProgressionBuild(
                                                  clientId: widget.clientId,
                                                  engagementId: widget.engagementId,                              
                                                  workoutId: _workout["id"],
                                                  progressionId: _progressionId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),                                                      
                                    )
                                  : new Container(),
                                ],
                              )
                              
                              
                            )
                          ],
                        )
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
