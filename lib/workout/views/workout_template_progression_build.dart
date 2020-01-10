import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutTemplateProgressionBuild extends StatelessWidget {

  final int workoutTemplateId;
  final int progressionId; // progression id

  WorkoutTemplateProgressionBuild({
    this.workoutTemplateId,
    this.progressionId
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutTemplateProgressionBuild( 
          workoutTemplateId: this.workoutTemplateId,          
          progressionId: this.progressionId        
        ),
      ),
    );
  }
}

class _WorkoutTemplateProgressionBuild extends StatefulWidget {
  final int workoutTemplateId;
  final int progressionId; // progression id

  _WorkoutTemplateProgressionBuild({
    this.workoutTemplateId,
    this.progressionId
  });


  @override
  _WorkoutTemplateProgressionBuildState createState() => new _WorkoutTemplateProgressionBuildState();
}

class _WorkoutTemplateProgressionBuildState extends State<_WorkoutTemplateProgressionBuild> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _getWorkoutProgressionAPI, 
      _clearWorkoutProgressionActionCreator;      

  Map _workoutProgression, _businessPartner;
    
  List<Widget> _listWorkoutProgressionExercises() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_workoutProgression["exercises"].length; i++) {
      Map _exercise = _workoutProgression["exercises"][i];
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu slideMenu = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          title: new Container( 
            height: 80,                                      
            decoration: new BoxDecoration(                          
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ 
                new Row(
                  children: <Widget>[
                    _exercise["exercise_thumbnail_url"] != null 
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        width: MediaQuery.of(context).size.width*0.2,
                        height: 60,
                        child: new Thumbnail(                                    
                          url: _exercise["exercise_thumbnail_url"],
                        )
                      )
                    : new Container(
                      width: MediaQuery.of(context).size.width*0.2,
                      height: 60,
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      width: MediaQuery.of(context).size.width*0.8,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            child: new Text(
                              _exercise["name"],
                              maxLines: 2,
                            ),
                          ),
                          new Container(                            
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Container(
                                  child: new Text(
                                    _exercise["sets"] != null ? "Sets: " + _exercise["sets"].toString() : "Sets: 0",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w100,
                                    )
                                  )
                                ),
                                _exercise["metric"] == 1
                                ? new Container(
                                    child: new Text(
                                      _exercise["reps"] != null ? "Reps: " + _exercise["reps"].toString() : "Reps: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),
                                _exercise["metric"] == 2
                                ? new Container(
                                    child: new Text(
                                      _exercise["distance"] != null ? "Distance: " + _exercise["distance"].toString() + " " + _exercise["__distance_unit"].toString() : "Distance: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),
                                _exercise["metric"] == 3
                                ? new Container(
                                    child: new Text(
                                      _exercise["duration"] != null ? "Duration: " + _exercise["duration"].toString() + " " + _exercise["__duration_unit"].toString() : "Duration: 0",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w100,
                                      )
                                    )
                                  )
                                : new Container(),

                              ],
                            )
                          )
                        ],
                      )                                                
                    ),                                
                  ],
                )                                                                                                                              
              ]                            
            )
          )                        
        ),      
        menuItems: <Widget>[          
        ]
      );
      _list.add(slideMenu);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getWorkoutProgressionAPI = stateObject["getWorkoutProgression"];
        _clearWorkoutProgressionActionCreator = stateObject["clearWorkoutProgression"]; 
        Map params = new Map();
        if(widget.workoutTemplateId != null) {
          params["program_id"] = widget.progressionId;          
        }
        if(widget.progressionId != null) {
          params["id"] = widget.progressionId;          
        }
        _getWorkoutProgressionAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutProgression"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutProgression(context, params));
        returnObject["clearWorkoutProgression"] = () =>
            store.dispatch(WorkoutProgressionClearActionCreator());                            
        returnObject["workoutProgression"] = store.state.workoutState.workoutProgressionObj;    
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) { 
        _workoutProgression = stateObject["workoutProgression"];
        _businessPartner = stateObject["businessPartner"];
        if(_workoutProgression != null && _workoutProgression.keys.length > 0) {
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
                  this._clearWorkoutProgressionActionCreator();
                  Navigator.of(context).pop();
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 48.0),
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
                                "Workout Progression Details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                )
                              )
                            ),
                          ),
                          new Container(                    
                            child: new Form(
                              key: _formKey,
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  new Container(                            
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: new TextFormField(
                                      autofocus: false,
                                      enabled: false,
                                      initialValue: _workoutProgression["name"],
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
                                    ),
                                  ),
                                  new Container(                            
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: new TextFormField(
                                      enabled: false,
                                      initialValue: _workoutProgression["description"],
                                      autofocus: false,
                                      maxLines: 2,
                                      // maxLengthEnforced: true,
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
                                    ),
                                  ),                                  
                                  new Container(                            
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: new TextFormField(   
                                      enabled: false,
                                      initialValue: _workoutProgression["duration"].toString(),                                     
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      style: new TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(                  
                                        labelText: 'Duration in minutes',
                                        labelStyle: new TextStyle(
                                          color: Colors.black87,
                                        ),
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),                                                 
                                    ),
                                  ),    
                                  _businessPartner != null && _businessPartner['show_movement_graph']
                                  ? new Container(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              color: Colors.black12
                                            ),
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                            child: new Text(
                                              "Contribution to Weekly Movement Goals",
                                              textAlign: TextAlign.center,
                                            )
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(    
                                              enabled: false,
                                              initialValue: _workoutProgression["mobility_duration"].toString(),                              
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Mobility in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),                                                                                    
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(  
                                              enabled: false,      
                                              initialValue: _workoutProgression["strength_duration"].toString(),                                
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Strength in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),                                              
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(     
                                              enabled: false,     
                                              initialValue: _workoutProgression["metabolic_duration"].toString(),                              
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Metabolic in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),                                              
                                            ),
                                          ),
                                          new Container(                            
                                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: new TextFormField(    
                                              enabled: false,
                                              initialValue: _workoutProgression["power_duration"].toString(),                                    
                                              keyboardType: TextInputType.number,
                                              autofocus: false,
                                              style: new TextStyle(color: Colors.black87),
                                              decoration: InputDecoration(                  
                                                labelText: 'Power in minutes',
                                                labelStyle: new TextStyle(
                                                  color: Colors.black87,
                                                ),
                                                border: new UnderlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),                                              
                                            ),
                                          ),
                                        ],
                                      )
                                    )
                                  : new Container(),                                                                
                                  new Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey
                                    ),
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: new Column(
                                      children: <Widget>[
                                        new Text(
                                          "Exercises",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0
                                          )
                                        ),                                        
                                      ],
                                    ) 
                                  ),                                  
                                  _workoutProgression["exercises"] != null
                                  ? new Container(
                                      child: new Column(
                                        children: _listWorkoutProgressionExercises()
                                      )
                                    )
                                  : new Container(),                                  
                                ]
                              )
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
