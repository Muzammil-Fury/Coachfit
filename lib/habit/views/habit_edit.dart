import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/habit/habit_network.dart';
import 'package:gomotive/habit/habit_actions.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/habit/views/engagement_habits.dart';
import 'package:gomotive/core/app_config.dart';

class HabitEdit extends StatelessWidget {
  final int clientId;
  final int engagementId;
  final int habitId;
  HabitEdit({
    this.clientId,
    this.engagementId,
    this.habitId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new _HabitEdit(
          clientId: this.clientId,
          habitId: this.habitId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _HabitEdit extends StatefulWidget {
  final int clientId;
  final int engagementId;
  final int habitId;
  _HabitEdit({
    this.clientId,
    this.engagementId,
    this.habitId
  });

  _HabitEditState createState() => new _HabitEditState();
}

class _HabitEditState extends State<_HabitEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getEngagementHabitAPI, _clearEngagementHabitActionCreator, _saveEngagementHabitAPI;
  Map _habitObj;
  List<Map> _habitFrequencySchedules, _habitFrequencyDurationType;

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
      _habitStartDate = new DateFormat("yyyy-MM-dd").format(result);
    });
    
  }


  String _name;
  String _text;
  String _habitStartDate;
  int _scheduleType;
  int _scheduleWeekDay;
  int _scheduleMonthDate;
  int _durationType;
  int _durationCount;

  _saveHabit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = Map();
      params["client_id"] = widget.clientId;
      params["engagement_id"] = widget.engagementId;
      params["habit_id"] = widget.habitId;
      params["is_published"] = true;
      params["name"] = _name;
      params["text"] = _text;
      params["start_date"] = _habitStartDate;
      params["schedule_type"] = _scheduleType;
      params["schedule_week_day"] = _scheduleWeekDay;
      params["schedule_month_date"] = _scheduleMonthDate;
      params["duration_type"] = _durationType;
      params["duration_count"] = _durationCount;
      _saveEngagementHabitAPI(context, params);   
      CustomDialog.alertDialog(context, "Habit", "Habit has been saved for your client");
      this._clearEngagementHabitActionCreator();         
    }
  }


  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getEngagementHabitAPI = stateObject["getEngagementHabit"];
        _saveEngagementHabitAPI = stateObject["saveEngagementHabit"];
        _clearEngagementHabitActionCreator = stateObject["clearPractitionerEngagementHabitActionCreator"];
        Map _params = new Map();
        _params["id"] = widget.habitId;
        _params["engagement_id"] = widget.engagementId;
        _getEngagementHabitAPI(context, _params);

      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getEngagementHabit"] = (BuildContext context, Map params) =>
            store.dispatch(getEngagementHabit(context, params));  
        returnObject["saveEngagementHabit"] = (BuildContext context, Map params) =>
            store.dispatch(saveEngagementHabit(context, params));  
        returnObject["clearPractitionerEngagementHabitActionCreator"] = () =>
            store.dispatch(ClearEngagementHabitActionCreator());  
        returnObject["habitObj"] = store.state.habitState.habitObj;   
        returnObject["habitFrequencySchedules"] = store.state.habitState.habitFrequencySchedules;
        returnObject["habitFrequencyDurationType"] = store.state.habitState.habitFrequencyDurationType;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _habitFrequencySchedules = stateObject["habitFrequencySchedules"];
        _habitFrequencyDurationType = stateObject["habitFrequencyDurationType"];
        _habitObj = stateObject["habitObj"];
        if(_habitObj != null && _habitObj.keys.length > 0 && _habitFrequencySchedules != null && _habitFrequencyDurationType != null) {          
          if(_habitObj["start_date"] != null && _habitStartDate == null) {
            _habitStartDate = _habitObj["start_date"];
            _controller.text = Utils.convertDateStringToDisplayStringDate(_habitObj["start_date"]);
          }
          _scheduleType = _habitObj["schedule_type"];
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
                  this._clearEngagementHabitActionCreator();         
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new EngagementHabits(
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,
                      ),
                    ),
                  );                     
                },
              ),
              title: new Text(
                'Habit',             
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
                      _saveHabit();                                      
                    },
                  ),                
                ),              
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
                      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 0.0),
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[ 
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                initialValue: _habitObj != null ? _habitObj["name"] : "",
                                autofocus: false,
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
                                  if (value.trim().isEmpty) {
                                    return 'Please enter habit name';
                                  }
                                },
                                onSaved: (value) {                                
                                  _name = value;
                                },
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: new TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null, 
                                initialValue: _habitObj != null ? _habitObj["text"] : "",
                                autofocus: false,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                                
                                  labelText: 'Habit Text',
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
                                    return 'Please enter habit text';
                                  }
                                },
                                onSaved: (value) {    
                                  _text = value;                            
                                },
                              ),
                            ),  
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),                             
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new TextFormField(                                      
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
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                              child: new DropdownFormField(
                                decoration: InputDecoration(                                    
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  labelText: 'How frequently to follow this habit?',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                options: _habitFrequencySchedules,
                                initialValue: _scheduleType != null ? _scheduleType.toString() : null,                
                                autovalidate: true,
                                validator: (value) {                                  
                                  _scheduleType = int.parse(value);
                                },                                  
                              ),
                            ),
                            _scheduleType == 4
                            ? new Container(                            
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: _habitObj["schedule_week_day"] != null ? _habitObj["schedule_week_day"].toString() : "",
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(                                
                                    labelText: 'Which day of the week?',
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
                                    if(_scheduleType == 4 && value == "") {
                                      return 'Please enter day of the week';
                                    }                                
                                  },
                                  onSaved: (value) {                                
                                    _scheduleWeekDay = int.parse(value);
                                  },
                                ),
                              )
                            : new Container(),
                            _scheduleType == 5
                            ? new Container(                            
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                child: new TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: _habitObj["schedule_month_date"] != null ? _habitObj["schedule_month_date"].toString() : "",
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(                                
                                    labelText: 'Which day of the month?',
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
                                    if(_scheduleType == 5 && value == "") {
                                      return 'Please enter day of the month';
                                    }                              
                                  },
                                  onSaved: (value) {                       
                                    _scheduleMonthDate = int.parse(value);         
                                  },
                                ),
                              )
                            : new Container(),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: new TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: _habitObj["duration_count"].toString(),
                                autofocus: false,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                                
                                  labelText: 'How long to follow this habit?',
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
                                    return 'Please enter duration count';
                                  }                      
                                },
                                onSaved: (value) { 
                                  _durationCount = int.parse(value);                               
                                },
                              ),
                            ),  
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                              child: new DropdownFormField(
                                decoration: InputDecoration(                                    
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),                                  
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                options: _habitFrequencyDurationType,
                                initialValue: _habitObj["duration_type"] != null ? _habitObj["duration_type"].toString() : null,                
                                autovalidate: true,
                                validator: (value) {                                  
                                  _durationType = int.parse(value);
                                },                                  
                              ),
                            ),                                       
                          ]
                        )
                      )
                    ),
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

