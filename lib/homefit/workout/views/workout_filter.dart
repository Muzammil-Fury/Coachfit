import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/workout/workout_actions.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/components/dropdown_form_field.dart';
import 'package:gomotive/homefit/components/multiselect.dart';

class WorkoutFilter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _WorkoutFilter(),
        )        
      ),
    );
  }
}

class _WorkoutFilter extends StatefulWidget {
  @override
  _WorkoutFilterState createState() => new _WorkoutFilterState();
}

class _WorkoutFilterState extends State<_WorkoutFilter> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _availableSports;
  int filterNumber = 1;
  var _filterMovementMeterActionCreator,
      _filterEquipmentActionCreator, 
      _filterWorkoutTypeActionCreator, 
      _filterWorkoutDurationActionCreator, 
      _filterWorkoutFitnessLevelActionCreator,
      _filterWorkoutSportsActionCreator,
      _filterFavoriteActionCreator;

  var _movementMeterFilter, 
      _equipmentBodyweight, 
      _equipmentDumbbell, 
      _equipmentKettlebell, 
      _equipmentPowerplate, 
      _equipmentFoamroller, 
      _equipmentBand, 
      _equipmentBosu,
      _equipmentRockblade,
      _workoutType, 
      _workoutDuration, 
      _workoutFitnessLevel,
      _workoutSports;
  bool _favoriteEnabled;
  
  void _setFilterMovementMeter(String _movementMeter) {
    _filterMovementMeterActionCreator(_movementMeter);
  }

  void _setFilterEquipment(String _toggleEquipment) {
    _filterEquipmentActionCreator(_toggleEquipment);
  }

  void _setWorkoutType(String workoutType) {
    _filterWorkoutTypeActionCreator(workoutType);
  }

  void _setWorkoutDuration(int workoutDuration) {
    _filterWorkoutDurationActionCreator(workoutDuration);
  }

  void _setWorkoutFitnessLevel(String workoutFitnessLevel) {
    _filterWorkoutFitnessLevelActionCreator(workoutFitnessLevel);
  }

  void _setWorkoutSports(int sports) {
    _filterWorkoutSportsActionCreator(sports);
  }

  List<Widget> _listAvailableSports() {
    List<Widget> _list = new List<Widget>();
    if(_availableSports != null) {
      for(int i=0; i<_availableSports.length; i++) {
        if(_availableSports[i]["id"] != "0") {
          Container _sportsContainer = new Container(
            child: new RawMaterialButton(
              onPressed: () {
                if(_workoutSports != _availableSports[i]["id"]) {
                  _setWorkoutSports(_availableSports[i]["id"]);
                } else {
                  _setWorkoutSports(0);
                }                                        
              },
              child: new Text(
                _availableSports[i]["name"],
                style: TextStyle(
                  fontSize: 24.0
                )
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: _workoutSports == _availableSports[i]["id"] ? Colors.green : dhfYellow,
              padding: const EdgeInsets.all(64.0),
            ),
          );
          _list.add(_sportsContainer);
        }
      }
    }
    return _list;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return new Scaffold(
      key: _scaffoldKey,
      body: new LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: new Container(
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover
                  ),
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: new BoxDecoration(
                        color: Colors.black26
                      ),
                      child: Utils.drawMenu(context, "workouts")
                    ),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            height: 90,
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[   
                                new GestureDetector(
                                  onTap: () {  
                                    if(filterNumber != 1) {
                                      setState(() {
                                        filterNumber = 1;
                                      });
                                    }                                           
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      'assets/images/filter_movement_meter.png', 
                                      color: filterNumber == 1 ? dhfYellow : Colors.black87,                                 
                                    ),
                                  ),
                                ),                             
                                // new GestureDetector(
                                //   onTap: () {  
                                //     if(filterNumber != 2) {
                                //       setState(() {
                                //         filterNumber = 2;
                                //       });
                                //     }                                           
                                //   },
                                //   child: new Container(
                                //     child: new Image.asset(
                                //       'assets/images/filter_sports.png', 
                                //       color: filterNumber == 2 ? dhfYellow : Colors.black87,                                 
                                //     ),
                                //   ),
                                // ),
                                new GestureDetector(
                                  onTap: () {
                                    if(filterNumber != 3) {
                                      setState(() {
                                        filterNumber = 3;
                                      });                                             
                                    }
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      'assets/images/filter_equipment.png', 
                                      color: filterNumber == 3 ? dhfYellow : Colors.black87,
                                    ),
                                  ),
                                ),
                                // new GestureDetector(
                                //   onTap: () { 
                                //     if(filterNumber != 4) {
                                //       setState(() {
                                //         filterNumber = 4;
                                //       });                                            
                                //     }
                                //   },
                                //   child: new Container(
                                //     child: new Image.asset(
                                //       'assets/images/filter_type.png', 
                                //       color: filterNumber == 4 ? dhfYellow : Colors.black87,
                                //     ),
                                //   ),
                                // ),
                                new GestureDetector(
                                  onTap: () { 
                                    if(filterNumber != 5) {
                                      setState(() {
                                        filterNumber = 5;
                                      });                                            
                                    }
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      'assets/images/filter_duration.png', 
                                      color: filterNumber == 5 ? dhfYellow : Colors.black87,
                                    ),
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {  
                                    if(filterNumber != 6) {
                                      setState(() {
                                        filterNumber = 6;
                                      });                                           
                                    }
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      'assets/images/filter_level.png', 
                                      color: filterNumber == 6 ? dhfYellow : Colors.black87,
                                    ),
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {  
                                    if(_movementMeterFilter == "Mobility") {
                                      Navigator.of(context).pushReplacementNamed("/workouts/mobility");  
                                    } else if(_movementMeterFilter == "Strength") {
                                      Navigator.of(context).pushReplacementNamed("/workouts/strength");  
                                    } else if(_movementMeterFilter == "Metabolic") {
                                      Navigator.of(context).pushReplacementNamed("/workouts/metabolic");  
                                    } else if(_movementMeterFilter == "Power") {
                                      Navigator.of(context).pushReplacementNamed("/workouts/power");  
                                    } else {           
                                      Navigator.of(context).pushReplacementNamed("/workouts");                                      
                                    }
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      'assets/images/filter_search.png', 
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                        ]
                      )
                    ),    

                    filterNumber == 1 ?
                      new Container(
                        height: MediaQuery.of(context).size.height*0.70,
                        child: new Column(                                    
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              ' What do you want to focus on?',
                              style: TextStyle(
                                fontSize: 32
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_movementMeterFilter != "Mobility") {
                                      _setFilterMovementMeter("Mobility");
                                    } else {
                                      _setFilterMovementMeter("");
                                    }
                                  },
                                  child: new Column(
                                    children: <Widget> [
                                      new Image.asset(
                                        'assets/images/mobility.png'
                                      ),
                                      new Text(
                                        'Mobility',
                                        style: TextStyle(
                                          fontSize: 24.0
                                        )
                                      )
                                    ]
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _movementMeterFilter == "Mobility" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(30.0),
                                ),                                    
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_movementMeterFilter != "Strength") {
                                      _setFilterMovementMeter("Strength");
                                    } else {
                                      _setFilterMovementMeter("");
                                    }
                                  },
                                  child: new Column(
                                    children: <Widget> [
                                      new Image.asset(
                                        'assets/images/strength.png'
                                      ),
                                      new Text(
                                        'Strength',
                                        style: TextStyle(
                                          fontSize: 24.0
                                        )
                                      )
                                    ]
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _movementMeterFilter == "Strength" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(30.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_movementMeterFilter != "Metabolic") {
                                      _setFilterMovementMeter("Metabolic");
                                    } else {
                                      _setFilterMovementMeter("");
                                    }
                                  },
                                  child: new Column(
                                    children: <Widget> [
                                      new Image.asset(
                                        'assets/images/metabolic.png'
                                      ),
                                      new Text(
                                        'Metabolic',
                                        style: TextStyle(
                                          fontSize: 24.0
                                        )
                                      )
                                    ]
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _movementMeterFilter == "Metabolic" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(30.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_movementMeterFilter != "Power") {
                                      _setFilterMovementMeter("Power");
                                    } else {
                                      _setFilterMovementMeter("");
                                    }
                                  },
                                  child: new Column(
                                    children: <Widget> [
                                      new Image.asset(
                                        'assets/images/power.png'
                                      ),
                                      new Text(
                                        'Power',
                                        style: TextStyle(
                                          fontSize: 24.0
                                        )
                                      )
                                    ]
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _movementMeterFilter == "Power" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(30.0),
                                ),
                              ],
                            )
                          ],
                        )
                      )
                    : new Container(),

                    // filterNumber == 2 ?
                    //   new Container(
                    //     height: MediaQuery.of(context).size.height*0.70,
                    //     child: new Column(                                    
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: <Widget>[
                    //         new Text(
                    //           ' Which sports workout do you like ?',
                    //           style: TextStyle(
                    //             fontSize: 32
                    //           ),
                    //         ),
                    //         new Wrap(
                    //           spacing: 24.0, // gap between adjacent chips
                    //           runSpacing: 24.0,                               
                    //           alignment: WrapAlignment.center,
                    //           children: _listAvailableSports(),                                  
                    //         )
                    //       ],
                    //     )
                    //   )
                    // : new Container(),

                    filterNumber == 3 ?
                      new Container(
                        height: MediaQuery.of(context).size.height*0.70,
                        child: new Column(                                    
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              ' What equipment do you have?',
                              style: TextStyle(
                                fontSize: 32
                              ),
                            ),
                            new Wrap(   
                              spacing: 48.0, // gap between adjacent chips
                              runSpacing: 48.0,                               
                              alignment: WrapAlignment.center,
                              children: <Widget>[
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {                                            
                                        _setFilterEquipment('bodyweight');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_bodyweight.jpeg"
                                            )
                                          )
                                        ),                                            
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentBodyweight != null && _equipmentBodyweight == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Bodyweight',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {
                                        _setFilterEquipment('dumbbell');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_dumbbell.jpg"
                                            )
                                          )
                                        ),
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentDumbbell != null && _equipmentDumbbell == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Dumbbells',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {
                                        _setFilterEquipment('kettlebell');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_kettlebells.jpeg"
                                            )
                                          )
                                        ),
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentKettlebell != null && _equipmentKettlebell == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Kettlebells',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {
                                        _setFilterEquipment('powerplate');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_powerplate.jpg"
                                            )
                                          )
                                        ),
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentPowerplate != null && _equipmentPowerplate == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Power Plate',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {
                                        _setFilterEquipment('foamroller');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_foamroller.png"
                                            )
                                          )
                                        ),
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentFoamroller != null && _equipmentFoamroller == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Foam Roller',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {
                                        _setFilterEquipment('band');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_bands.jpeg"
                                            )
                                          )
                                        ),
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentBand != null && _equipmentBand == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'Bands',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {                                            
                                        _setFilterEquipment('bosu');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_bosu.jpeg"
                                            )
                                          )
                                        ),                                            
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentBosu != null && _equipmentBosu == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'BOSU',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                                new Column(
                                  children: <Widget> [
                                    new GestureDetector(
                                      onTap: () {                                            
                                        _setFilterEquipment('rockblade');
                                      },
                                      child: new Container(
                                        width: 190.0,
                                        height: 190.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              "assets/images/equipment_rockblade.jpeg"
                                            )
                                          )
                                        ),                                            
                                        child: new Stack(
                                          children: <Widget>[
                                            _equipmentRockblade != null && _equipmentRockblade == true? 
                                              new Positioned(
                                                left: 75,
                                                top: 75,
                                                child: new Image.asset(
                                                  'assets/images/check.png',
                                                  width: 48,
                                                  height: 48,
                                                )
                                              )
                                            : new Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new Text(
                                      'RockBlade',
                                      style: TextStyle(fontSize: 18)
                                    )
                                  ]
                                ),
                              ],
                            )                                
                          ],
                        )
                      )
                    : new Container(),

                    // filterNumber == 4 ?
                    //   new Container(
                    //     height: MediaQuery.of(context).size.height*0.70,
                    //     child: new Column(                                    
                    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //       children: <Widget>[
                    //         new Text(
                    //           ' What type of workout do you want to do? ',
                    //           style: TextStyle(
                    //             fontSize: 32
                    //           ),
                    //         ),
                    //         new Wrap(   
                    //           spacing: 24.0, // gap between adjacent chips
                    //           runSpacing: 24.0,                               
                    //           alignment: WrapAlignment.center,
                    //           children: <Widget>[
                    //             new Column(
                    //               children: <Widget> [
                    //                 new GestureDetector(
                    //                   onTap: () {
                    //                     if(_workoutType != "Traditional") {
                    //                       _setWorkoutType("Traditional");
                    //                     } else {
                    //                       _setWorkoutType("");
                    //                     }
                    //                   },
                    //                   child: new Container(
                    //                     width: 190.0,
                    //                     height: 190.0,
                    //                     decoration: new BoxDecoration(
                    //                       shape: BoxShape.circle,
                    //                       image: new DecorationImage(
                    //                         fit: BoxFit.fill,
                    //                         image: new AssetImage(
                    //                           "assets/images/type_traditional.png"
                    //                         )
                    //                       )
                    //                     ),
                    //                     child: new Stack(
                    //                       children: <Widget>[
                    //                         _workoutType != null && _workoutType == "Traditional"? 
                    //                           new Positioned(
                    //                             left: 75,
                    //                             top: 75,
                    //                             child: new Image.asset(
                    //                               'assets/images/check.png',
                    //                               width: 48,
                    //                               height: 48,
                    //                             )
                    //                           )
                    //                         : new Container(),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 new Text(
                    //                   'Traditional',
                    //                   style: TextStyle(fontSize: 18)
                    //                 )
                    //               ]
                    //             ),
                    //             new Column(
                    //               children: <Widget> [
                    //                 new GestureDetector(
                    //                   onTap: () {
                    //                     if(_workoutType != "Functional") {
                    //                       _setWorkoutType("Functional");
                    //                     } else {
                    //                       _setWorkoutType("");
                    //                     }
                    //                   },
                    //                   child: new Container(
                    //                     width: 190.0,
                    //                     height: 190.0,
                    //                     decoration: new BoxDecoration(
                    //                       shape: BoxShape.circle,
                    //                       image: new DecorationImage(
                    //                         fit: BoxFit.fill,
                    //                         image: new AssetImage(
                    //                           "assets/images/type_functional.png"
                    //                         )
                    //                       )
                    //                     ),
                    //                     child: new Stack(
                    //                       children: <Widget>[
                    //                         _workoutType != null && _workoutType == "Functional"? 
                    //                           new Positioned(
                    //                             left: 75,
                    //                             top: 75,
                    //                             child: new Image.asset(
                    //                               'assets/images/check.png',
                    //                               width: 48,
                    //                               height: 48,
                    //                             )
                    //                           )
                    //                         : new Container(),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 new Text(
                    //                   'Functional',
                    //                   style: TextStyle(fontSize: 18)
                    //                 )
                    //               ]
                    //             )                                    
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    // : new Container(),    

                    filterNumber == 5 ?
                      new Container(
                        height: MediaQuery.of(context).size.height*0.70,
                        child: new Column(                                    
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              ' How much time do you have ?',
                              style: TextStyle(
                                fontSize: 32
                              ),
                            ),
                            new Wrap(
                              spacing: 24.0, // gap between adjacent chips
                              runSpacing: 24.0,                               
                              alignment: WrapAlignment.center,
                              children: <Widget>[
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 5) {
                                      _setWorkoutDuration(5);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '5 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 5 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 10) {
                                      _setWorkoutDuration(10);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '10 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 10 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 15) {
                                      _setWorkoutDuration(15);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '15 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 15 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ), 
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 20) {
                                      _setWorkoutDuration(20);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '20 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 20 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 25) {
                                      _setWorkoutDuration(25);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '25 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 25 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutDuration != 30) {
                                      _setWorkoutDuration(30);
                                    } else {
                                      _setWorkoutDuration(0);
                                    }
                                  },
                                  child: new Text(
                                    '30 minutes',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutDuration == 30 ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(56.0),
                                ),                                                                       
                              ],
                            )
                          ],
                        )
                      )
                    : new Container(),

                    filterNumber == 6 ?
                      new Container(
                        height: MediaQuery.of(context).size.height*0.70,
                        child: new Column(                                    
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              ' What is your fitness level ?',
                              style: TextStyle(
                                fontSize: 32
                              ),
                            ),
                            new Wrap(
                              spacing: 24.0, // gap between adjacent chips
                              runSpacing: 24.0,                               
                              alignment: WrapAlignment.center,
                              children: <Widget>[
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutFitnessLevel != "Beginner") {
                                      _setWorkoutFitnessLevel("Beginner");
                                    } else {
                                      _setWorkoutFitnessLevel("");
                                    }                                        
                                  },
                                  child: new Text(
                                    'Beginner',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutFitnessLevel == "Beginner" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(64.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutFitnessLevel != "Intermediate") {
                                      _setWorkoutFitnessLevel("Intermediate");
                                    } else {
                                      _setWorkoutFitnessLevel("");
                                    }
                                  },
                                  child: new Text(
                                    'Intermediate',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutFitnessLevel == "Intermediate" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(64.0),
                                ),
                                new RawMaterialButton(
                                  onPressed: () {
                                    if(_workoutFitnessLevel != "Advanced") {
                                      _setWorkoutFitnessLevel("Advanced");
                                    } else {
                                      _setWorkoutFitnessLevel("");
                                    }
                                  },
                                  child: new Text(
                                    'Advanced',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: _workoutFitnessLevel == "Advanced" ? Colors.green : dhfYellow,
                                  padding: const EdgeInsets.all(64.0),
                                ),                                     
                              ],
                            )
                          ],
                        )
                      )
                    : new Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _drawSmallerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Filters'
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: dhfYellow,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/workouts");
          },
        ),
        actions: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                GomotiveIcons.select,
                color: dhfYellow,
              ),
              onPressed: () {        
                if(_movementMeterFilter == "Mobility") {
                  Navigator.of(context).pushReplacementNamed("/workouts/mobility");  
                } else if(_movementMeterFilter == "Strength") {
                  Navigator.of(context).pushReplacementNamed("/workouts/strength");  
                } else if(_movementMeterFilter == "Metabolic") {
                  Navigator.of(context).pushReplacementNamed("/workouts/metabolic");  
                } else if(_movementMeterFilter == "Power") {
                  Navigator.of(context).pushReplacementNamed("/workouts/power");  
                } else {           
                  Navigator.of(context).pushReplacementNamed("/workouts");                                      
                }
              },
            ),                
          ),
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
                  children: <Widget>[
                    token != null && token != ""
                    ? new Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black12
                            ),
                          ),
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              "My Favorite Workouts",
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                            ),
                            new Switch(
                              value: _favoriteEnabled,
                              activeColor: Colors.green,
                              onChanged: (bool value) {
                                this._filterFavoriteActionCreator(value);
                              }                           
                            )
                          ],
                        )
                      )
                    : new Container(),   
                                        new Container(                                                    
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "MOVEMENT METER",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      child: new DropdownFormField(  
                        labelKey: "name",
                        valueKey: "id",
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        autovalidate: true,  
                        initialValue: _movementMeterFilter,                                    
                        options: _movementMeterList,
                        validator: (value) {
                          if(value != null && value != "") {
                            if(this._filterMovementMeterActionCreator != null) {
                              this._filterMovementMeterActionCreator(value);                                                            
                            }                            
                          } else {
                            if(this._filterMovementMeterActionCreator != null) {
                              this._filterMovementMeterActionCreator("");                              
                            }
                          }                          
                        },        
                      ),                      
                    ),                                     
                    // _availableSports.length > 1
                    // ? new Column(
                    //     children: <Widget>[
                    //       new Container(                                                   
                    //         padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                    //         decoration: BoxDecoration(
                    //           color: Colors.blueGrey
                    //         ),
                    //         child: new Center(
                    //           child: new Text(
                    //             "SPORTS",
                    //             style: TextStyle(
                    //               fontSize: 20.0,
                    //               color: Colors.white,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           )
                    //         )
                    //       ),                    
                    //       new Container(
                    //         padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    //         child: new DropdownFormField(  
                    //           labelKey: "name",
                    //           valueKey: "id",
                    //           decoration: InputDecoration(
                    //             border: new UnderlineInputBorder(
                    //               borderSide: new BorderSide(
                    //                 color: Colors.black87,
                    //               ),
                    //             ),
                    //           ),
                    //           autovalidate: true,                                      
                    //           initialValue: _workoutSports,
                    //           options: _availableSports,
                    //           validator: (value) { 
                    //             if(value != null && value != "") {
                    //               if(this._filterWorkoutSportsActionCreator!= null) {
                    //                 this._filterWorkoutSportsActionCreator(int.parse(value));
                    //               }
                    //             } else {
                    //               if(this._filterWorkoutSportsActionCreator!= null) {
                    //                 this._filterWorkoutSportsActionCreator(0);
                    //               }
                    //             }
                    //           },        
                    //         ),
                    //       ),
                    //     ],
                    //   )
                    // : new Container(),                     
                    new Container(                                                    
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "EQUIPMENT",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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
                        ),
                        autovalidate: true,
                        enabled: true,
                        optionList: _equipmentList,
                        initialValue: _selectedEquipmentList,       
                        validator: (value) {
                          if(value != null) {                            
                            _selectedEquipmentList = value;
                            if(_filterEquipmentActionCreator != null) {
                              for(int i=0;i<_selectedEquipmentList.length; i++) {
                                if(_selectedEquipmentList[i] == "bw") {
                                  this._filterEquipmentActionCreator('bodyweight');
                                } else if(_selectedEquipmentList[i] == "db") {
                                  this._filterEquipmentActionCreator('dumbbell');
                                } else if(_selectedEquipmentList[i] == "kb") {
                                  this._filterEquipmentActionCreator('kettlebell');
                                } else if(_selectedEquipmentList[i] == "pp") {
                                  this._filterEquipmentActionCreator('powerplate');
                                } else if(_selectedEquipmentList[i] == "fm") {
                                  this._filterEquipmentActionCreator('foamroller');
                                } else if(_selectedEquipmentList[i] == "bd") {
                                  this._filterEquipmentActionCreator('band');
                                } else if(_selectedEquipmentList[i] == "bo") {
                                  this._filterEquipmentActionCreator('bosu');
                                } else if(_selectedEquipmentList[i] == "rb") {
                                  this._filterEquipmentActionCreator('rockblade');
                                }
                              }
                            }
                          }
                        },                              
                      ),
                    ),
                    // new Container(                                                    
                    //   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.blueGrey
                    //   ),
                    //   child: new Center(
                    //     child: new Text(
                    //       "WORKOUT TYPE",
                    //       style: TextStyle(
                    //         fontSize: 20.0,
                    //         color: Colors.white,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     )
                    //   )
                    // ),
                    // new Container(
                    //   padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    //   child: new DropdownFormField(  
                    //     labelKey: "name",
                    //     valueKey: "id",
                    //     decoration: InputDecoration(
                    //       border: new UnderlineInputBorder(
                    //         borderSide: new BorderSide(
                    //           color: Colors.black87,
                    //         ),
                    //       ),
                    //     ),
                    //     autovalidate: true,                                      
                    //     initialValue: _workoutType,
                    //     options: _workoutTypeList,
                    //     validator: (value) { 
                    //       if(value != null && value != "") {
                    //         if(this._filterWorkoutTypeActionCreator!= null) {
                    //           this._filterWorkoutTypeActionCreator(value);
                    //         }
                    //       } else {
                    //         if(this._filterWorkoutTypeActionCreator!= null) {
                    //           this._filterWorkoutTypeActionCreator("");
                    //         }
                    //       }
                    //     },        
                    //   ),
                    // ),
                    new Container(                                                    
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "DURATION",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      child: new DropdownFormField(  
                        labelKey: "name",
                        valueKey: "id",
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        autovalidate: true,                                      
                        initialValue: _workoutDuration,
                        options: _durationList,
                        validator: (value) { 
                          if(value != null && value != "") {
                            if(this._filterWorkoutDurationActionCreator!= null) {
                              this._filterWorkoutDurationActionCreator(int.parse(value));
                            }
                          } else {
                            if(this._filterWorkoutDurationActionCreator!= null) {
                              this._filterWorkoutDurationActionCreator(0);
                            }
                          }
                        },        
                      ),
                    ),
                    new Container(                                                    
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                      child: new Center(
                        child: new Text(
                          "FITNESS LEVEL",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      child: new DropdownFormField(  
                        labelKey: "name",
                        valueKey: "id",
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        autovalidate: true,                                      
                        initialValue: _workoutFitnessLevel,
                        options: _fitnessLevelList,
                        validator: (value) { 
                          if(value != null && value != "") {
                            if(this._filterWorkoutFitnessLevelActionCreator!= null) {
                              this._filterWorkoutFitnessLevelActionCreator(value);
                            }
                          } else {
                            if(this._filterWorkoutFitnessLevelActionCreator!= null) {
                              this._filterWorkoutFitnessLevelActionCreator("");
                            }
                          }
                        },        
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
                    )
                  ],
                )
              )
            )
          );
        }
      )
    );
  }

  List<Map<String, dynamic>> _movementMeterList, _equipmentList, _workoutTypeList, _durationList, _fitnessLevelList;
  List<String> _selectedEquipmentList;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
         DeviceOrientation.landscapeLeft,
         DeviceOrientation.landscapeRight,
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown
      ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _filterMovementMeterActionCreator = stateObject["filterMovementMeterActionCreator"];
        _filterEquipmentActionCreator = stateObject["filterEquipmentActionCreator"];
        _filterWorkoutTypeActionCreator = stateObject["filterWorkoutTypeActionCreator"];
        _filterWorkoutDurationActionCreator = stateObject["filterWorkoutDurationActionCreator"];
        _filterWorkoutFitnessLevelActionCreator = stateObject["filterWorkoutFitnessLevelActionCreator"];
        _filterWorkoutSportsActionCreator = stateObject["filterWorkoutSportsActionCreator"];
        _filterFavoriteActionCreator = stateObject["filterFavoriteActionCreator"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();     
        returnObject["filterMovementMeterActionCreator"] = (String movementMeterFilter) =>
          store.dispatch(FilterMovementMeterActionCreator(movementMeterFilter)
        );   
        returnObject["filterEquipmentActionCreator"] = (String toggleEquipment) =>
          store.dispatch(FilterEquipmentActionCreator(toggleEquipment)
        );
        returnObject["filterWorkoutTypeActionCreator"] = (String workoutType) =>
          store.dispatch(FilterWorkoutTypeActionCreator(workoutType)
        );
        returnObject["filterWorkoutDurationActionCreator"] = (int workoutDuration) =>
          store.dispatch(FilterWorkoutDurationActionCreator(workoutDuration)
        );
        returnObject["filterWorkoutFitnessLevelActionCreator"] = (String workoutFintessLevel) =>
          store.dispatch(FilterWorkoutFitnessLevelActionCreator(workoutFintessLevel)
        );
        returnObject["filterWorkoutSportsActionCreator"] = (int workoutSports) =>
          store.dispatch(FilterWorkoutSportsActionCreator(workoutSports)
        );    
        returnObject["filterFavoriteActionCreator"] = (bool favoriteEnabled) =>
          store.dispatch(FilterFavoriteActionCreator(favoriteEnabled)
        );           
        returnObject["movementMeterFilter"] = store.state.homeFitWorkoutState.movementMeterFilter;
        returnObject["equipmentBodyWeight"] = store.state.homeFitWorkoutState.equipmentBodyweight;
        returnObject["equipmentDumbbell"] = store.state.homeFitWorkoutState.equipmentDumbbell;
        returnObject["equipmentKettlebell"] = store.state.homeFitWorkoutState.equipmentKettlebell;
        returnObject["equipmentPowerplate"] = store.state.homeFitWorkoutState.equipmentPowerPlate;
        returnObject["equipmentFoamroller"] = store.state.homeFitWorkoutState.equipmentFoamRoller;
        returnObject["equipmentBand"] = store.state.homeFitWorkoutState.equipmentBands;
        returnObject["equipmentBosu"] = store.state.homeFitWorkoutState.equipmentBosu;
        returnObject["equipmentRockblade"] = store.state.homeFitWorkoutState.equipmentRockblade;
        returnObject["workoutType"] = store.state.homeFitWorkoutState.workoutType;
        returnObject["workoutDuration"] = store.state.homeFitWorkoutState.workoutDuration;
        returnObject["workoutFitnessLevel"] = store.state.homeFitWorkoutState.workoutFitnessLevel;
        returnObject["workoutSports"] = store.state.homeFitWorkoutState.workoutSports;
        returnObject["availableSports"] = store.state.homeFitHomeState.availableSports;
        returnObject["favoriteEnabled"] = store.state.homeFitWorkoutState.favoriteEnabled;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _movementMeterFilter = stateObject["movementMeterFilter"];
        _equipmentBodyweight = stateObject["equipmentBodyWeight"];
        _equipmentDumbbell = stateObject["equipmentDumbbell"];
        _equipmentKettlebell = stateObject["equipmentKettlebell"];
        _equipmentPowerplate = stateObject["equipmentPowerplate"];
        _equipmentFoamroller = stateObject["equipmentFoamroller"];
        _equipmentBand = stateObject["equipmentBand"];
        _equipmentBosu = stateObject["equipmentBosu"];
        _equipmentRockblade = stateObject["equipmentRockblade"];
        _workoutType = stateObject["workoutType"];
        _workoutDuration = stateObject["workoutDuration"];
        _workoutFitnessLevel = stateObject["workoutFitnessLevel"];
        _workoutSports = stateObject["workoutSports"];
        _availableSports = stateObject["availableSports"];
        _favoriteEnabled = stateObject["favoriteEnabled"];
        if(_favoriteEnabled == null) {
          _favoriteEnabled = false;
        }
        if(mobileLayout) {                
          _movementMeterList = new List<Map<String, dynamic>>();
          _movementMeterList.add({'id': "", 'name': ''});
          _movementMeterList.add({'id': "Mobility", 'name': 'Mobility'});
          _movementMeterList.add({'id': "Strength", 'name': 'Strength'});
          _movementMeterList.add({'id': "Metabolic", 'name': 'Metabolic'});
          _movementMeterList.add({'id': "Power", 'name': 'Power'}); 
          if(_movementMeterFilter == "") {
            _movementMeterFilter = null;
          } 

          if(_workoutSports != null && _workoutSports != "") {
            _workoutSports = _workoutSports.toString();
          } else {
            _workoutSports = null;
          }

          _equipmentList = new List<Map<String, dynamic>>();          
          _equipmentList.add({'id': 'bw', 'name': 'Bodyweight'});
          _equipmentList.add({'id': 'db', 'name': 'Dumbbell'});
          _equipmentList.add({'id': 'kb', 'name': 'Kettlebell'});
          _equipmentList.add({'id': 'pp', 'name': 'Power Plate'});
          _equipmentList.add({'id': 'fr', 'name': 'Foam Roller'});
          _equipmentList.add({'id': 'bd', 'name': 'Bands'});
          _equipmentList.add({'id': 'bo', 'name': 'BOSU'});
          _equipmentList.add({'id': 'rb', 'name': 'RockBlade'});
          
          _selectedEquipmentList = new List<String>();
          if(_equipmentBodyweight) {
            _selectedEquipmentList.add('bw');
          }
          if(_equipmentDumbbell) {
            _selectedEquipmentList.add('db');
          }
          if(_equipmentKettlebell) {
            _selectedEquipmentList.add('kb');
          }
          if(_equipmentPowerplate) {
            _selectedEquipmentList.add('pp');
          }
          if(_equipmentFoamroller) {
            _selectedEquipmentList.add('fr');
          }
          if(_equipmentBand) {
            _selectedEquipmentList.add('bd');
          }
          if(_equipmentBosu) {
            _selectedEquipmentList.add('bo');
          }
          if(_equipmentRockblade) {
            _selectedEquipmentList.add('rb');
          }

          _workoutTypeList = new List<Map<String, dynamic>>();
          _workoutTypeList.add({'id': "", 'name': ''});
          _workoutTypeList.add({'id': "Functional", 'name': 'Functional'});
          _workoutTypeList.add({'id': "Traditional", 'name': 'Traditional'});
          if(_workoutType == "") {
            _workoutType = null;
          }
          
          _durationList = new List<Map<String, dynamic>>();
          _durationList.add({'id': "0", 'name': ''});
          _durationList.add({'id': "5", 'name': '5 minutes'});
          _durationList.add({'id': "10", 'name': '10 minutes'});
          _durationList.add({'id': "15", 'name': '15 minutes'});
          _durationList.add({'id': "20", 'name': '20 minutes'});
          _durationList.add({'id': "25", 'name': '25 minutes'});
          _durationList.add({'id': "30", 'name': '30 minutes'});
          _durationList.add({'id': "35", 'name': '35 minutes'});
          _durationList.add({'id': "40", 'name': '40 minutes'});
          _durationList.add({'id': "45", 'name': '45 minutes'});
          _durationList.add({'id': "50", 'name': '50 minutes'});
          _durationList.add({'id': "55", 'name': '55 minutes'});
          _durationList.add({'id': "60", 'name': '60 minutes'});
          if(_workoutDuration != null && _workoutDuration != "")  {
            _workoutDuration = _workoutDuration.toString();
          } else {
            _workoutDuration = null;
          }

          _fitnessLevelList = new List<Map<String, dynamic>>();
          _fitnessLevelList.add({'id': "", 'name': ''});
          _fitnessLevelList.add({'id': "Beginner", 'name': 'Beginner'});
          _fitnessLevelList.add({'id': "Intermediate", 'name': 'Intermediate'});
          _fitnessLevelList.add({'id': "Advanced", 'name': 'Advanced'});
          if(_workoutFitnessLevel == "") {
            _workoutFitnessLevel = null;
          }
          return this._drawSmallerDeviceWidget();
        } else {
          return this._drawLargerDeviceWidget();
        }        
      } 
    );
  }
}
