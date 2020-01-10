import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/exercise/views/exercise_list.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/workout/views/workout_template_list.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/gameplan/views/gameplan_template_list.dart';

class DHFMovementMeter extends StatelessWidget {

  final String movementMeterType;
  DHFMovementMeter({
    this.movementMeterType
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _DHFMovementMeter(
          movementMeterType: this.movementMeterType,
        ),
      ),
    );
  }
}

class _DHFMovementMeter extends StatefulWidget {
  final String movementMeterType;
  _DHFMovementMeter({
    this.movementMeterType
  });
  
  @override
  _DHFMovementMeterState createState() => new _DHFMovementMeterState();
}

class _DHFMovementMeterState extends State<_DHFMovementMeter> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
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
                size: 30.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/practitioner/home');
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              widget.movementMeterType,             
              style: TextStyle(
                color: Colors.black87
              )   
            ),          
            actions: <Widget>[ ],
          ),
          body: new LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              Color _backgroundColor = Colors.blueGrey;
              int categoryId, treatmentTemplateCategory;
              if(widget.movementMeterType == "Mobility") {
                _backgroundColor = Colors.lightBlue;
                categoryId = 6;
                treatmentTemplateCategory = 1;
              } else if(widget.movementMeterType == "Strength") {
                _backgroundColor = Colors.lightGreen;
                categoryId = 7;
                treatmentTemplateCategory = 2;
              } if(widget.movementMeterType == "Metabolic") {
                _backgroundColor = Colors.yellow;
                categoryId = 8;
                treatmentTemplateCategory = 3;
              } if(widget.movementMeterType == "Power") {
                _backgroundColor = Colors.red;
                categoryId = 9;
                treatmentTemplateCategory = 4;
              }
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(
                    child: new Center(
                      child: new Column(                      
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                            child: new GestureDetector(
                              onTap:() {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new PractitionerClients(
                                      flowType: "dhf_assessment",
                                      dhfMovementMeterType: widget.movementMeterType
                                    ),
                                  ),
                                );                                
                              },
                              child: new PhysicalModel(
                                borderRadius: new BorderRadius.circular(125.0),
                                color: _backgroundColor,
                                child: new Container(
                                  width: 250.0,
                                  height: 250.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(125.0),                                  
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      'ASSESS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      )
                                    )
                                  ),
                                ),
                              ),                            
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                            child: new GestureDetector(
                              onTap:() {
                                CustomDialog.dhfLibraryOptions(context).then((int response) {
                                  if(response == 2) {                                    
                                    Map params = new Map();
                                    if(selectedRoleId != "276") {
                                      params['partners'] = [10];                                      
                                      params['my_practice_exercise'] = false;
                                    } else {  
                                      params['my_practice_exercise'] = true;
                                    }                                                                        
                                    params["category"] = categoryId;
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new PractitionerClients(
                                          searchParams: params,
                                          flowType: "dhf_exercise_list",
                                          dhfMovementMeterType: widget.movementMeterType
                                        ),
                                      ),
                                    );
                                  } else if(response == 1) {
                                    Map params = new Map();
                                    params["program_type"] = 0;
                                    if(selectedRoleId != "276") {
                                      params['partners'] = [10];                                      
                                      params['my_practice_programs'] = false;
                                    } else {  
                                      params['my_practice_programs'] = true;
                                    }                                                                        
                                    params["category"] = categoryId;
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new PractitionerClients(
                                          searchParams: params,
                                          flowType: "dhf_workout_template_list",
                                          dhfMovementMeterType: widget.movementMeterType
                                        ),
                                      ),
                                    );
                                  } else if(response == 3) {
                                    Map params = new Map();    
                                    params["treatment_category"] = treatmentTemplateCategory;                                
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new PractitionerClients(
                                          searchParams: params,
                                          flowType: "dhf_gameplan_template_list",
                                          dhfMovementMeterType: widget.movementMeterType
                                        ),
                                      ),
                                    );
                                  }
                                });                               
                              },
                              child: new PhysicalModel(
                                borderRadius: new BorderRadius.circular(125.0),
                                color: _backgroundColor,
                                child: new Container(
                                  width: 250.0,
                                  height: 250.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(125.0),                                  
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      'ASSIGN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      )
                                    )
                                  ),
                                ),
                              ),                            
                            ),
                          ),                          
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                            child: new GestureDetector(
                              onTap:() { 
                                CustomDialog.dhfLibraryOptions(context).then((int response) {
                                  if(response == 2) {
                                    Map params = new Map();
                                    if(selectedRoleId != "276") {
                                      params['partners'] = [10];                                      
                                      params['my_practice_exercise'] = false;
                                    } else {  
                                      params['my_practice_exercise'] = true;
                                    }                                                                        
                                    params["category"] = categoryId;                                   
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new ExerciseList(
                                          exerciseSearchParams: params,
                                          usageType: "dhf_exercise_library",
                                          dhfMovementMeterType: widget.movementMeterType
                                        ),
                                      ),
                                    );
                                  } else if(response == 1) {
                                    Map params = new Map();
                                    params["program_type"] = 0;
                                    if(selectedRoleId != "276") {
                                      params['partners'] = [10];                                      
                                      params['my_practice_programs'] = false;
                                    } else {  
                                      params['my_practice_programs'] = true;
                                    }                                                                        
                                    params["category"] = categoryId;
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new WorkoutTemplateList(
                                          searchParams: params,
                                          usageType: "dhf_workout_template_list_browse",
                                          dhfMovementMeterType: widget.movementMeterType,
                                        ),
                                      ),
                                    );
                                  } else if(response == 3) {  
                                    Map params = new Map();    
                                    params["treatment_category"] = treatmentTemplateCategory;                                  
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new GameplanTemplateList(
                                          searchParams: params,
                                          usageType: "dhf_gameplan_template_list_browse",
                                          dhfMovementMeterType: widget.movementMeterType,
                                        ),
                                      ),
                                    );
                                  }

                                });                               
                              },
                              child: new PhysicalModel(
                                borderRadius: new BorderRadius.circular(125.0),
                                color: _backgroundColor,
                                child: new Container(
                                  width: 250.0,
                                  height: 250.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(125.0),                                  
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      'BROWSE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24.0,
                                      )
                                    )
                                  ),
                                ),
                              ),                            
                            ),
                          ),                          
                        ],
                      )                    
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
