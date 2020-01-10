import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/views/workout_template_progression_build.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutTemplateProgressions extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutTemplateProgressions(
        ),
      ),
    );
  }
}

class _WorkoutTemplateProgressions extends StatefulWidget {
  
  @override
  _WorkoutTemplateProgressionsState createState() => new _WorkoutTemplateProgressionsState();
}

class _WorkoutTemplateProgressionsState extends State<_WorkoutTemplateProgressions> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  Map _workoutTemplate;  
  
  List<Widget> _listProgressions() {
    List<Widget> _list = new List<Widget>();
    if(_workoutTemplate["progressions"] != null) {
      for(int i=0; i<_workoutTemplate["progressions"].length; i++) {
        Container container = new Container(  
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[            
              new Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black12
                ),
                child: new Text(
                  _workoutTemplate["progressions"][i]["name"],
                  style: TextStyle(
                    fontSize: 16.0,                  
                  ),
                  textAlign: TextAlign.center,
                ),
              ),                
              _workoutTemplate["progressions"][i]["thumbnail_url"] != null
              ? new Container(
                  height: MediaQuery.of(context).size.height/3,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new NetworkImage(_workoutTemplate["progressions"][i]["thumbnail_url"]),
                    ),
                  ),
                )              
              : new Container(),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                    
                    new RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new WorkoutTemplateProgressionBuild(
                              workoutTemplateId:_workoutTemplate["id"],
                              progressionId: _workoutTemplate["progressions"][i]["id"],                   
                            ),
                          ),
                        );                    
                      },
                      child: new Icon(
                        GomotiveIcons.edit,
                        color: Colors.green,
                        size: 24.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.black54,
                      padding: const EdgeInsets.all(15.0),
                    ),                                                  
                  ],
                )
              )
            ],
          )         
        );
        _list.add(container);
      }
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();        
        returnObject["workoutTemplate"] = store.state.workoutState.workoutTemplateObj;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workoutTemplate = stateObject["workoutTemplate"];
        if(_workoutTemplate != null) {
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
                'Workout',             
                style: TextStyle(
                  color: Colors.black87
                )   
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
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                          
                          new Container(
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Center(
                              child: new Text(
                                "List of workout progressions.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                )
                              )
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),    
                            child: new Column(   
                              crossAxisAlignment: CrossAxisAlignment.stretch,                         
                              children: _listProgressions(),
                            )
                          )
                        ]
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
