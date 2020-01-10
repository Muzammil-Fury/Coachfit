import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:intl/intl.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutSchedule extends StatelessWidget {
  final Map workout;
  final Map workoutProgression;
  final Map dateList;
  WorkoutSchedule({
    this.workout,
    this.workoutProgression,
    this.dateList
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutSchedule(
          workout: this.workout,
          workoutProgression: this.workoutProgression,
          dateList: this.dateList,
        ),
      ),
    );
  }
}

class _WorkoutSchedule extends StatefulWidget {
  final Map workout;
  final Map workoutProgression;
  final Map dateList;
  _WorkoutSchedule({
    this.workout,
    this.workoutProgression,
    this.dateList
  });

  @override
  _WorkoutScheduleState createState() => new _WorkoutScheduleState();
}

class _WorkoutScheduleState extends State<_WorkoutSchedule> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _workoutScheduleUpdateActionCreator;

  List<Widget> _listWorkoutScheduleDateList(){
    DateTime _startDate = DateTime.parse(widget.workout["start_date"].toString().replaceAll("-", ""));
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<widget.dateList.keys.length; i++) {
      int day = widget.dateList.keys.elementAt(i);
      DateTime _date = _startDate.add(new Duration(days: day-1));
      Container _container = new Container(
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(
              color: Colors.black12
            ),
          ),                              
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: new Text(
                new DateFormat.yMMMEd("en_US").format(_date)
              )
            ),
            new Container(
              child: new Checkbox(
                value: widget.dateList[day], 
                onChanged: (bool value) {
                  setState(() {
                    widget.dateList[day] = value;
                  });
                }
              )
            )
          ],
        )
      );
      _list.add(_container);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _workoutScheduleUpdateActionCreator = stateObject["workoutScheduleUpdateActionCreator"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["workoutScheduleUpdateActionCreator"] = (Map workout, Map workoutProgression) =>
            store.dispatch(WorkoutScheduleUpdateActionCreator(workout, workoutProgression));         
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
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
              "Schedule",             
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
                    List<int> _restDays = new List<int>();
                    List<int> _days = new List<int>();
                    for(int i=0; i<widget.dateList.keys.length; i++) {
                      int day = widget.dateList.keys.elementAt(i);
                      if(widget.dateList[day]) {
                        _days.add(day);
                      } else {
                        _restDays.add(day);
                      }
                    }
                    Map _workout = widget.workout;
                    Map _workoutProgression = widget.workoutProgression;
                    _workout["rest_days"] =_restDays;
                    _workoutProgression["days"] = _days;
                    this._workoutScheduleUpdateActionCreator(_workout, _workoutProgression);
                    Navigator.of(context).pop();
                  },
                ),                
              )
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
                    child: new Column(
                      children: _listWorkoutScheduleDateList(),
                    )
                  ),
                ),
              );
            },
          ),
        );
        
      }
    );
  }
}
