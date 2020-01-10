import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/client/views/client_tracking_goal_graph.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/core/app_config.dart';

class ClientTrackingGoal extends StatelessWidget {
  final String type;
  final int id;
  ClientTrackingGoal({
    this.type,
    this.id
  });  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientTrackingGoal(
          type: this.type,
          id: this.id,
        ),
      ),
    );
  }
}

class _ClientTrackingGoal extends StatefulWidget {
  final String type;
  final int id;
  _ClientTrackingGoal({
    this.type,
    this.id
  });  



  @override
  _ClientTrackingGoalState createState() => new _ClientTrackingGoalState();
}


class _ClientTrackingGoalState extends State<_ClientTrackingGoal> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _getDetailsAPI, _updateGoalTrackingAPI, _clearGoalTrackingDetailsActionCreator;
  Map _programObj;
  List<dynamic> _untrackedGoalDates;
  List<Map> _goalTrackingDetails;
  Map _goalTrackingValues = new Map();

  List<Widget> _displayGoalGraphDetails() {
    List<Widget> _list = new List<Widget>();
    List<Map> _goals;
    List<Map> _tempList;
    if(widget.type == "engagement") {
      _goals = Utils.parseList(_programObj, "goals");
    } else {
      _goals = [_programObj["goal"]];
      _tempList = Utils.parseList(_programObj["goal"], "client_goal_questions");
    }
    if((widget.type == 'engagement' && _goals.length > 0) || (widget.type == 'group' && _goals.length > 0 && _tempList.length > 0)) {
      for(int i=0; i<_goals.length; i++) {      
        List<Map> _goalTrackingList;
        if(widget.type == "engagement") {
          _goalTrackingList = Utils.parseList(_goals[i], "goal_tracking");
        } else {
          _goalTrackingList = Utils.parseList(_goals[i], "client_goal_questions");
        }
        for(int j=0; j<_goalTrackingList.length; j++) {
          Container _goalTrackingNameContainer = new Container(
            width: MediaQuery.of(context).size.width,             
            decoration: BoxDecoration(
              color: Colors.blueGrey
            ),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: new Text(
              widget.type == "engagement" ? _goalTrackingList[j]["track_question"] : _goalTrackingList[j]["question"],
              textAlign: TextAlign.center,
              style: TextStyle(  
                color: Colors.white, 
                fontSize: 16.0,                                 
              ),
            )
          );
          _list.add(_goalTrackingNameContainer);
          Container _trackingUnitContainer = new Container(
            width: MediaQuery.of(context).size.width,                       
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new Text(
              widget.type == "engagement" ? "Metric Unit: " + _goalTrackingList[j]["track_unit"]["unit_name"] : "Metric Unit: " + _goalTrackingList[j]["metric_unit"]["unit_name"],
              textAlign: TextAlign.center,
              style: TextStyle(  
                color: Colors.black87, 
                fontSize: 12.0,                                 
              ),
            )
          );
          _list.add(_trackingUnitContainer);
          if(widget.type == "engagement") {
            Container _defaultValueContainer = new Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Chip(        
                    backgroundColor: Colors.black26,        
                    label: Text(
                      _goalTrackingList[j]["initial_value"] != null ? 'Baseline Value: ' + _goalTrackingList[j]["initial_value"].toString() : 'Baseline Value: N/A',
                      style: TextStyle(
                        color: primaryTextColor
                      ),
                    )
                  ),  
                  new Chip(    
                    backgroundColor: Colors.black26,            
                    label: Text(
                      _goalTrackingList[j]["target_value"] != null ? 'Target Value: ' + _goalTrackingList[j]["target_value"].toString() : 'Target Value: N/A',
                      style: TextStyle(
                        color: primaryTextColor
                      ),
                    )
                  ),   
                ],
              )
            );
            _list.add(_defaultValueContainer);
            Container _currentValueContainer = new Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: new Chip(        
                backgroundColor: Colors.green,        
                label: Text(
                  _goalTrackingList[j]["current_value"] != null ? 'Current Value: ' + _goalTrackingList[j]["current_value"].toString() : 'Current Value: N/A',
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
              ),
            );
            _list.add(_currentValueContainer);
            Container _messageContainer = new Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: new Text(
                _goalTrackingList[j]["result_message"] != null ? _goalTrackingList[j]["result_message"] : "",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w100
                ),
                textAlign: TextAlign.center,
              )
            );
            _list.add(_messageContainer);
          }        
          Container _graphContainer = new Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: new FlatButton(
              color: primaryColor,                                
              child: new Text(
                'View Graph',
                style: TextStyle(
                  color: primaryTextColor
                )
              ),
              onPressed: () {        
                if(widget.type == "engagement") {
                  if(_goalTrackingList[j]["is_tracked"] == true) { 
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new ClientTrackingGoalGraph(
                          type: widget.type,
                          id: widget.id,
                          goalTrackId: _goalTrackingList[j]["id"]
                        ),
                      ),
                    );         
                  } else {
                    CustomDialog.alertDialog(context, "Track goals", "We will display the graph after you start tracking goals.");
                  }                          
                } else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ClientTrackingGoalGraph(
                        type: widget.type,
                        id: widget.id,
                        goalTrackId: _goalTrackingList[j]["id"]
                      ),
                    ),
                  );         
                }
              },
            ),
          );
          _list.add(_graphContainer);        
        }
      } 
      Container _emptyContainer = new Container(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0)
      );
      _list.add(_emptyContainer);
    } else {
      Container _noGoalContainer = new Container(      
        padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 8.0),      
        child: new Center(
          child: new Text(
            "Goal has not been defined"
          )
        )   
      );
      _list.add(_noGoalContainer);
    }
    return _list;
  }

  List<Widget> _displayGoalForm() {    
    List<Widget> _list = new List<Widget>();
    List<Map> _goals;
    if(widget.type == "engagement") {
      _goals = Utils.parseList(_programObj, "goals");
    } else {
      _goals = [_programObj["goal"]];
    }
    if(_goals.length > 0) {
      for(int i=0; i<_goals.length; i++) {      
        List<Map> _goalTrackingList;
        if(widget.type == "engagement") {
          _goalTrackingList = Utils.parseList(_goals[i], "goal_tracking");
        } else {
          _goalTrackingList = Utils.parseList(_goals[i], "client_goal_questions");
        }
        for(int j=0; j<_goalTrackingList.length; j++) {
          Container _goalTrackingMetricTextContainer = new Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),          
            child: new Text(
              widget.type == "engagement"
              ? _goalTrackingList[j]["track_question"] + " in " + _goalTrackingList[j]["track_unit"]["unit_name"]
              : _goalTrackingList[j]["question"] + " in " + _goalTrackingList[j]["metric_unit"]["unit_name"],
              textAlign: TextAlign.left,
            ),
          );
          _list.add(_goalTrackingMetricTextContainer);
          Container _goalTrackingMetricContainer = new Container(                            
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),          
            child: new TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              autofocus: false,
              style: new TextStyle(color: Colors.black87),
              decoration: InputDecoration(              
                border: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.black87,
                  ),
                ),
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Please enter current value';
                }
              },
              onSaved: (value) {
                _goalTrackingValues[_goalTrackingList[j]["id"].toString()] = value;
              },
            ),
          );
          _list.add(_goalTrackingMetricContainer);
        }
      }
    } else {
      Container _noGoalContainer = new Container(      
        padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 8.0),      
        child: new Center(
          child: new Text(
            "Goal has not been defined"
          )
        )   
      );
      _list.add(_noGoalContainer);
    }
    return _list;
  }

  _updateGoalTracking() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = new Map();      
      List<Map> _trackingDetails = new List<Map>();
      List<Map> _goals;
      if(widget.type == "engagement") {
        _goals = Utils.parseList(_programObj, "goals");
      } else {
        _goals = [_programObj["goal"]];
      }
      for(int i=0; i<_goals.length; i++) {      
        List<Map> _goalTrackingList;
        if(widget.type == "engagement") {
          _goalTrackingList = Utils.parseList(_goals[i], "goal_tracking");
        } else {
          _goalTrackingList = Utils.parseList(_goals[i], "client_goal_questions");
        }
        for(int j=0; j<_goalTrackingList.length; j++) {
          for(int k=0; k<_goalTrackingDetails.length; k++) {
            String _var;
            if(widget.type == "engagement") {
              _var = "client_engagement_goal_tracking";
            } else {
              _var = "group_goal_client_question";
            }
            if(_goalTrackingList[j]["id"] == _goalTrackingDetails[k][_var]) {
              Map _trackingObj = new Map();
              _trackingObj["id"] = _goalTrackingDetails[k]["id"];
              _trackingObj["current_value"] = _goalTrackingValues[_goalTrackingList[j]["id"].toString()];
              _trackingDetails.add(_trackingObj);
            }            
          }          
        }        
      }
      params["tracking_details"] = _trackingDetails;
      if(widget.type == "engagement") {
        params["engagement"] = _programObj["id"];
      } else {
        params["group_id"] = _programObj["id"];
      }
      _updateGoalTrackingAPI(context, params);
      setState((){

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _clearGoalTrackingDetailsActionCreator = stateObject["ClearGoalTrackingDetailsActionCreator"];
        if(widget.type == "engagement") {
          _getDetailsAPI = stateObject["getEngagementDetails"];
          _updateGoalTrackingAPI = stateObject["updateEngagementGoalTracking"];
          Map params = new Map();
          params["id"] = widget.id;
          _getDetailsAPI(context, params);
        } else {
          _getDetailsAPI = stateObject["getGroupDetails"];
          _updateGoalTrackingAPI = stateObject["updateGroupGoalTracking"];
          Map params = new Map();
          params["id"] = widget.id;
          _getDetailsAPI(context, params);
        }
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getEngagementDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getEngagementDetails(context, params));         
        returnObject["getGroupDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getGroupDetails(context, params));         
        returnObject["updateEngagementGoalTracking"] = (BuildContext context, Map params) =>
            store.dispatch(updateEngagementGoalTracking(context, params)); 
        returnObject["updateGroupGoalTracking"] = (BuildContext context, Map params) =>
            store.dispatch(updateGroupGoalTracking(context, params)); 
        returnObject["ClearGoalTrackingDetailsActionCreator"] = () =>
            store.dispatch(ClearGoalTrackingDetailsActionCreator());             
        returnObject["programObj"] = store.state.clientState.programObj;  
        returnObject["goalTrackingDetails"] = store.state.clientState.goalTrackingDetails;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _programObj = stateObject["programObj"];  
        _goalTrackingDetails = stateObject["goalTrackingDetails"];      
        if(_programObj != null && _programObj.keys.length > 0) {          
          _untrackedGoalDates = _programObj["client_untracked_goal_dates"];          
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
                  this._clearGoalTrackingDetailsActionCreator();
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                _programObj != null ? _programObj["name"] : "",             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),          
              actions: <Widget>[ 
                _untrackedGoalDates.length > 0
                ? new Container(
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
                        _updateGoalTracking();                                  
                      },
                    ),                
                  )
                : new Container(),
              ],
            ),
            body: new LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) { 
                if(_untrackedGoalDates.length > 0) {
                  return SingleChildScrollView( 
                    child: new ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: new Container(
                        child: new Form(
                          key: _formKey,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _displayGoalForm()
                          )
                        )
                      )
                    )
                  );
                } else {
                  return SingleChildScrollView( 
                    child: new ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: new Container(
                        child: new Form(
                          key: _formKey,
                          child: new Column(
                            children: _displayGoalGraphDetails()
                          )
                        )
                      )
                    )
                  );
                }                                              
              }
            )
          );
        } else {
          return Container();
        }
      }
    );
  }  
}