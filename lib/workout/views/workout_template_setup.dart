import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/components/multiselect.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutTemplateSetup extends StatelessWidget {
  final int workoutTemplateId;

  WorkoutTemplateSetup({
    this.workoutTemplateId,    
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutTemplateSetup(
          workoutTemplateId: this.workoutTemplateId
        ),
      ),
    );
  }
}

class _WorkoutTemplateSetup extends StatefulWidget {
  final int workoutTemplateId;

  _WorkoutTemplateSetup({
    this.workoutTemplateId,    
  });


  @override
  _WorkoutTemplateSetupState createState() => new _WorkoutTemplateSetupState();
}

class _WorkoutTemplateSetupState extends State<_WorkoutTemplateSetup> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    
  
  Map _workoutTemplate;
  List<Map> _workoutTemplateCategory, _workoutTemplateSports, _workoutTemplateSportsExerciseType, _workoutTemplateSchedules;
  List<dynamic> _workoutTemplateSportsSelected;

  var _getWorkoutTemplateAPI, _clearWorkout;

  String _workoutTemplateScheduleTypeId, _workoutTemplateCategoryId, _workoutTemplateSportsExerciseTypeId;

  @override
  void initState() {
    super.initState();    
  }
 
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getWorkoutTemplateAPI = stateObject["getWorkoutTemplate"];
        _clearWorkout = stateObject["clearWorkout"];
        Map params = new Map();
        params["id"] = widget.workoutTemplateId;
        params["program_type"] = 0;
        _getWorkoutTemplateAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutTemplate(context, params));        
        returnObject["clearWorkout"] = () => 
          store.dispatch(WorkoutTemplateClearActionCreator());
        returnObject["workoutTemplate"] = store.state.workoutState.workoutTemplateObj;
        Map _supportingData = store.state.workoutState.workoutTemplateObjSupportingData;
        if(_supportingData != null) {          
          if(_supportingData.containsKey("category")) {
            returnObject["workoutTemplateCategory"] = Utils.parseList(_supportingData, "category");
          }
          if(_supportingData.containsKey("sports")) {
            returnObject["workoutTemplateSports"] = Utils.parseList(_supportingData, "sports");
          }
          if(_supportingData.containsKey("sports_exercise_type")) {
            returnObject["workoutTemplateSportsExerciseType"] = Utils.parseList(_supportingData, "sports_exercise_type");
          }          
          if(_supportingData.containsKey("schedule_type")) {
            returnObject["workoutTemplateSchedules"] = Utils.parseList(_supportingData, "schedule_type");
          }
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workoutTemplateSportsSelected = new List<int>();
        _workoutTemplate = stateObject["workoutTemplate"];
        _workoutTemplateCategory = stateObject["workoutTemplateCategory"];
        _workoutTemplateSports = stateObject["workoutTemplateSports"];
        _workoutTemplateSportsExerciseType = stateObject["workoutTemplateSportsExerciseType"];
        _workoutTemplateSchedules = stateObject["workoutTemplateSchedules"];
        if(_workoutTemplate != null && _workoutTemplate.keys.length > 0) {
          if(_workoutTemplate["schedule_type"] != null) {
            _workoutTemplateScheduleTypeId = _workoutTemplate["schedule_type"].toString();
          }
          if(_workoutTemplate["category"] != null) {
            _workoutTemplateCategoryId = _workoutTemplate["category"]["id"].toString();
          }
          if(_workoutTemplate["sports"] != null) {            
            for(int i=0; i<_workoutTemplate["sports"].length; i++) {
              _workoutTemplateSportsSelected.add(_workoutTemplate["sports"][i]['id']);
            }
          }
          if(_workoutTemplate["sports_exercise_type"] != null) {
            _workoutTemplateSportsExerciseTypeId = _workoutTemplate["sports_exercise_type"]["id"].toString();
          }
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(  
              backgroundColor: Colors.white,
              title: new Text(
                'Workout Template',             
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
                  this._clearWorkout();
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[                
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: IconButton(
                    icon: Icon(
                      GomotiveIcons.next,
                      color: primaryColor,
                    ),
                    onPressed: () { 
                      Navigator.of(context).pushNamed("/workout_template/progressions");                     
                    },
                  ),                
                )
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
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          children: <Widget>[                            
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                enabled: false,
                                initialValue: _workoutTemplate["name"],
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
                                initialValue: _workoutTemplate["description"],
                                autofocus: false,
                                maxLines: 4,
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
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                              child: new DropdownFormField(
                                decoration: InputDecoration(                                    
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  labelText: 'Schedule Type',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                initialValue: _workoutTemplateScheduleTypeId,                
                                options: _workoutTemplateSchedules,                                
                              ),
                            ),
                            _workoutTemplateScheduleTypeId == "1" 
                            ? new Container(                            
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: new TextFormField(
                                  initialValue: _workoutTemplate["total_days"].toString(),
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(                  
                                    labelText: 'Length in days',
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
                              )
                            : new Container(),
                            _workoutTemplateScheduleTypeId == "2" 
                            ? new Container(
                                child: new Column(
                                  children: <Widget>[
                                    new Container(                            
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: new TextFormField(
                                        enabled: false,
                                        initialValue: _workoutTemplate["per_day"].toString(),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        style: new TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(                  
                                          labelText: 'Per Day',
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
                                        initialValue: _workoutTemplate["per_week"].toString(),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        style: new TextStyle(color: Colors.black87),
                                        decoration: InputDecoration(                  
                                          labelText: 'Per Week',
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
                                    )
                                  ],
                                )  
                              )
                            : new Container(), 
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                              child: new DropdownFormField(
                                labelKey: "name",
                                valueKey: "id",
                                decoration: InputDecoration(                                    
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  labelText: 'Category',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                options: _workoutTemplateCategory,
                                initialValue: _workoutTemplateCategoryId,                                                
                              ),
                            ),
                            _workoutTemplateCategoryId == "5"
                            ? new Container(
                                child: new Column(
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                      child: new MultiSelect(
                                        context: context,
                                        labelKey: "name",
                                        valueKey: "id",
                                        decoration: InputDecoration(                                    
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          labelText: 'Sports',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        optionList: _workoutTemplateSports,  
                                        initialValue: _workoutTemplateSportsSelected,  
                                        validator: (val) {
                                        },                                    
                                      ),
                                    ),
                                    new Container(
                                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                                      child: new DropdownFormField(
                                        labelKey: "name",
                                        valueKey: "id",
                                        decoration: InputDecoration(                                    
                                          border: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          labelText: 'Sports Exercise Type',
                                          labelStyle: new TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        options: _workoutTemplateSportsExerciseType,
                                        initialValue: _workoutTemplateSportsExerciseTypeId,                                                
                                      ),
                                    ),
                                  ],
                                )
                              )
                            : new Container(),                          
                          ],
                        )
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
