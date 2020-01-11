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

class WorkoutsMetabolic extends StatelessWidget {

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
          child: _WorkoutsMetabolic(),
        )        
      ),
    );
  }
}

class _WorkoutsMetabolic extends StatefulWidget {
  @override
  _WorkoutsMetabolicState createState() => new _WorkoutsMetabolicState();
}

class _WorkoutsMetabolicState extends State<_WorkoutsMetabolic> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getMetabolicHiitWorkouts, _getMetabolicHiisWorkouts, _getMetabolicSissWorkouts, _getMetabolicKidsfitWorkouts;
  List<Map> _metabolicHIITWorkouts, _metabolicHIISWorkouts, _metabolicSISSWorkouts, _metabolicKidsfitWorkouts;
  Map _metabolicHIITPaginateInfo, _metabolicHIISPaginateInfo, _metabolicSISSPaginateInfo, _metabolicKidsfitPaginateInfo;
  
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

  ScrollController  _metabolicHIITScrollController, 
                    _metabolicHIISScrollController, 
                    _metabolicSISSScrollController, 
                    _metabolicKidsfitScrollController;

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


  _metabolicHIITScrollListener() {
    if (_metabolicHIITScrollController.offset >= _metabolicHIITScrollController.position.maxScrollExtent && !_metabolicHIITScrollController.position.outOfRange) {
      if(_metabolicHIITPaginateInfo.containsKey("total_pages") && ((_metabolicHIITPaginateInfo["page"]+1) < _metabolicHIITPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_metabolicHIITPaginateInfo["page"] + 1);
        _getMetabolicHiitWorkouts(context, params);  
      }
    }
  }

  _metabolicHIISScrollListener() {
    if (_metabolicHIISScrollController.offset >= _metabolicHIISScrollController.position.maxScrollExtent && !_metabolicHIISScrollController.position.outOfRange) {
      if(_metabolicHIISPaginateInfo.containsKey("total_pages") && ((_metabolicHIISPaginateInfo["page"]+1) < _metabolicHIISPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_metabolicHIISPaginateInfo["page"] + 1);
        _getMetabolicHiisWorkouts(context, params);    
      }
    }
  }

  _metabolicSISSScrollListener() {
    if (_metabolicSISSScrollController.offset >= _metabolicSISSScrollController.position.maxScrollExtent && !_metabolicSISSScrollController.position.outOfRange) {
      if(_metabolicSISSPaginateInfo.containsKey("total_pages") && ((_metabolicSISSPaginateInfo["page"]+1) < _metabolicSISSPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_metabolicSISSPaginateInfo["page"] + 1);
        _getMetabolicSissWorkouts(context, params);    
      }
    }
  }

  _metabolicKidsfitScrollListener() {
    if (_metabolicKidsfitScrollController.offset >= _metabolicKidsfitScrollController.position.maxScrollExtent && !_metabolicKidsfitScrollController.position.outOfRange) {
      if(_metabolicKidsfitPaginateInfo.containsKey("total_pages") && ((_metabolicKidsfitPaginateInfo["page"]+1) < _metabolicKidsfitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_metabolicKidsfitPaginateInfo["page"] + 1);
        _getMetabolicKidsfitWorkouts(context, params);    
      }
    }
  }


  _fetchWorkouts(int pageNumber) {
    Map params = _getSearchParams(pageNumber);
    _getMetabolicHiitWorkouts(context, params);    
    _getMetabolicHiisWorkouts(context, params);
    _getMetabolicSissWorkouts(context, params);    
    _getMetabolicKidsfitWorkouts(context, params);
  }

  @override
  void initState() {
    _metabolicHIITScrollController = ScrollController();
    _metabolicHIITScrollController.addListener(_metabolicHIITScrollListener);   
    _metabolicHIISScrollController = ScrollController();
    _metabolicHIISScrollController.addListener(_metabolicHIISScrollListener);   
    _metabolicSISSScrollController = ScrollController();
    _metabolicSISSScrollController.addListener(_metabolicSISSScrollListener);   
    _metabolicKidsfitScrollController = ScrollController();
    _metabolicKidsfitScrollController.addListener(_metabolicKidsfitScrollListener);       
    super.initState();
  }

  List<Widget> _listWorkouts() {
    double width = 300;
    double height = 200;

    List<Widget> list = new List();
    
    Container _hiitHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'HIIT Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_hiitHeaderContainer);  

    if(_metabolicHIITWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _metabolicHIITWorkouts.length,
          controller: _metabolicHIITScrollController,
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
                      WorkoutPreview(workoutId: _metabolicHIITWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _metabolicHIITWorkouts[i], _user, width, height)
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

    
    Container _hiisHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'HIIS Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_hiisHeaderContainer);  

    if(_metabolicHIISWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _metabolicHIISWorkouts.length,
          controller: _metabolicHIISScrollController,
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
                      WorkoutPreview(workoutId: _metabolicHIISWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _metabolicHIISWorkouts[i], _user, width, height)
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

  
    Container _sissHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'SISS Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_sissHeaderContainer);  

    if(_metabolicSISSWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _metabolicSISSWorkouts.length,
          controller: _metabolicSISSScrollController,
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
                      WorkoutPreview(workoutId: _metabolicSISSWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _metabolicSISSWorkouts[i], _user, width, height)
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

    
    Container _kidsFitHeaderContainer = new Container(
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
    list.add(_kidsFitHeaderContainer);  

    if(_metabolicKidsfitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _metabolicKidsfitWorkouts.length,
          controller: _metabolicKidsfitScrollController,
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
                      WorkoutPreview(workoutId: _metabolicKidsfitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _metabolicKidsfitWorkouts[i], _user, width, height)
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
                    Container(
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
            'Metabolic Workouts'
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
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown
         ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getMetabolicHiitWorkouts = stateObject["getMetabolicHiitWorkouts"];
        _getMetabolicHiisWorkouts = stateObject["getMetabolicHiisWorkouts"];
        _getMetabolicSissWorkouts = stateObject["getMetabolicSissWorkouts"];
        _getMetabolicKidsfitWorkouts = stateObject["getMetabolicKidsfitWorkouts"];        
        _fetchWorkouts(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getMetabolicHiitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMetabolicHiitWorkouts(context, params));
        returnObject["getMetabolicHiisWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMetabolicHiisWorkouts(context, params));
        returnObject["getMetabolicSissWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMetabolicSissWorkouts(context, params));
        returnObject["getMetabolicKidsfitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMetabolicKidsfitWorkouts(context, params));        
        
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["metabolicHIITWorkouts"] = store.state.homeFitWorkoutState.metabolicHIITWorkouts;
        returnObject["metabolicHIISWorkouts"] = store.state.homeFitWorkoutState.metabolicHIISWorkouts;
        returnObject["metabolicSISSWorkouts"] = store.state.homeFitWorkoutState.metabolicSISSWorkouts;
        returnObject["metabolicKidsFitWorkouts"] = store.state.homeFitWorkoutState.metabolicKidsFitWorkouts;
        returnObject["metabolicHIITPaginateInfo"] = store.state.homeFitWorkoutState.metabolicHIITPaginateInfo;
        returnObject["metabolicHIISPaginateInfo"] = store.state.homeFitWorkoutState.metabolicHIISPaginateInfo;
        returnObject["metabolicSISSPaginateInfo"] = store.state.homeFitWorkoutState.metabolicSISSPaginateInfo;
        returnObject["metabolicKidsFitPaginateInfo"] = store.state.homeFitWorkoutState.metabolicKidsFitPaginateInfo;
        
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
        _metabolicHIITWorkouts = stateObject["metabolicHIITWorkouts"];        
        _metabolicHIISWorkouts = stateObject["metabolicHIISWorkouts"];
        _metabolicSISSWorkouts = stateObject["metabolicSISSWorkouts"];
        _metabolicKidsfitWorkouts = stateObject["metabolicKidsFitWorkouts"];
        _metabolicHIITPaginateInfo = stateObject["metabolicHIITPaginateInfo"];        
        _metabolicHIISPaginateInfo = stateObject["metabolicHIISPaginateInfo"];
        _metabolicSISSPaginateInfo = stateObject["metabolicSISSPaginateInfo"];
        _metabolicKidsfitPaginateInfo = stateObject["metabolicKidsFitPaginateInfo"];
        
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
        if(_metabolicHIITWorkouts != null && _metabolicHIISWorkouts != null && _metabolicSISSWorkouts != null && _metabolicKidsfitWorkouts != null) {
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
