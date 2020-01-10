import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/core/app_config.dart';

class ExerciseInfo extends StatelessWidget {
  final Map exercise;
  ExerciseInfo({
    this.exercise
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ExerciseInfo(
          exercise: this.exercise
        ),
      ),
    );
  }
}

class _ExerciseInfo extends StatefulWidget {
  final Map exercise;
  _ExerciseInfo({
    this.exercise
  });
  
  @override
  _ExerciseInfoState createState() => new _ExerciseInfoState();
}

class _ExerciseInfoState extends State<_ExerciseInfo>  with SingleTickerProviderStateMixin {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String displayTab = "metrics";
  
  @override
  void initState() {
    super.initState();  
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(                  
              icon: Icon(
                GomotiveIcons.back,
                size: 40.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              widget.exercise["name"],             
              style: TextStyle(
                color: Colors.black87
              )   
            ),            
            actions: <Widget>[ ],
          ),
          body: new LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              String setsText, repsText, distanceText, durationText, weightText, pauseText, holdText, heartRateText;
              List<Map> cueList, equipmentList;
              if(widget.exercise["sets"] != null) {
                setsText = "Sets: " + widget.exercise["sets"].toString();
              } else {
                setsText = "Sets: 0";
              }
              if(widget.exercise["reps"] != null) {
                repsText = "Reps: " + widget.exercise["reps"].toString();
              } else {
                repsText = "Reps: 0";
              }
              if(widget.exercise["distance"] != null) {
                distanceText = "Distance: " + widget.exercise["distance"].toString() + " " + widget.exercise["distance_unit"].toString();
              } else {
                distanceText = "Distance: 0";
              }
              if(widget.exercise["duration"] != null) {
                durationText = "Duration: " + widget.exercise["duration"].toString() + " " + widget.exercise["__duration_unit"].toString();
              } else {
                durationText = "Duration: 0";
              }
              if(widget.exercise["weight"] != null) {
                weightText = "Weight: " + widget.exercise["weight"].toString() + " " + widget.exercise["__weight_unit"].toString();
              } else {
                weightText = "Weight: 0";
              }
              if(widget.exercise["hold"] != null) {
                holdText = "Hold: " + widget.exercise["hold"].toString() + " " + widget.exercise["__hold_unit"].toString();
              } else {
                holdText = "Hold: 0";
              }
              if(widget.exercise["pause"] != null) {
                pauseText = "Rest betw. Sets: " + widget.exercise["pause"].toString() + " " + widget.exercise["__pause_unit"].toString();
              } else {
                pauseText = "Rest betw. Sets: 0";
              }
              if(widget.exercise["heart_rate"] != null) {
                heartRateText = "Heart rate: " + widget.exercise["heart_rate"].toString() ;
              } else {
                heartRateText = "Heart rate: 0";
              }
              cueList = Utils.parseList(widget.exercise, "cues");
              equipmentList = Utils.parseList(widget.exercise, "equipments");
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(
                    child: new Column(                      
                      children: <Widget>[                          
                        widget.exercise["video_url"] != null
                        ? new Container(                          
                            child: new VideoApp(
                              videoUrl: widget.exercise["video_url"],
                              autoPlay: false,
                            ),
                          )
                        : new Container(
                            height: MediaQuery.of(context).size.height/3,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(widget.exercise["exercise_thumbnail_url"]),
                              ),
                            ),
                          ),
                        new Container(      
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                                color: Colors.black12,            
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    new GestureDetector(
                                      onTap:() {
                                        setState(() {
                                          displayTab = "metrics";  
                                        });
                                      },
                                      child: new Container(
                                        child: new Text(
                                          'Metrics',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: displayTab == "metrics" ? Colors.black : Colors.blueGrey,
                                          )
                                        ),
                                      )
                                    ),
                                    new GestureDetector(
                                      onTap:() {
                                        setState(() {
                                          displayTab = "info";  
                                        });
                                      },
                                      child: new Container(
                                        child: new Text(
                                          'Info',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: displayTab == "info" ? Colors.black : Colors.blueGrey,
                                          )
                                        ),
                                      )
                                    ),
                                    new GestureDetector(
                                      onTap:() {
                                        setState(() {
                                          displayTab = "cues";  
                                        });
                                      },
                                      child: new Container(
                                        child: new Text(
                                          'Cues',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: displayTab == "cues" ? Colors.black : Colors.blueGrey,
                                          )
                                        ),
                                      )
                                    ),
                                    new GestureDetector(
                                      onTap:() {
                                        setState(() {
                                          displayTab = "equipment";  
                                        });
                                      },
                                      child: new Container(
                                        child: new Text(
                                          'Equipment',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: displayTab == "equipment" ? Colors.black : Colors.blueGrey,
                                          )
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                              displayTab == "metrics"
                              ? new Container(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  height: 200,
                                  child: new Column(
                                    children: <Widget>[
                                      new Container(
                                        child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: new Chip( 
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                label: new Text(
                                                  setsText,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ),
                                              ),
                                            ),
                                            widget.exercise['metric'] == 1
                                            ? new Container(
                                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                                child: new Chip( 
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                  label: new Text(
                                                    repsText,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                    )
                                                  ),
                                                ),                                            
                                              )
                                            : new Container(),
                                            widget.exercise['metric'] == 2
                                            ? new Container(
                                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                                child: new Chip( 
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                  label: new Text(
                                                    distanceText,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                    )
                                                  ),
                                                ),                                            
                                              )
                                            : new Container(),
                                            widget.exercise['metric'] == 3
                                            ? new Container(
                                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                                child: new Chip( 
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                  label: new Text(
                                                    durationText,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                    )
                                                  ),
                                                ),                                            
                                              )
                                            : new Container(),                                            
                                          ],
                                        )
                                      ),
                                      new Container(
                                        child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: new Chip( 
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                label: new Text(
                                                  holdText,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ),
                                              ),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                              child: new Chip( 
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                label: new Text(
                                                  pauseText,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ),
                                              ),                                            
                                            ),                                            
                                          ],
                                        )
                                      ),
                                      new Container(
                                        child: new Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                              child: new Chip( 
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                label: new Text(
                                                  weightText,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ),
                                              ),
                                            ),                                         
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                              child: new Chip( 
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                                                                 
                                                label: new Text(
                                                  heartRateText,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ),
                                              ),                                            
                                            )
                                          ],
                                        )
                                      ),
                                    ],
                                  )                                  
                                )
                              : new Container(),
                              displayTab == "info"
                              ? new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  height: 200,
                                  child: new Text(
                                    widget.exercise["description"] != null ? widget.exercise["description"] : ""
                                  )
                                )
                              : new Container(),
                              displayTab == "cues"
                              ? new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  height: 200,
                                  child: cueList.length > 0
                                  ? new ListView.builder(                                    
                                      shrinkWrap: true,
                                      itemCount: cueList.length,
                                      itemBuilder: (context, i) {
                                        return new Container(
                                          child: new Center(
                                            child: new Text(
                                              cueList[i]["name"].toString()
                                            )
                                          )
                                        );
                                      }
                                    )
                                  : new Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                      child: new Text(
                                        "No cues have been assigned for this exercise.",
                                        textAlign: TextAlign.center,
                                      )
                                    ),
                                )
                              : new Container(),
                              displayTab == "equipment"
                              ? new Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                  height: 200,
                                  child: equipmentList.length > 0
                                  ? new ListView.builder(                                    
                                      shrinkWrap: true,
                                      itemCount: equipmentList.length,
                                      itemBuilder: (context, i) {
                                        return new Container(
                                          child: new Center(
                                            child: new Text(
                                              equipmentList[i]["name"].toString()
                                            )
                                          ),
                                        );
                                      }
                                    )
                                  : new Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                      child: new Text(
                                        "No equipment have been assigned for this exercise.",
                                        textAlign: TextAlign.center
                                      )
                                    ),
                                )
                              : new Container(),
                            ],
                          )
                        )
                      ],                      
                    ),
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
