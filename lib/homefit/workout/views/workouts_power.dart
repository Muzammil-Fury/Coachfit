import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/workout/views/workout_preview.dart';
import 'package:gomotive/homefit/workout/workout_network.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/workout/views/workout_filter.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/utils/menu_utils.dart';

class WorkoutsPower extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _WorkoutsPower(),
        )        
      ),
    );
  }
}

class _WorkoutsPower extends StatefulWidget {
  @override
  _WorkoutsPowerState createState() => new _WorkoutsPowerState();
}

class _WorkoutsPowerState extends State<_WorkoutsPower> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getPowerAccelerationDecelerationWorkouts, 
      _getPowerSpeedReactionWorkouts, 
      _getPowerMaxPowerWorkouts, 
      _getPowerPlyometricsReactionWorkouts,
      _getPowerKidsfitReactionWorkouts;

  List<Map> _powerAccelerationDecelerationWorkouts, 
            _powerSpeedReactionWorkouts, 
            _powerMaxPowerWorkouts, 
            _powerPlyometricsWorkouts,
            _powerKidsfitWorkouts;
  
  Map _powerAccelerationDecelerationPaginateInfo, 
      _powerSpeedReactionPaginateInfo, 
      _powerMaxPowerPaginateInfo, 
      _powerPlyometricsPaginateInfo,
      _powerKidsfitPaginateInfo;
  
  bool _filterFavoriteEnabled;
  String _filterWorkoutType, _filterWorkoutFitnessLevel;
  int _filterWorkoutDuration;
  int _filterWorkoutSports;
  bool  _filterEquipmentBodyweight, 
        _filterEquipmentDumbbell, 
        _filterEquipmentKettlebell, 
        _filterEquipmentPowerplate, 
        _filterEquipmentFoamroller, 
        _filterEquipmentBand,
        _filterEquipmentBosu,
        _filterEquipmentRockblade;
  var _user;

  ScrollController  _powerAccelerationDecelerationController, 
                    _powerSpeedReactionController, 
                    _powerMaxPowerController, 
                    _powerPlyometricsController,
                    _powerKidsfitController;

  _getSearchParams(int pageNumber) {
    var params = new Map();
    params["page"] = pageNumber;    
    var _equipments = new List<String>();
    if(_filterEquipmentBodyweight) {
      _equipments.add('bw');
    }
    if(_filterEquipmentDumbbell) {
      _equipments.add('db');
    }
    if(_filterEquipmentKettlebell) {
      _equipments.add('kb');
    }
    if(_filterEquipmentPowerplate) {
      _equipments.add('pp');
    }
    if(_filterEquipmentFoamroller) {
      _equipments.add('fr');
    }
    if(_filterEquipmentBand) {
      _equipments.add('bd');
    }
    if(_filterEquipmentBosu) {
      _equipments.add('bo');
    }
    if(_filterEquipmentRockblade) {
      _equipments.add('rb');
    }
    params['equipments'] = _equipments;
    if(_filterWorkoutType != "") {
      params['function'] = _filterWorkoutType;
    } else {
      params['function'] = null;
    }
    if(_filterWorkoutDuration != 0) {
      params['time'] = _filterWorkoutDuration;
    } else {
      params['time'] = null;
    }
    if(_filterWorkoutFitnessLevel != "") {
      params['level'] = _filterWorkoutFitnessLevel;
    } else {
      params['level'] = null;
    }
    if(_filterWorkoutSports != 0) {
      params['sports'] = _filterWorkoutSports;
    } else {
      params['sports'] = null;
    }    
    params['show_favorites'] = _filterFavoriteEnabled;
    return params;
  }

  _powerAccelerationDecelerationScrollListener() {
    if (_powerAccelerationDecelerationController.offset >= _powerAccelerationDecelerationController.position.maxScrollExtent && !_powerAccelerationDecelerationController.position.outOfRange) {
      if(_powerAccelerationDecelerationPaginateInfo.containsKey("total_pages") && ((_powerAccelerationDecelerationPaginateInfo["page"]+1) < _powerAccelerationDecelerationPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerAccelerationDecelerationPaginateInfo["page"] + 1);
        _getPowerAccelerationDecelerationWorkouts(context, params);  
      }
    }
  }

  _powerSpeedReactionScrollListener() {
    if (_powerSpeedReactionController.offset >= _powerSpeedReactionController.position.maxScrollExtent && !_powerSpeedReactionController.position.outOfRange) {
      if(_powerSpeedReactionPaginateInfo.containsKey("total_pages") && ((_powerSpeedReactionPaginateInfo["page"]+1) < _powerSpeedReactionPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerSpeedReactionPaginateInfo["page"] + 1);
        _getPowerSpeedReactionWorkouts(context, params);    
      }
    }
  }

  _powerMaxPowerScrollListener() {
    if (_powerMaxPowerController.offset >= _powerMaxPowerController.position.maxScrollExtent && !_powerMaxPowerController.position.outOfRange) {
      if(_powerMaxPowerPaginateInfo.containsKey("total_pages") && ((_powerMaxPowerPaginateInfo["page"]+1) < _powerMaxPowerPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerMaxPowerPaginateInfo["page"] + 1);
        _getPowerMaxPowerWorkouts(context, params);    
      }
    }
  }

  _powerPlyometricsScrollListener() {
    if (_powerPlyometricsController.offset >= _powerPlyometricsController.position.maxScrollExtent && !_powerPlyometricsController.position.outOfRange) {
      if(_powerPlyometricsPaginateInfo.containsKey("total_pages") && ((_powerPlyometricsPaginateInfo["page"]+1) < _powerPlyometricsPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerPlyometricsPaginateInfo["page"] + 1);
        _getPowerPlyometricsReactionWorkouts(context, params);    
      }
    }
  }

  _powerKidsfitScrollListener() {
    if (_powerKidsfitController.offset >= _powerKidsfitController.position.maxScrollExtent && !_powerKidsfitController.position.outOfRange) {
      if(_powerKidsfitPaginateInfo.containsKey("total_pages") && ((_powerKidsfitPaginateInfo["page"]+1) < _powerKidsfitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerKidsfitPaginateInfo["page"] + 1);
        _getPowerKidsfitReactionWorkouts(context, params);    
      }
    }
  }

  
  _fetchWorkouts(int pageNumber) {
    Map params = _getSearchParams(pageNumber);
    _getPowerAccelerationDecelerationWorkouts(context, params);    
    _getPowerSpeedReactionWorkouts(context, params);
    _getPowerMaxPowerWorkouts(context, params);   
    _getPowerPlyometricsReactionWorkouts(context, params); 
    _getPowerKidsfitReactionWorkouts(context, params);
  }

  @override
  void initState() {
    _powerAccelerationDecelerationController = ScrollController();
    _powerAccelerationDecelerationController.addListener(_powerAccelerationDecelerationScrollListener);   
    _powerSpeedReactionController = ScrollController();
    _powerSpeedReactionController.addListener(_powerSpeedReactionScrollListener);   
    _powerMaxPowerController = ScrollController();
    _powerMaxPowerController.addListener(_powerMaxPowerScrollListener);   
    _powerPlyometricsController = ScrollController();
    _powerPlyometricsController.addListener(_powerPlyometricsScrollListener);       
    _powerKidsfitController = ScrollController();
    _powerKidsfitController.addListener(_powerKidsfitScrollListener);       
    super.initState();
  }

  List<Widget> _listWorkouts() {
    double width = 300;
    double height = 200;

    List<Widget> list = new List();
    
    Container _acHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            child: new Text(
              'Acceleration / Decleration Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_acHeaderContainer);  

    if(_powerAccelerationDecelerationWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerAccelerationDecelerationWorkouts.length,
          controller: _powerAccelerationDecelerationController,
          itemBuilder: (context, i) {
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              child: new GestureDetector(
                onTapDown: (TapDownDetails details) {          
                },
                onTap: () {                        
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => 
                      WorkoutPreview(workoutId: _powerAccelerationDecelerationWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerAccelerationDecelerationWorkouts[i], _user, width, height)
              )
            );
          }
        )
      );        
      list.add(_workoutContainer);
    } else {
      Container _workoutContainer = new Container(
        height: 100,
        child: new Center(
          child: new Text(
            "No workouts available."
          )
        )
      );
      list.add(_workoutContainer);
    }

    
    Container _srHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            child: new Text(
              'Speed Reaction Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_srHeaderContainer);  

    if(_powerSpeedReactionWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerSpeedReactionWorkouts.length,
          controller: _powerSpeedReactionController,
          itemBuilder: (context, i) {
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              child: new GestureDetector(
                onTapDown: (TapDownDetails details) {          
                },
                onTap: () {                        
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => 
                      WorkoutPreview(workoutId: _powerSpeedReactionWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerSpeedReactionWorkouts[i], _user, width, height)
              )
            );
          }
        )
      );        
      list.add(_workoutContainer);
    } else {
      Container _workoutContainer = new Container(
        height: 100,
        child: new Center(
          child: new Text(
            "No workouts available."
          )
        )
      );
      list.add(_workoutContainer);
    }
    
    Container _mpHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            child: new Text(
              'Max Power Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_mpHeaderContainer);  

    if(_powerMaxPowerWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerMaxPowerWorkouts.length,
          controller: _powerMaxPowerController,
          itemBuilder: (context, i) {
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              child: new GestureDetector(
                onTapDown: (TapDownDetails details) {          
                },
                onTap: () {                        
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => 
                      WorkoutPreview(workoutId: _powerMaxPowerWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerMaxPowerWorkouts[i], _user, width, height)
              )
            );
          }
        )
      );        
      list.add(_workoutContainer);
    } else {
      Container _workoutContainer = new Container(
        height: 100,
        child: new Center(
          child: new Text(
            "No workouts available."
          )
        )
      );
      list.add(_workoutContainer);
    }

    
    Container _plyHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Plyometrics Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_plyHeaderContainer);  

    if(_powerPlyometricsWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerPlyometricsWorkouts.length,
          controller: _powerPlyometricsController,
          itemBuilder: (context, i) {
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              child: new GestureDetector(
                onTapDown: (TapDownDetails details) {          
                },
                onTap: () {                        
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => 
                      WorkoutPreview(workoutId: _powerPlyometricsWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerPlyometricsWorkouts[i], _user, width, height)
              )
            );
          }
        )
      );        
      list.add(_workoutContainer);
    } else {
      Container _workoutContainer = new Container(
        height: 100,
        child: new Center(
          child: new Text(
            "No workouts available."
          )
        )
      );
      list.add(_workoutContainer);
    }

    Container _headerContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'KidsFit Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_headerContainer);  

    if(_powerKidsfitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerKidsfitWorkouts.length,
          controller: _powerKidsfitController,
          itemBuilder: (context, i) {
            return new Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              child: new GestureDetector(
                onTapDown: (TapDownDetails details) {          
                },
                onTap: () {                        
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => 
                      WorkoutPreview(workoutId: _powerKidsfitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerKidsfitWorkouts[i], _user, width, height)
              )
            );
          }
        )
      );        
      list.add(_workoutContainer);
    } else {
      Container _workoutContainer = new Container(
        height: 100,
        child: new Center(
          child: new Text(
            "No workouts available."
          )
        )
      );
      list.add(_workoutContainer);
    }

    return list;
  }

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: new BoxDecoration(
                        color: Colors.black26
                      ),
                      child: Utils.drawMenu(context, "workouts")
                    ),
                    new Container(                            
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>
                        [
                          (token != "" && token != null) ? 
                            new Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                              child: new MaterialButton(
                                height: 50.0, 
                                minWidth: 120.0,
                                color: _filterFavoriteEnabled ? Colors.green : dhfYellow,
                                child: new Text(
                                  'Back',
                                  textScaleFactor: 1.5,
                                ),
                                textColor: Colors.black87, 
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                          : new Container(),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                            child: new MaterialButton(
                              height: 50.0, 
                              minWidth: 120.0,
                              color: dhfYellow,
                              child: new Text(
                                'Search Workouts',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black87, 
                              onPressed: () {                                      
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => 
                                    WorkoutFilter()
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(16, 32, 16, 64),
                      child: new Wrap(
                        spacing: 24.0, // gap between adjacent chips
                        runSpacing: 24.0,
                        alignment: WrapAlignment.center,
                        children: _listWorkouts(),
                      ),  
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
            'Power Workouts'
          )
        ),
        leading: IconButton(                  
          icon: Icon(
            GomotiveIcons.back,
            size: 30.0,
            color: dhfYellow,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
            child: IconButton(
              icon: Icon(
                GomotiveIcons.filter,
                color: dhfYellow,
              ),
              onPressed: () {   
                Navigator.of(context).pushReplacementNamed("/workouts/filter");                                      
              },
            ),                
          ),
        ],
      ), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: MenuUtils.buildNavigationMenuBar("workouts"),
        onTap: (int index) {
          if(index != 1) {
            MenuUtils.menubarTap(
              context, "workouts", index
            );
          }
        },
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[                                        
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 64),
                      child: new Wrap(                          
                        runSpacing: 12.0,
                        alignment: WrapAlignment.center,
                        children: _listWorkouts(),
                      ),  
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

 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
         DeviceOrientation.landscapeLeft, 
         DeviceOrientation.landscapeRight,
         DeviceOrientation.portraitDown,
         DeviceOrientation.portraitUp
        ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getPowerAccelerationDecelerationWorkouts = stateObject["getPowerAccelerationDecelerationWorkouts"];
        _getPowerSpeedReactionWorkouts = stateObject["getPowerSpeedReactionWorkouts"];
        _getPowerMaxPowerWorkouts = stateObject["getPowerMaxPowerWorkouts"];
        _getPowerPlyometricsReactionWorkouts = stateObject["getPowerPlyometricsReactionWorkouts"];        
        _getPowerKidsfitReactionWorkouts = stateObject["getPowerKidsfitReactionWorkouts"];  
        _fetchWorkouts(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getPowerAccelerationDecelerationWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerAccelerationDecelerationWorkouts(context, params));
        returnObject["getPowerSpeedReactionWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerSpeedReactionWorkouts(context, params));
        returnObject["getPowerMaxPowerWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerMaxPowerWorkouts(context, params));
        returnObject["getPowerPlyometricsReactionWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerPlyometricsReactionWorkouts(context, params));        
        returnObject["getPowerKidsfitReactionWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerKidsfitReactionWorkouts(context, params));        
        
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["powerAccelerationDecelerationWorkouts"] = store.state.homeFitWorkoutState.powerAccelerationDecelerationWorkouts;
        returnObject["powerSpeedReactionWorkouts"] = store.state.homeFitWorkoutState.powerSpeedReactionWorkouts;
        returnObject["powerMaxPowerWorkouts"] = store.state.homeFitWorkoutState.powerMaxPowerWorkouts;
        returnObject["powerPlyometricsWorkouts"] = store.state.homeFitWorkoutState.powerPlyometricsWorkouts;
        returnObject["powerKidsFitWorkouts"] = store.state.homeFitWorkoutState.powerKidsFitWorkouts;
        returnObject["powerAccelerationDecelerationPaginateInfo"] = store.state.homeFitWorkoutState.powerAccelerationDecelerationPaginateInfo;
        returnObject["powerSpeedReactionPaginateInfo"] = store.state.homeFitWorkoutState.powerSpeedReactionPaginateInfo;
        returnObject["powerMaxPowerPaginateInfo"] = store.state.homeFitWorkoutState.powerMaxPowerPaginateInfo;
        returnObject["powerPlyometricsPaginateInfo"] = store.state.homeFitWorkoutState.powerPlyometricsPaginateInfo;
        returnObject["powerKidsFitPaginateInfo"] = store.state.homeFitWorkoutState.powerKidsFitPaginateInfo;
        
        returnObject["isValidHomeFitSubscription"] = store.state.homeFitWorkoutState.isValidHomeFitSubscription;
        returnObject["filterMovementMeter"] = store.state.homeFitWorkoutState.movementMeterFilter;
        returnObject["filterEquipmentBodyweight"] = store.state.homeFitWorkoutState.equipmentBodyweight;
        returnObject["filterEquipmentDumbbell"] = store.state.homeFitWorkoutState.equipmentDumbbell;
        returnObject["filterEquipmentKettlebell"] = store.state.homeFitWorkoutState.equipmentKettlebell;
        returnObject["filterEquipmentPowerplate"] = store.state.homeFitWorkoutState.equipmentPowerPlate;
        returnObject["filterEquipmentFoamroller"] = store.state.homeFitWorkoutState.equipmentFoamRoller;
        returnObject["filterEquipmentBand"] = store.state.homeFitWorkoutState.equipmentBands;
        returnObject["filterEquipmentBosu"] = store.state.homeFitWorkoutState.equipmentBosu;
        returnObject["filterEquipmentRockblade"] = store.state.homeFitWorkoutState.equipmentRockblade;
        returnObject["filterWorkoutType"] = store.state.homeFitWorkoutState.workoutType;
        returnObject["filterWorkoutDuration"] = store.state.homeFitWorkoutState.workoutDuration;
        returnObject["filterWorkoutFitness"] = store.state.homeFitWorkoutState.workoutFitnessLevel;
        returnObject["filterWorkoutSports"] = store.state.homeFitWorkoutState.workoutSports;
        returnObject["filterFavoriteEnabled"] = store.state.homeFitWorkoutState.favoriteEnabled;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _user = stateObject["user"];
        _powerAccelerationDecelerationWorkouts = stateObject["powerAccelerationDecelerationWorkouts"];        
        _powerSpeedReactionWorkouts = stateObject["powerSpeedReactionWorkouts"];
        _powerMaxPowerWorkouts = stateObject["powerMaxPowerWorkouts"];
        _powerPlyometricsWorkouts = stateObject["powerPlyometricsWorkouts"];
        _powerKidsfitWorkouts = stateObject["powerKidsFitWorkouts"];
        _powerAccelerationDecelerationPaginateInfo = stateObject["powerAccelerationDecelerationPaginateInfo"];        
        _powerSpeedReactionPaginateInfo = stateObject["powerSpeedReactionPaginateInfo"];
        _powerMaxPowerPaginateInfo = stateObject["powerMaxPowerPaginateInfo"];
        _powerPlyometricsPaginateInfo = stateObject["powerPlyometricsPaginateInfo"];
        _powerKidsfitPaginateInfo = stateObject["powerKidsFitPaginateInfo"];

        _filterEquipmentBodyweight = stateObject["filterEquipmentBodyweight"];
        _filterEquipmentDumbbell = stateObject["filterEquipmentDumbbell"];
        _filterEquipmentKettlebell = stateObject["filterEquipmentKettlebell"];
        _filterEquipmentPowerplate = stateObject["filterEquipmentPowerplate"];
        _filterEquipmentFoamroller = stateObject["filterEquipmentFoamroller"];
        _filterEquipmentBand = stateObject["filterEquipmentBand"];
        _filterEquipmentBosu = stateObject["filterEquipmentBosu"];
        _filterEquipmentRockblade = stateObject["filterEquipmentRockblade"];
        _filterWorkoutType = stateObject["filterWorkoutType"];
        _filterWorkoutDuration = stateObject["filterWorkoutDuration"];
        _filterWorkoutFitnessLevel = stateObject["filterWorkoutFitness"];     
        _filterWorkoutSports = stateObject["filterWorkoutSports"];   
        _filterFavoriteEnabled = stateObject["filterFavoriteEnabled"];
        if(_filterFavoriteEnabled == null) {
          _filterFavoriteEnabled = false;
        }
        if( _powerAccelerationDecelerationWorkouts != null &&
            _powerSpeedReactionWorkouts != null &&
            _powerMaxPowerWorkouts != null &&
            _powerPlyometricsWorkouts != null &&
            _powerKidsfitWorkouts != null) {
          if(mobileLayout) {
            return this._drawSmallerDeviceWidget();
          } else {
            return this._drawLargerDeviceWidget();
          }                  
        } else {
          return new Container();
        } 
      } 
    );
  }
}
