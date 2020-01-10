import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/components/video_app.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/multiselect.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutExerciseMetrics extends StatelessWidget {
  final int exerciseIndex;  
  WorkoutExerciseMetrics({
    this.exerciseIndex
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutExerciseMetrics(
          exerciseIndex: this.exerciseIndex,
        ),
      ),
    );
  }
}

class _WorkoutExerciseMetrics extends StatefulWidget {
  final int exerciseIndex;  
  _WorkoutExerciseMetrics({
    this.exerciseIndex
  });

  @override
  _WorkoutExerciseMetricsState createState() => new _WorkoutExerciseMetricsState();
}

class _WorkoutExerciseMetricsState extends State<_WorkoutExerciseMetrics> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Map _workoutProgression;
  Map _exerciseObj;
  Map _supportingData;
  Map _metricSettings;

  int _exerciseNumber=0, _totalExerciseCount;
  var _setsController = new TextEditingController();  
  var _repsController = new TextEditingController();
  var _distanceController = new TextEditingController();
  var _durationController  = new TextEditingController();
  var _weightController = new TextEditingController();
  var _holdController = new TextEditingController();
  var _pauseController = new TextEditingController();
  var _heartRateController = new TextEditingController();
  var _notesController = new TextEditingController();
  int _distanceUnit, _durationUnit, _holdUnit, _pauseUnit, _weightUnit;
  String _notes;

  List<Map> _distanceUnitList, 
            _durationUnitList, 
            _holdUnitList, 
            _pauseUnitList, 
            _weightUnitList, 
            _cueList,
            _equipmentList;

  List<dynamic> _exerciseCueSelectedList, _exerciseEquipmentSelectedList;

  _onChangeValueSets() {
    _exerciseObj["sets"] = _setsController.text;
  }

  _onChangeValueReps() {
    _exerciseObj["reps"] = _repsController.text;
  }

  _onChangeValueDistance() {
    _exerciseObj["distance"] = _distanceController.text;
  }

  _onChangeValueDuration() {
    _exerciseObj["duration"] = _durationController.text;
  }

  _onChangeValueWeight() {
    _exerciseObj["weight"] = _weightController.text;
  }

  _onChangeValueHold() {
    _exerciseObj["hold"] = _holdController.text;
  }

  _onChangeValuePause() {
    _exerciseObj["pause"] = _pauseController.text;
  }

  _onChangeValueHeartRate() {
    _exerciseObj["heart_rate"] = _heartRateController.text;
  }

  _onChangeNotes() {
    _exerciseObj["notes"] = _notesController.text;
  }

  _applyFromGlobal() {
    setState(() {      
      if(_exerciseObj != null) {
        _exerciseObj["sets"] = _metricSettings["sets"];
        _exerciseObj["reps"] = _metricSettings["reps"];
        _exerciseObj["distance"] = _metricSettings["distance"];
        _exerciseObj["distance_unit"] = _metricSettings["distance_unit"];
        _exerciseObj["duration"] = _metricSettings["duration"];
        _exerciseObj["duration_unit"] = _metricSettings["duration_unit"];
        _exerciseObj["weight"] = _metricSettings["weight"];
        _exerciseObj["weight_unit"] = _metricSettings["weight_unit"];
        _exerciseObj["hold"] = _metricSettings["hold"];
        _exerciseObj["hold_unit"] = _metricSettings["hold_unit"];
        _exerciseObj["pause"] = _metricSettings["pause"];
        _exerciseObj["pause_unit"] = _metricSettings["pause_unit"];
        _exerciseObj["heart_rate"] = _metricSettings["heart_rate"];
      }
    });
  }

  _applyToAllExercises() {
    _formKey.currentState.save();
    for(int i=0; i<_totalExerciseCount; i++) {
      if(i != _exerciseNumber) {
        if(_setsController.text != null) {
          _workoutProgression["exercises"][i]["sets"] = int.parse(_setsController.text);
        }
        if(_repsController.text != null) {
          _workoutProgression["exercises"][i]["reps"] = int.parse(_repsController.text);
        }
        if(_durationController.text != null) {
          _workoutProgression["exercises"][i]["duration"] = int.parse(_durationController.text);
        }
        if(_exerciseObj["duration_unit"] != null) {
          _workoutProgression["exercises"][i]["duration_unit"] = _exerciseObj["duration_unit"];
        }
        if(_distanceController.text != null) {
          _workoutProgression["exercises"][i]["distance"] = int.parse(_distanceController.text);
        }
        if(_exerciseObj["distance_unit"] != null) {
          _workoutProgression["exercises"][i]["distance_unit"] = _exerciseObj["distance_unit"];
        }
        if(_weightController.text != null) {
          _workoutProgression["exercises"][i]["weight"] = int.parse(_weightController.text);
        }
        if(_exerciseObj["weight_unit"] != null) {
          _workoutProgression["exercises"][i]["weight_unit"] = _exerciseObj["weight_unit"];
        }
        if(_holdController.text != null) {
          _workoutProgression["exercises"][i]["hold"] = int.parse(_holdController.text);
        }
        if(_exerciseObj["hold_unit"] != null) {
          _workoutProgression["exercises"][i]["hold_unit"] = _exerciseObj["hold_unit"];
        }
        if(_pauseController.text != null) {
          _workoutProgression["exercises"][i]["pause"] = int.parse(_pauseController.text);
        }
        if(_exerciseObj["pause_unit"] != null) {
          _workoutProgression["exercises"][i]["pause_unit"] = _exerciseObj["pause_unit"];
        }
        if(_heartRateController.text != null) {
          _workoutProgression["exercises"][i]["heart_rate"] = int.parse(_heartRateController.text);
        }          
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setsController.addListener(_onChangeValueSets);
    _repsController.addListener(_onChangeValueReps);
    _distanceController.addListener(_onChangeValueDistance);
    _durationController.addListener(_onChangeValueDuration);
    _weightController.addListener(_onChangeValueWeight);
    _holdController.addListener(_onChangeValueHold);
    _pauseController.addListener(_onChangeValuePause);
    _heartRateController.addListener(_onChangeValueHeartRate);
    _notesController.addListener(_onChangeNotes);
    setState(() {
      _exerciseNumber = widget.exerciseIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();  
        returnObject["workoutProgression"] = store.state.workoutState.workoutProgressionObj; 
        returnObject["supportingData"] = store.state.workoutState.progressionSupportingData;     
        returnObject["metricSettings"] = store.state.practitionerState.metricSettings;

        if(returnObject["supportingData"] != null) {
          _distanceUnitList = Utils.parseList(returnObject["supportingData"], "distance_unit");
          _durationUnitList = Utils.parseList(returnObject["supportingData"], "duration_unit");
          _holdUnitList = Utils.parseList(returnObject["supportingData"], "hold_unit");
          _pauseUnitList = Utils.parseList(returnObject["supportingData"], "pause_unit");
          _weightUnitList = Utils.parseList(returnObject["supportingData"], "weight_unit");
        }        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _metricSettings = stateObject["metricSettings"];
        _workoutProgression = stateObject["workoutProgression"];
        _supportingData = stateObject["supportingData"];
        if(_workoutProgression != null && _exerciseNumber != null) {
          _totalExerciseCount = _workoutProgression["exercises"].length;
          _exerciseObj = _workoutProgression["exercises"].elementAt(_exerciseNumber);
        }
        if(_exerciseObj != null && _supportingData != null) {                    
          if(_exerciseObj["sets"] != null) {
            _setsController.text = _exerciseObj["sets"].toString();
          } else {
            _setsController.text = "0";
          }
          if(_exerciseObj["reps"] != null) {
            _repsController.text = _exerciseObj["reps"].toString();
          } else {
            _repsController.text = "0";
          }
          if(_exerciseObj["distance"] != null) {
            _distanceController.text = _exerciseObj["distance"].toString();
          } else {
            _distanceController.text = "0";
          }
          if(_exerciseObj["duration"] != null) {
            _durationController.text = _exerciseObj["duration"].toString();
          } else {
            _durationController.text = "0";
          }
          if(_exerciseObj["hold"] != null) {
            _holdController.text = _exerciseObj["hold"].toString();
          } else {
            _holdController.text = "0";
          }          
          if(_exerciseObj["weight"] != null) {
            _weightController.text = _exerciseObj["weight"].toString();
          } else {
            _weightController.text = "0";
          }
          if(_exerciseObj["pause"] != null) {
            _pauseController.text = _exerciseObj["pause"].toString();
          } else {
            _pauseController.text = "0";
          }
          if(_exerciseObj["heart_rate"] != null) {
            _heartRateController.text = _exerciseObj["heart_rate"].toString();
          } else {
            _heartRateController.text = "0";
          }          
          _distanceUnit = _exerciseObj["distance_unit"];
          _durationUnit = _exerciseObj["duration_unit"];
          _holdUnit = _exerciseObj["hold_unit"];
          _weightUnit = _exerciseObj["weight_unit"];
          _pauseUnit = _exerciseObj["pause_unit"];
          if(_exerciseObj["notes"] != null) {
            _notesController.text = _exerciseObj["notes"];
          } else {
            _notesController.text = "";
          }
          _cueList = Utils.parseList(_supportingData, "cues");
          _equipmentList = Utils.parseList(_supportingData, "equipments");
          if(_exerciseObj.containsKey("cues")) {
            List<int> _selectedList = new List<int>();
            for(int i=0; i<_exerciseObj["cues"].length; i++) {
              if(_exerciseObj["cues"][i] is Map) {
                _selectedList.add(_exerciseObj["cues"][i]["id"]);
              } else {
                _selectedList.add(_exerciseObj["cues"][i]);
              }
            }
            _exerciseCueSelectedList = _selectedList;
          } else {
            _exerciseCueSelectedList = new List<int>();
          }
          if(_exerciseObj.containsKey("equipments")) {
            List<int> _selectedList = new List<int>();
            for(int i=0; i<_exerciseObj["equipments"].length; i++) {
              if(_exerciseObj["equipments"][i] is Map) {
                _selectedList.add(_exerciseObj["equipments"][i]["id"]);
              } else {
                _selectedList.add(_exerciseObj["equipments"][i]);
              }
            }
            _exerciseEquipmentSelectedList = _selectedList;
          } else {
            _exerciseEquipmentSelectedList = new List<int>();
          }
          List<String> _videoList = new List<String>();
          _videoList.add(_exerciseObj["video_url"]);
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
                _exerciseObj["name"],             
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[                                
                                  new IconButton(
                                    icon: Icon(GomotiveIcons.back),
                                    color: (_exerciseNumber > 0) ? Colors.green : Colors.grey,
                                    onPressed: () {
                                      if(_exerciseNumber > 0) {
                                        setState(() {
                                          _exerciseNumber = _exerciseNumber - 1;
                                        });
                                      }                                    
                                    },
                                  ),
                                  new FlatButton(
                                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                    color: primaryColor,                                
                                    child: new Text(
                                      'APPLY FROM GLOBAL',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 10.0,
                                      )
                                    ),
                                    onPressed: () {
                                      _applyFromGlobal();                                      
                                    },
                                  ),
                                  new FlatButton(
                                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                    color: primaryColor,                                
                                    child: new Text(
                                      'APPLY TO ALL',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 10.0,
                                      )
                                    ),
                                    onPressed: () {
                                      _applyToAllExercises();                                      
                                    },
                                  ),
                                  new IconButton(
                                    icon: Icon(GomotiveIcons.next),
                                    color: ((_exerciseNumber+1) < _totalExerciseCount) ? Colors.green : Colors.grey,
                                    onPressed: () {
                                      if((_exerciseNumber+1) < _totalExerciseCount) {
                                        setState(() {
                                          _exerciseNumber = _exerciseNumber + 1;
                                        });
                                      }                                    
                                    },
                                  ),
                                ],
                              ),
                            ),
                            _exerciseObj["video_url"] != null
                            ? new Container(                          
                                child: new VideoApp(
                                  videoUrl: _exerciseObj["video_url"],
                                  autoPlay: false,
                                ),
                              )
                            : new Container(
                                height: MediaQuery.of(context).size.height/3,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(_exerciseObj["exercise_thumbnail_url"]),
                                  ),
                                ),
                              ),                            
                            new Container(
                              decoration: new BoxDecoration(
                                border: new Border(
                                  bottom: new BorderSide(
                                    color: Colors.black12
                                  ),
                                ),                              
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: new Text(
                                _exerciseObj["name"],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              )
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: _setsController,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Sets',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),                                
                                validator: (value) {
                                  if(value == "" || value == null) {
                                    return 'Please enter value for sets';
                                  }
                                },
                                onSaved: (value) {
                                },
                              ),
                            ),
                            _exerciseObj["metric"] == 1
                            ? new Container(                            
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: new TextFormField(
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  controller: _repsController,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(                  
                                    labelText: 'Reps',
                                    labelStyle: new TextStyle(
                                      color: Colors.black87,
                                    ),
                                    border: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if(_exerciseObj["metric"] == 1) {
                                      if(value == "" || value == null) {
                                        return 'Please enter value for reps';
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                  },
                                ),
                              )
                            : new Container(),
                            _exerciseObj["metric"] == 2
                            ? new Column(
                              children: <Widget>[                              
                                new Container(                            
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: new TextFormField(
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    controller: _distanceController,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                  
                                      labelText: 'Distance',
                                      labelStyle: new TextStyle(
                                        color: Colors.black87,
                                      ),
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if(_exerciseObj["metric"] == 2) {
                                        if(value == "" || value == null) {
                                          return 'Please enter value for distance';
                                        }
                                      }
                                    },
                                    onSaved: (value) {
                                    },
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
                                      labelText: 'Distance Unit',
                                      labelStyle: new TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),    
                                    initialValue: _distanceUnit != null ? _distanceUnit.toString() : null,        
                                    options: _distanceUnitList,
                                    autovalidate: true,  
                                    validator: (value) {
                                      if(_exerciseObj["metric"] == 2) {                                       
                                        if(value == "" || value == null) {
                                          return 'Please select distance unit';
                                        } else {
                                          _distanceUnit = int.parse(value);
                                          _exerciseObj["distance_unit"] = int.parse(value);
                                        }
                                      }                                    
                                    },
                                    onSaved: (value) {                                                                            
                                    }                              
                                  ),
                                ),
                              ]
                            )
                            : new Container(),
                            _exerciseObj["metric"] == 3
                            ? new Column(
                              children: <Widget>[                              
                                new Container(                            
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: new TextFormField(
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    controller: _durationController,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                  
                                      labelText: 'Duration',
                                      labelStyle: new TextStyle(
                                        color: Colors.black87,
                                      ),
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if(_exerciseObj["metric"] == 3) {
                                        if(value == "" || value == null) {
                                          return 'Please enter value for duration';
                                        }
                                      }
                                    },
                                    onSaved: (value) {
                                    },
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
                                      labelText: 'Duration Unit',
                                      labelStyle: new TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),    
                                    initialValue: _durationUnit != null ? _durationUnit.toString() : null,
                                    options: _durationUnitList,
                                    autovalidate: true,  
                                    validator: (value) {
                                      if(_exerciseObj["metric"] == 3) {                                       
                                        if(value == "" || value == null) {
                                          return 'Please select duration unit';
                                        } else {
                                          _durationUnit = int.parse(value);
                                          _exerciseObj["duration_unit"] = int.parse(value);
                                        }
                                      }                            
                                    },
                                    onSaved: (value) {                                                                            
                                    },                                                                  
                                  ),
                                ),
                              ]
                            )
                            : new Container(), 
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: _holdController,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Hold',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {                                    
                                },
                                onSaved: (value) {
                                },
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
                                  labelText: 'Hold Unit',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),      
                                initialValue: _holdUnit != null ? _holdUnit.toString() : null,        
                                options: _holdUnitList,
                                autovalidate: true,                                
                                validator: (value) {
                                  if(value != null) {                                    
                                    _holdUnit = int.parse(value);
                                    _exerciseObj["hold_unit"] = _holdUnit;
                                  }
                                },
                                onSaved: (value) {                                  
                                }                                
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: _pauseController,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Pause',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {                                    
                                },
                                onSaved: (value) {
                                },
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
                                  labelText: 'Pause Unit',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),                
                                initialValue: _pauseUnit != null ? _pauseUnit.toString() : null,
                                options: _pauseUnitList,
                                autovalidate: true,
                                validator: (value) {
                                  if(value != null) {
                                    _pauseUnit = int.parse(value);                                  
                                    _exerciseObj["pause_unit"] = int.parse(value); 
                                  }
                                },
                                onSaved: (value) {                                  
                                }                                
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: _weightController,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Weight',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {                                    
                                },
                                onSaved: (value) {
                                },
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
                                  labelText: 'Weight Unit',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),                
                                initialValue: _weightUnit != null ? _weightUnit.toString() : null,
                                options: _weightUnitList,
                                autovalidate: true, 
                                validator: (value) {
                                  if(value != null) {
                                    _weightUnit = int.parse(value);                                  
                                    _exerciseObj["weight_unit"] = int.parse(value);
                                  }
                                },
                                onSaved: (value) {                                  
                                }                               
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                controller: _heartRateController,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Target Heart Rate',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {                                    
                                },
                                onSaved: (value) {
                                },
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: new MultiSelect(
                                context: context, 
                                labelKey: "name",
                                valueKey: "id",                             
                                decoration: InputDecoration(
                                  labelText: "Cues",
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                autovalidate: true,
                                enabled: true,
                                optionList: _cueList,
                                initialValue:_exerciseCueSelectedList,
                                validator: (value) {
                                  if(value != null) {
                                    _exerciseObj["cues"] = value;
                                  }                                 
                                },        
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: new MultiSelect(
                                context: context,    
                                labelKey: "name",
                                valueKey: "id",                             
                                decoration: InputDecoration(
                                  labelText: "Equipment",
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                autovalidate: true,
                                enabled: true,
                                optionList: _equipmentList,
                                initialValue: _exerciseEquipmentSelectedList,
                                validator: (value) {  
                                  if(value != null) {
                                    _exerciseObj["equipments"] = value;
                                  }                               
                                },        
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: new TextFormField(
                                controller: _notesController,
                                initialValue: _notes,
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,                                
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                  
                                  labelText: 'Notes',
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
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 32),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[                                
                                  new IconButton(
                                    icon: Icon(GomotiveIcons.back),
                                    color: (_exerciseNumber > 0) ? Colors.green : Colors.grey,
                                    onPressed: () {
                                      if(_exerciseNumber > 0) {
                                        setState(() {
                                          _exerciseNumber = _exerciseNumber - 1;
                                        });
                                      }                                    
                                    },
                                  ),
                                  new FlatButton(
                                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                    color: primaryColor,                                
                                    child: new Text(
                                      'APPLY FROM GLOBAL',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 10.0,
                                      )
                                    ),
                                    onPressed: () {
                                      _applyFromGlobal();
                                    },
                                  ),
                                  new FlatButton(
                                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                    color: primaryColor,                                
                                    child: new Text(
                                      'APPLY TO ALL',
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 10.0,
                                      )
                                    ),
                                    onPressed: () {
                                      _applyToAllExercises();                                                                            
                                    },
                                  ),
                                  new IconButton(
                                    icon: Icon(GomotiveIcons.next),
                                    color: ((_exerciseNumber+1) < _totalExerciseCount) ? Colors.green : Colors.grey,
                                    onPressed: () {
                                      if((_exerciseNumber+1) < _totalExerciseCount) {
                                        setState(() {
                                          _exerciseNumber = _exerciseNumber + 1;
                                        });
                                      }                                    
                                    },
                                  ),
                                ],
                              ),
                            ),                 
                          ]
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
