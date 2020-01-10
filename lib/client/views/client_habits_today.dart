import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/core/app_config.dart';

class ClientHabitsToday extends StatelessWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  ClientHabitsToday({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal: false,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientHabitsToday(
          id: id,
          type: type,
          displayProgramTitle: displayProgramTitle,
          fromExternal: fromExternal,
        ),
      ),
    );
  }
}

class _ClientHabitsToday extends StatefulWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  _ClientHabitsToday({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal,
  });

  @override
  _ClientHabitsTodayState createState() => new _ClientHabitsTodayState();
}

class _ClientHabitsTodayState extends State<_ClientHabitsToday> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  
  var _getHabitListAPI, 
      _clearProgramObjectActionCreator, 
      _trackEngagementHabitAPI,
      _trackGroupHabitAPI;
  Map _programObj;  


  _trackHabit(int habitTrackId, int trackStatus) {
    if(widget.type == "engagement") {
      Map _params = new Map();
      _params["engagement_id"] = widget.id;
      _params["habit_track_id"] = habitTrackId;
      _params["track_status"] = trackStatus;
      _params["fetch_type"] = widget.type;
      _params["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
      _trackEngagementHabitAPI(context, _params);
    } else {
      Map _params = new Map();
      _params["group_id"] = widget.id;
      _params["habit_track_id"] = habitTrackId;
      _params["track_status"] = trackStatus;
      _params["fetch_type"] = widget.type;
      _params["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
      _trackGroupHabitAPI(context, _params);
    }
  }

  List<Widget> _displayTodaysWorkoutWidgets() {
    List<Widget> _list = new List<Widget>();    
    if(_programObj["action_type"] == "view_treatment") {
      Column c = new Column(  
        crossAxisAlignment: CrossAxisAlignment.start,      
        children: _displayTodaysHabit(
          _programObj["type"], 
          _programObj["name"], 
          Utils.parseList(_programObj,"habits")          
        )         
      );
      _list.add(c);
    } else if(_programObj["action_type"] == "display_payment") {
      Container c = new Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
        child: new Center(
          child: Text(
            _programObj["mobile_display_text"]
          ),
        )
      );
      _list.add(c);
    }
    return _list;
  }

  List<Widget> _displayTodaysHabit(
    String type, 
    String name, 
    List<Map> habits
  ) {
    List<Widget> _list = new List<Widget>();
    if(widget.displayProgramTitle) {
      Container programType = new Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[300]
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            type == "engagement" ?
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Icon(
                  GomotiveIcons.game_plan,
                  color: Colors.white,
                )
              )
            : new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Icon(
                  GomotiveIcons.group,
                  color: Colors.white,
                ),
              ),
            new Flexible(
              child: new Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: new Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              )
            )
          ],        
        )
      );
      _list.add(programType);
    }
    if(habits.length > 0) {
      for(int i=0; i<habits.length; i++) {
        Color _trackColor = Colors.grey[100];
        Color _trackTextColor = Colors.black;
        if(habits[i]["has_tracked"] == 1) {
          _trackColor = Colors.red;
          _trackTextColor = Colors.white;
        } else if(habits[i]["has_tracked"] == 2) {
          _trackColor = Colors.blue;
          _trackTextColor = Colors.white;
        } else if(habits[i]["has_tracked"] == 3) {
          _trackColor = Colors.green;
          _trackTextColor = Colors.white;
        }
        Container _habitContainer = new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              widget.type == "engagement" 
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100]
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: new Text(
                    habits[i]["client_engagement_habit"]["name"],
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                    textAlign: TextAlign.center,
                  )
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100]
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: new Text(
                    habits[i]["group_habit"]["name"],
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
              widget.type == "engagement"
              ? new Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100]
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: new Text(
                    habits[i]["client_engagement_habit"]["text"],
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.left,
                  )
                )
              : new Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100]
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: new Text(
                    habits[i]["group_habit"]["text"],
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.left,
                  )
                ),
              widget.type == "engagement" && habits[i]["client_engagement_habit"]["video_url"] != null
              ? new Container(                          
                  child: new VideoApp(
                    videoUrl: habits[i]["client_engagement_habit"]["video_url"],
                    autoPlay: false,
                  ),
                )
              : new Container(),
              widget.type == "group" && habits[i]["group_habit"]["video_url"] != null
              ? new Container(                          
                  child: new VideoApp(
                    videoUrl: habits[i]["group_habit"]["video_url"],
                    autoPlay: false,
                  ),
                )
              : new Container(),
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.type == "engagement"
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                        child: new Chip(                
                          label: Text(
                            'Frequency: ' + habits[i]["client_engagement_habit"]["__schedule_type"],
                            style: TextStyle(
                              fontWeight: FontWeight.w100
                            ),
                          )
                        ),                      
                      )
                    : new Container(
                        padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                        child: new Chip(                
                          label: Text(
                            'Frequency: ' + habits[i]["group_habit"]["__schedule_type"],
                            style: TextStyle(
                              fontWeight: FontWeight.w100
                            ),
                          )
                        ),                      
                      ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 0, 4),
                      child: new Chip( 
                        backgroundColor: _trackColor,               
                        label: Text(
                          habits[i]["__has_tracked"],
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: _trackTextColor,
                          ),
                          
                        )
                      ),                      
                    ),                    
                  ],
                )
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: new FlatButton(
                        color: Colors.grey[400],                                
                        child: new Text(
                          'DID IT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          )
                        ),
                        onPressed: () {   
                          _trackHabit(
                            habits[i]["id"],
                            3
                          );                       
                        },
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: new FlatButton(
                        color: Colors.grey[400],                               
                        child: new Text(
                          'DID PART OF IT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          )
                        ),
                        onPressed: () { 
                          _trackHabit(
                            habits[i]["id"],
                            2
                          );                         
                        },
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: new FlatButton(
                        color: Colors.grey[400],                                
                        child: new Text(
                          'DID NOT DO IT',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          )
                        ),
                        onPressed: () { 
                          _trackHabit(
                            habits[i]["id"],
                            1
                          );                         
                        },
                      ),
                    )
                  ],
                )
              )
            ],
          ),          
        );
        _list.add(_habitContainer);
      }
    } else {
      Container descContainer1 = new Container(
        padding: EdgeInsets.fromLTRB(16, 64, 16, 0),
        child: new Center(
          child: new Text(
            "There are no habits scheduled for today.",
            style: TextStyle(
              fontSize: 15.0
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
      _list.add(descContainer1);
    }
    return _list;
  }


  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getHabitListAPI = stateObject["getHabitList"];  
        _trackEngagementHabitAPI = stateObject["trackEngagementHabit"];
        _trackGroupHabitAPI = stateObject["trackGroupHabit"];
        _clearProgramObjectActionCreator = stateObject["clearProgramObject"];      
        Map params = new Map();
        params["fetch_type"] = widget.type;
        params["id"] = widget.id;
        params["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
        _getHabitListAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getHabitList"] = (BuildContext context, Map params) =>
            store.dispatch(getHabitList(context, params));        
        returnObject["trackEngagementHabit"] = (BuildContext context, Map params) =>
            store.dispatch(trackEngagementHabit(context, params));        
        returnObject["trackGroupHabit"] = (BuildContext context, Map params) =>
            store.dispatch(trackGroupHabit(context, params));        
        returnObject["clearProgramObject"] = () =>
          store.dispatch(ProgramObjectClearActionCreator()
        );                 
        returnObject["programObj"] = store.state.clientState.programObj;       
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _programObj = stateObject["programObj"];   
        if(_programObj != null && _programObj.keys.length > 0) {          
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  this._clearProgramObjectActionCreator();
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {                    
                    Navigator.of(context).pop();
                  }
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                "Today's Habits",             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                // new Container(                  
                //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                //   child: new GestureDetector(
                //     onTap: () {                      
                //     },
                //     child: new Text(
                //       'ALL',
                //       style: TextStyle(
                //         color: primaryColor
                //       )
                //     ),
                //   ),                
                // ),             
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _displayTodaysWorkoutWidgets()
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
