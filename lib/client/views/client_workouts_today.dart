import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/client/views/client_workouts_all.dart';
import 'package:gomotive/client/views/client_workout_play.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class ClientWorkoutsToday extends StatelessWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  ClientWorkoutsToday({
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
        child: _ClientWorkoutsToday(
          id: id,
          type: type,
          displayProgramTitle: displayProgramTitle,
          fromExternal: fromExternal,
        ),
      ),
    );
  }
}

class _ClientWorkoutsToday extends StatefulWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  _ClientWorkoutsToday({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal,
  });

  @override
  _ClientWorkoutsTodayState createState() => new _ClientWorkoutsTodayState();
}

class _ClientWorkoutsTodayState extends State<_ClientWorkoutsToday> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  
  var _getWorkoutListAPI, 
      _clearProgramObjectActionCreator,
      _clearWorkoutsActionCreator, 
      _setSelectedWorkoutProgressionActionCreator, 
      _trackWorkoutAPI;
  Map _programObj;  

  List<Widget> _displayTodaysWorkoutWidgets() {
    List<Widget> _list = new List<Widget>();    
    if(_programObj["action_type"] == "view_treatment") {
      Column c = new Column(        
        children: _displayTodaysWorkouts(
          _programObj["type"], 
          _programObj["name"], 
          Utils.parseList(_programObj,"progressions")          
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

  List<Widget> _displayTodaysWorkouts(
    String type, 
    String name, 
    List<Map> workouts
  ) {
    List<Widget> _list = new List<Widget>();
    if(widget.displayProgramTitle) {
      Container workoutType = new Container(
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
      _list.add(workoutType);
    }
    if(workouts.length > 0) {
      for(int i=0; i<workouts.length; i++){      
        Container workoutName = new Container(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100]
          ),
          child: new Center(
            child: new Text(
              workouts[i]["program_or_workout_name"],
              style: TextStyle(fontWeight: FontWeight.w500)
            )
          )
        );
        _list.add(workoutName);

        Container workoutDetails = new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                child: new Chip(                
                  label: Text(
                    workouts[i]["duration"].toString() + " min",
                    style: TextStyle(
                      fontWeight: FontWeight.w100
                    ),
                  )
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                child: new Chip(
                  label: Text(
                    workouts[i]["track_count"].toString() + " of " + workouts[i]["max_allowed_tracking"].toString() + " tracked",
                    style: TextStyle(
                      fontWeight: FontWeight.w100
                    ),
                  )
                )
              ),
            ],
          )
        );
        _list.add(workoutDetails);
        String workoutStartDateStr = workouts[i]["workout_start_date"].toString().replaceAll("-", "");
        DateTime workoutStartDate = DateTime.parse(workoutStartDateStr);
        DateTime todaysDate = DateTime.now();
        Duration difference = todaysDate.difference(workoutStartDate);
        String _newTxt = "";
        if(difference.inDays < 30) {
          _newTxt = "NEW";
        }
        Container workoutThumbnail = new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: new Stack(
            alignment: AlignmentDirectional.topCenter,                              
            children: <Widget>[
              new Container(
                height: MediaQuery.of(context).size.height/3,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(workouts[i]["thumbnail_url"]),
                  ),
                ),
              ),                                  
              _newTxt != ""
              ? new Positioned(  
                  child: new Chip(
                    backgroundColor: Colors.green, 
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                   
                    label: new Text(
                      _newTxt,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      )
                    ),
                  )                                                                          
                )
              : new Positioned( 
                  child: new Text(""),
                ),
            ],
          )        
        );
        _list.add(workoutThumbnail);

        Container workoutActions = new Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                child: new FlatButton(
                  color: primaryColor,                                
                  child: new Text(
                    'PLAY',
                    style: TextStyle(
                      color: primaryTextColor
                    )
                  ),
                  onPressed: () {
                    _setSelectedWorkoutProgressionActionCreator(workouts[i]);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new ClientWorkoutPlay(
                          displayVideo: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
              new Container(
                child: new FlatButton(
                  color: primaryColor,                                
                  child: new Text(
                    'PREVIEW',
                    style: TextStyle(
                      color: primaryTextColor
                    )
                  ),
                  onPressed: () {
                    _setSelectedWorkoutProgressionActionCreator(workouts[i]);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new ClientWorkoutPlay(
                          displayVideo: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
              new Container(
                child: new FlatButton(
                  color: primaryColor,                                
                  child: new Text(
                    'TRACK',
                    style: TextStyle(
                      color: primaryTextColor
                    )
                  ),
                  onPressed: () {
                    CustomDialog.trackDialog(context).then((int trackResponse) {
                      if(trackResponse != 0) {
                        Map params = new Map();
                        params["back"] = false;
                        params["program_id"] = widget.id;
                        params["fetch_type"] = widget.type;
                        params["progression_id"] = workouts[i]["id"];
                        params["has_tracked"] = trackResponse;
                        params["date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
                        _trackWorkoutAPI(context, params);
                      }
                    });                  
                  },
                ),
              )
            ],
          )
        );
        _list.add(workoutActions);
      }
    } else {
      Container descContainer1 = new Container(
        padding: EdgeInsets.fromLTRB(16, 64, 16, 0),
        child: new Center(
          child: new Text(
            "There are no workouts scheduled for today.",
            style: TextStyle(
              fontSize: 15.0
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
      _list.add(descContainer1);
      Container descContainer2 = new Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: new Center(
          child: new Text(
            "Click on 'ALL' button to view all workouts available for you.",
            style: TextStyle(
              fontSize: 12.0
            ),
            textAlign: TextAlign.center,
          ),
        )
      );
      _list.add(descContainer2);
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getWorkoutListAPI = stateObject["getWorkoutList"];
        _clearProgramObjectActionCreator = stateObject["clearProgramObject"];
        _clearWorkoutsActionCreator = stateObject["clearWorkouts"];
        _setSelectedWorkoutProgressionActionCreator = stateObject["setSelectedWorkoutProgressionActioncreator"];
        _trackWorkoutAPI = stateObject["trackWorkout"];
        Map params = new Map();
        params["fetch_type"] = widget.type;
        params["id"] = widget.id;
        params["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
        _getWorkoutListAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutList"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutList(context, params));
        returnObject["trackWorkout"] = (BuildContext context, Map params) =>
            store.dispatch(trackWorkout(context, params));
        returnObject["clearProgramObject"] = () =>
          store.dispatch(ProgramObjectClearActionCreator()
        );    
        returnObject["clearWorkouts"] = () =>
          store.dispatch(AllWorkoutListClearActionCreator()
        );             
        returnObject["setSelectedWorkoutProgressionActioncreator"] = (Map selectedWorkoutProgression) =>
          store.dispatch(SetSelectedWorkoutProgressionActionCreator(selectedWorkoutProgression)
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
                  this._clearWorkoutsActionCreator();
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
                "Today's Workouts",             
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                _programObj["action_type"] == "view_treatment"
                ? new Container(                  
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                    child: new OutlineButton(                                        
                      child: new Text(
                        'All Workouts',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: primaryTextColor
                        )
                      ),
                      borderSide: BorderSide(
                        color: primaryColor
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(40.0)),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ClientWorkoutsAll(
                              id: widget.id,
                              type: widget.type,
                              displayProgramTitle: widget.displayProgramTitle,
                              fromExternal: widget.fromExternal
                            ),
                          ),
                        );                               
                      },
                    ),                  
                  )
                : new Container(),
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
