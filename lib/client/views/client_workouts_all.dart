import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/client/views/client_workouts_today.dart';
import 'package:gomotive/client/views/client_workout_progressions.dart';
import 'package:gomotive/core/app_config.dart';

class ClientWorkoutsAll extends StatelessWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  ClientWorkoutsAll({
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
        child: _ClientWorkoutsAll(
          id: id,
          type: type,
          displayProgramTitle: displayProgramTitle,
          fromExternal: fromExternal,
        ),
      ),
    );
  }
}

class _ClientWorkoutsAll extends StatefulWidget {
  final int id;
  final String type;
  final bool displayProgramTitle;
  final bool fromExternal;

  _ClientWorkoutsAll({
    this.id,
    this.type,
    this.displayProgramTitle,
    this.fromExternal,
  });

  @override
  _ClientWorkoutsAllState createState() => new _ClientWorkoutsAllState();
}

class _ClientWorkoutsAllState extends State<_ClientWorkoutsAll> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getAllWorkoutListAPI, 
      _clearWorkoutsActionCreator, 
      _clearProgramObjectActionCreator;
  Map _workouts;

  List<Widget> _displayAllWorkoutWidgets() {
    List<Widget> _list = new List<Widget>();
    Column c = new Column(        
      children: _displayAllWorkouts(
        _workouts["type"], 
        _workouts["name"], 
        Utils.parseList(_workouts,"workouts")
      )         
    );
    _list.add(c);
    return _list;
  }

  List<Widget> _displayAllWorkouts(String type, String name, List<Map> workouts) {
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
            widget.type == "engagement" ?
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
              workouts[i]["latest_version"]["name"],
              style: TextStyle(fontWeight: FontWeight.w500)
            )
          )
        );
        _list.add(workoutName);
        GestureDetector gestureDetector = new GestureDetector(
          onTap: () {                            
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ClientWorkoutProgressions(
                  id: workouts[i]["id"],
                ),
              ),
            );
          },
          child: new Stack(
            alignment: AlignmentDirectional.center,                              
            children: <Widget>[
              new Container(
                height: MediaQuery.of(context).size.height/3,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(workouts[i]["latest_version"]["image_url"])
                  ),
                ),
              ),
              new Positioned(  
                child: new Container(
                  child: new Icon(
                    Icons.play_circle_filled,
                    color: Colors.green,
                    size: 48.0,
                  )                                                            
                ),
              ),
            ],
          )
        );
        _list.add(gestureDetector);  
      }
    } else {
      Container descContainer1 = new Container(
        padding: EdgeInsets.fromLTRB(16, 64, 16, 0),
        child: new Center(
          child: new Text(
            "Your practitioner has not assigned any workouts for you.",
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
        _getAllWorkoutListAPI = stateObject["getAllWorkoutList"];
        _clearWorkoutsActionCreator = stateObject["clearWorkouts"];
        _clearProgramObjectActionCreator = stateObject["clearProgramObject"];        
        Map params = new Map();
        params["fetch_type"] = widget.type;
        params["id"] = widget.id;                
        _getAllWorkoutListAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getAllWorkoutList"] = (BuildContext context, Map params) =>
            store.dispatch(getAllWorkoutList(context, params));
        returnObject["clearWorkouts"] = () =>
          store.dispatch(AllWorkoutListClearActionCreator()
        );
        returnObject["clearProgramObject"] = () =>
          store.dispatch(ProgramObjectClearActionCreator()
        );                  
        returnObject["workouts"] = store.state.clientState.programAllWorkouts;
        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workouts = stateObject["workouts"];                
        if(_workouts != null && _workouts.keys.length > 0) {          
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
                  this._clearProgramObjectActionCreator();
                  this._clearWorkoutsActionCreator();
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: new Text(
                "All Workouts",             
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                new Container(                  
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
                  child: new OutlineButton(                                        
                    child: new Text(
                      "Today's Workouts",
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
                          builder: (context) => new ClientWorkoutsToday(
                            id: widget.id,
                            type: widget.type,
                            displayProgramTitle: widget.displayProgramTitle
                          ),
                        ),
                      );
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
                        children: _displayAllWorkoutWidgets()                        
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
