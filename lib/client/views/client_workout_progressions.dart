import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/client/views/client_workout_play.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class ClientWorkoutProgressions extends StatelessWidget {
  final int id;

  ClientWorkoutProgressions({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientWorkoutProgressions(
          id: id,
        ),
      ),
    );
  }
}

class _ClientWorkoutProgressions extends StatefulWidget {
  final int id;

  _ClientWorkoutProgressions({
    this.id,
  });

  @override
  _ClientWorkoutProgressionsState createState() => new _ClientWorkoutProgressionsState();
}

class _ClientWorkoutProgressionsState extends State<_ClientWorkoutProgressions> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  var _getWorkoutProgressionAPI,  _setSelectedWorkoutProgressionActionCreator;
  List<Map> _workouts;  

  List<Widget> _listWorkoutProgressions() {
    List<Widget> progressions = new List<Widget>();
    for(int i=0; i<_workouts.length; i++){
      Container workoutName = new Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100]
        ),
        child: new Center(
          child: new Text(
            _workouts[i]["name"],
            style: TextStyle(fontWeight: FontWeight.w500)
          )
        )
      );
      progressions.add(workoutName);

      GestureDetector gestureDetector = new GestureDetector(
        onTap: () {
          _setSelectedWorkoutProgressionActionCreator(_workouts[i]);
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new ClientWorkoutPlay(
                displayVideo: true,
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
                  image: new NetworkImage(_workouts[i]["thumbnail_url"])
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
      progressions.add(gestureDetector);  
    }
    return progressions;
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getWorkoutProgressionAPI = stateObject["getWorkoutProgression"];
        _setSelectedWorkoutProgressionActionCreator = stateObject["setSelectedWorkoutProgressionActioncreator"];
        Map params = new Map();
        params["id"] = widget.id;
        _getWorkoutProgressionAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutProgression"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutProgressions(context, params));
        returnObject["setSelectedWorkoutProgressionActioncreator"] = (Map selectedWorkoutProgression) =>
          store.dispatch(SetSelectedWorkoutProgressionActionCreator(selectedWorkoutProgression)
        );
        returnObject["workoutProgressions"] = store.state.clientState.workoutProgressionList;       
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workouts = stateObject["workoutProgressions"];   
        if(_workouts != null) {          
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
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                _workouts[0]["program_or_workout_name"],
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[                
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
                        children: _listWorkoutProgressions()
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
