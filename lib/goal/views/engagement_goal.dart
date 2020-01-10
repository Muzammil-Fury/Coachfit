import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/goal/goal_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/goal/views/goal_template_list.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementGoal extends StatelessWidget {
  final int clientId;
  final int engagementId;
  EngagementGoal({
    this.clientId,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementGoal(
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _EngagementGoal extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _EngagementGoal({
    this.clientId,
    this.engagementId,
  });


  @override
  _EngagementGoalState createState() => new _EngagementGoalState();
}

class _EngagementGoalState extends State<_EngagementGoal> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  
  var _getGoalTrackingUnitListAPI, _updateEngagementGoalAPI;
  Map _engagementObj;
  List<Map> _goals, _goalTrackingUnitList;

    
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _listGoalTracking() {
    List<Widget> _list = new List<Widget>();
    if(_goals != null) {
      for(int i=0; i<_goals[0]["goal_tracking"].length; i++) {
        Container _goalTrackingHeading = new Container(
          width: MediaQuery.of(context).size.width,   
          decoration: BoxDecoration(
            color: Colors.blueGrey
          ),                       
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new Container(    
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "Goal Metrics " + (i+1).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(  
                    color: Colors.white, 
                    fontSize: 16.0,                                 
                  ),
                ),
                new IconButton(                  
                  icon: Icon(
                    GomotiveIcons.delete,
                    size: 20.0,
                    color:Colors.white,
                  ),
                  onPressed: () {    
                    if(_goals[0]["goal_tracking"].length > 1) {            
                      CustomDialog.confirmDialog(
                        context, 
                        "Are you sure?", 
                        "Would you like to delete this goal metrics?", 
                        "Yes, I am", 
                        "No"
                      ).then((int response){
                        if(response == 1) {                        
                          setState(() {
                            _goals[0]["goal_tracking"].removeAt(i);
                          });
                        }
                      });
                    } else {
                      CustomDialog.alertDialog(context, "Goal metric cannot be deleted", "Your client goal must have at least 1 goal metric.");
                    }
                  },
                ),
              ],
            )                                          
          ),                              
        );
        _list.add(_goalTrackingHeading);
        Container _goalTrackingContainer = new Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new TextFormField(
            autofocus: false,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: new TextStyle(color: Colors.black87),
            initialValue: _goals[0]["goal_tracking"][i]["track_question"],            
            decoration: InputDecoration(                                    
              labelText: 'Quantifiable measure to reach this goal',
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
              if (value.trim().isEmpty) {
                return 'Please enter goal metrics text';
              }
            },
            onSaved: (value) {
              _goals[0]["goal_tracking"][i]["track_question"] = value;              
            },
          ),
        );
        _list.add(_goalTrackingContainer);
        Container _goalTrackingUnitContainer = new Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new DropdownFormField(
            labelKey: "unit_name",
            valueKey: "id",
            decoration: InputDecoration(   
              labelText: 'Metric Unit',
              labelStyle: new TextStyle(
                color: Colors.black87,
              ),
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: Colors.black87,
                ),
              ),                                                
            ),
            options: _goalTrackingUnitList,
            initialValue: _goals[0]["goal_tracking"][i]["track_unit"] != null ? _goals[0]["goal_tracking"][i]["track_unit"]["id"].toString() : null,                
            autovalidate: true,
            validator: (value) {
              if(value != null) {
                if(_goals[0]["goal_tracking"][i]["track_unit"] != null) {
                  _goals[0]["goal_tracking"][i]["track_unit"]["id"] = value;
                } else {
                  Map _trackUnit = new Map();
                  _trackUnit["id"] = value;
                  _goals[0]["goal_tracking"][i]["track_unit"] = _trackUnit;
                }
              } else {
                return 'Please select goal metric';
              }
            },                                  
          ),
        );
        _list.add(_goalTrackingUnitContainer);
        Container _baseLineValueContainer = new Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new TextFormField(
            autofocus: false,
            keyboardType: TextInputType.number,
            style: new TextStyle(color: Colors.black87),
            initialValue: _goals[0]["goal_tracking"][i]["initial_value"] != null ? _goals[0]["goal_tracking"][i]["initial_value"].toString() : "",
            decoration: InputDecoration(                                    
              labelText: 'Base Line Value',
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
              if (value.trim().isEmpty) {
                return 'Please enter base line value';
              }
            },
            onSaved: (value) { 
              _goals[0]["goal_tracking"][i]["initial_value"] = value;             
            },
          ),
        );
        _list.add(_baseLineValueContainer);
        Container _targetValueContainer = new Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new TextFormField(
            autofocus: false,
            keyboardType: TextInputType.number,
            style: new TextStyle(color: Colors.black87),
            initialValue: _goals[0]["goal_tracking"][i]["target_value"] != null ? _goals[0]["goal_tracking"][i]["target_value"].toString() : "",
            decoration: InputDecoration(                                    
              labelText: 'Target Value',
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
              if (value.trim().isEmpty) {
                return 'Please enter target value';
              }
            },
            onSaved: (value) { 
              _goals[0]["goal_tracking"][i]["target_value"] = value;             
            },
          ),
        );
        _list.add(_targetValueContainer);
      }
      Container _addTrackingQuestionContainer = new Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: new FlatButton(
          color: primaryColor,                                
          child: new Text(
            'Add Goal Metric',
            style: TextStyle(
              color: primaryTextColor
            )
          ),
          onPressed: () {
            Map _newGoalTracking = new Map();
            _newGoalTracking["track_question"] = null;
            _newGoalTracking["track_unit"] = null;
            _newGoalTracking["initial_value"] = null;
            _newGoalTracking["target_value"] = null;
            setState(() {
              _goals[0]["goal_tracking"].add(_newGoalTracking);
            });
          },
        ),
      );
      _list.add(_addTrackingQuestionContainer);
    }
    return _list;
  }

  _updateGoals() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = new Map();
      params["engagement"] = widget.engagementId;
      params["client_goals"] = _goals;
      _updateEngagementGoalAPI(context, params);
    } else {
      CustomDialog.alertDialog(context, "Invalid", "Kindly update all fields highlighted in red");
    }        
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) { 
        _getGoalTrackingUnitListAPI = stateObject["getGoalTrackingUnitList"];     
        _updateEngagementGoalAPI = stateObject["updateEngagementGoal"];
        _getGoalTrackingUnitListAPI(context, {});
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map(); 
        returnObject["getGoalTrackingUnitList"] = (BuildContext context, Map params) =>
            store.dispatch(getGoalTrackingUnitList(context, params));           
        returnObject["updateEngagementGoal"] = (BuildContext context, Map params) =>
            store.dispatch(updateEngagementGoal(context, params));           
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;
        if(returnObject["engagement"] != null) {
          _goals = Utils.parseList(returnObject["engagement"], "goals");
        }
        returnObject["goalTrackingUnitList"] = store.state.goalState.goalTrackingUnitList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _engagementObj = stateObject["engagement"]; 
        _goalTrackingUnitList = stateObject["goalTrackingUnitList"];       
        if(_engagementObj != null && _goalTrackingUnitList != null) {          
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
                'Goals',
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                     
              actions: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      'Submit',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () { 
                      _updateGoals();
                    },
                  ),                
                ),
              ],
            ),  
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {   
                if(_goals.length > 0) {
                  CustomDialog.alertDialog(context, "Goal", "You have already defined goal for this client");
                } else {
                  CustomDialog.createGoal(context).then((int response){
                    if(response == 2) {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new GoalTemplateList(
                            clientId: widget.clientId,
                            engagementId: widget.engagementId,                  
                          ),
                        ),
                      );
                    } else if(response == 1) {
                      Map _newGoal = new Map();
                      _newGoal["text"] = null;
                      _newGoal["goal_tracking"] = new List<Map>();
                      Map _newGoalTracking = new Map();
                      _newGoalTracking["track_question"] = null;
                      _newGoalTracking["track_unit"] = null;
                      _newGoalTracking["initial_value"] = null;
                      _newGoalTracking["target_value"] = null;                      
                      _newGoal["goal_tracking"].add(_newGoalTracking);                      
                      setState(() {
                        _goals = new List<Map>();
                        _goals.add(_newGoal);
                      });                      
                    }
                  });    
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
                      child: _goals.length > 0
                      ? new Form(
                          key: _formKey,
                          child: new Column(
                            children: <Widget>[
                              new Container(                            
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                child: new TextFormField(
                                  autofocus: false,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: new TextStyle(color: Colors.black87),
                                  initialValue: _goals[0]["text"],
                                  decoration: InputDecoration(                                    
                                    labelText: 'Goal Text',
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
                                    if (value.trim().isEmpty) {
                                      return 'Please enter goal text';
                                    }
                                  },
                                  onSaved: (value) {
                                    _goals[0]["text"] = value;
                                  },
                                ),
                              ),
                              new Column(
                                children: _listGoalTracking()
                              )
                            ],
                          )
                        )
                      : new Center(
                        child: new Text(                          
                          "No goals have been assigned. Kindly click on Add to assign one.",
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
