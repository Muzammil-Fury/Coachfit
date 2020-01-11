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

class WorkoutsMobility extends StatelessWidget {

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
          child: _WorkoutsMobility(),
        )        
      ),
    );
  }
}

class _WorkoutsMobility extends StatefulWidget {
  @override
  _WorkoutsMobilityState createState() => new _WorkoutsMobilityState();
}

class _WorkoutsMobilityState extends State<_WorkoutsMobility> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getMobilityResilienceWorkouts, _getMobilityFluidityWorkouts, _getMobilityActivationWorkouts, _getMobilityKidsfitWorkouts, _getMobilityWorkfitWorkouts;
  List<Map> _mobilityResilienceWorkouts, _mobilityFluidityWorkouts, _mobilityActivationWorkouts, _mobilityKidsfitWorkouts, _mobilityWorkfitWorkouts;
  Map _mobilityResiliencePaginateInfo, _mobilityFluidityPaginateInfo, _mobilityActivationPaginateInfo, _mobilityKidsFitPaginateInfo, _mobilityWorkFitPaginateInfo;
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

  ScrollController  _mobilityResilienceController, 
                    _mobilityFluidityController, 
                    _mobilityActivationController, 
                    _mobilityKidsFitController,
                    _mobilityWorkFitController;

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


  _mobilityResilenceScrollListener() {
    if (_mobilityResilienceController.offset >= _mobilityResilienceController.position.maxScrollExtent && !_mobilityResilienceController.position.outOfRange) {
      if(_mobilityResiliencePaginateInfo.containsKey("total_pages") && ((_mobilityResiliencePaginateInfo["page"]+1) < _mobilityResiliencePaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityResiliencePaginateInfo["page"] + 1);
        _getMobilityResilienceWorkouts(context, params);  
      }
    }
  }

  _mobilityFluidityScrollListener() {
    if (_mobilityFluidityController.offset >= _mobilityFluidityController.position.maxScrollExtent && !_mobilityFluidityController.position.outOfRange) {
      if(_mobilityFluidityPaginateInfo.containsKey("total_pages") && ((_mobilityFluidityPaginateInfo["page"]+1) < _mobilityFluidityPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityFluidityPaginateInfo["page"] + 1);
        _getMobilityFluidityWorkouts(context, params);    
      }
    }
  }

  _mobilityActivationScrollListener() {
    if (_mobilityActivationController.offset >= _mobilityActivationController.position.maxScrollExtent && !_mobilityActivationController.position.outOfRange) {
      if(_mobilityActivationPaginateInfo.containsKey("total_pages") && ((_mobilityActivationPaginateInfo["page"]+1) < _mobilityActivationPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityActivationPaginateInfo["page"] + 1);
        _getMobilityActivationWorkouts(context, params);    
      }
    }
  }

  _mobilityKidsFitScrollListener() {
    if (_mobilityKidsFitController.offset >= _mobilityKidsFitController.position.maxScrollExtent && !_mobilityKidsFitController.position.outOfRange) {
      if(_mobilityKidsFitPaginateInfo.containsKey("total_pages") && ((_mobilityKidsFitPaginateInfo["page"]+1) < _mobilityKidsFitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityActivationPaginateInfo["page"] + 1);
        _getMobilityKidsfitWorkouts(context, params);    
      }
    }
  }


  _mobilityWorkFitScrollListener() {
    if (_mobilityWorkFitController.offset >= _mobilityWorkFitController.position.maxScrollExtent && !_mobilityWorkFitController.position.outOfRange) {
      if(_mobilityWorkFitPaginateInfo.containsKey("total_pages") && ((_mobilityWorkFitPaginateInfo["page"]+1) < _mobilityWorkFitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityWorkFitPaginateInfo["page"] + 1);
        _getMobilityWorkfitWorkouts(context, params);    
      }
    }
  }


  _fetchWorkouts(int pageNumber) {    
    Map params = _getSearchParams(pageNumber);
    _getMobilityResilienceWorkouts(context, params);    
    _getMobilityFluidityWorkouts(context, params);
    _getMobilityActivationWorkouts(context, params);
    _getMobilityKidsfitWorkouts(context, params);
    _getMobilityWorkfitWorkouts(context, params);
  }

  @override
  void initState() {
    _mobilityResilienceController = ScrollController();
    _mobilityResilienceController.addListener(_mobilityResilenceScrollListener);   
    _mobilityFluidityController = ScrollController();
    _mobilityFluidityController.addListener(_mobilityFluidityScrollListener);   
    _mobilityActivationController = ScrollController();
    _mobilityActivationController.addListener(_mobilityActivationScrollListener);   
    _mobilityKidsFitController = ScrollController();
    _mobilityKidsFitController.addListener(_mobilityKidsFitScrollListener);   
    _mobilityWorkFitController = ScrollController();
    _mobilityWorkFitController.addListener(_mobilityWorkFitScrollListener);   
    super.initState();
  }

  List<Widget> _listWorkouts() {
    double width = 300;
    double height = 200;

    List<Widget> list = new List();
    Container _resilienceHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Resilience Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_resilienceHeaderContainer);  

    if(_mobilityResilienceWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityResilienceWorkouts.length,
          controller: _mobilityResilienceController, 
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
                      WorkoutPreview(workoutId: _mobilityResilienceWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityResilienceWorkouts[i], _user, width, height)
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

    
    Container _fluidityHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Fluidity Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_fluidityHeaderContainer);  

    if(_mobilityFluidityWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityFluidityWorkouts.length,
          controller: _mobilityFluidityController,
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
                      WorkoutPreview(workoutId: _mobilityFluidityWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityFluidityWorkouts[i], _user, width, height)
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

    Container _activationHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Activation Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_activationHeaderContainer);  

    if(_mobilityActivationWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityActivationWorkouts.length,
          controller: _mobilityActivationController,
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
                      WorkoutPreview(workoutId: _mobilityActivationWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityActivationWorkouts[i], _user, width, height)
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

    
    Container _kidsfitHeaderContainer = new Container(
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
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_kidsfitHeaderContainer);  

    if(_mobilityKidsfitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityKidsfitWorkouts.length,
          controller: _mobilityKidsFitController,
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
                      WorkoutPreview(workoutId: _mobilityKidsfitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityKidsfitWorkouts[i], _user, width, height)
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

  
    Container _workfitHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'WorkFit Workouts',              
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_workfitHeaderContainer);  

    if(_mobilityWorkfitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityWorkfitWorkouts.length,
          controller: _mobilityWorkFitController,
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
                      WorkoutPreview(workoutId: _mobilityWorkfitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityWorkfitWorkouts[i], _user, width, height)
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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft
    // ]);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Mobility Workouts'
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
    // SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeLeft,
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.portraitDown,
    //     DeviceOrientation.portraitUp
    //   ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getMobilityResilienceWorkouts = stateObject["getMobilityResilienceWorkouts"];
        _getMobilityFluidityWorkouts = stateObject["getMobilityFluidityWorkouts"];
        _getMobilityActivationWorkouts = stateObject["getMobilityActivationWorkouts"];
        _getMobilityKidsfitWorkouts = stateObject["getMobilityKidsfitWorkouts"];
        _getMobilityWorkfitWorkouts = stateObject["getMobilityWorkfitWorkouts"];
        _fetchWorkouts(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getMobilityResilienceWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityResilienceWorkouts(context, params));
        returnObject["getMobilityFluidityWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityFluidityWorkouts(context, params));
        returnObject["getMobilityActivationWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityActivationWorkouts(context, params));
        returnObject["getMobilityKidsfitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityKidsfitWorkouts(context, params));
        returnObject["getMobilityWorkfitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityWorkfitWorkouts(context, params));
        
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["mobilityResilienceWorkouts"] = store.state.homeFitWorkoutState.mobilityResilienceWorkouts;
        returnObject["mobilityResiliencePaginateInfo"] = store.state.homeFitWorkoutState.mobilityResiliencePaginateInfo;
        returnObject["mobilityFluidityWorkouts"] = store.state.homeFitWorkoutState.mobilityFluidityWorkouts;
        returnObject["mobilityFluidityPaginateInfo"] = store.state.homeFitWorkoutState.mobilityFluidityPaginateInfo;
        returnObject["mobilityActivationWorkouts"] = store.state.homeFitWorkoutState.mobilityActivationWorkouts;
        returnObject["mobilityActivationPaginateInfo"] = store.state.homeFitWorkoutState.mobilityActivationPaginateInfo;
        returnObject["mobilityKidsFitWorkouts"] = store.state.homeFitWorkoutState.mobilityKidsFitWorkouts;
        returnObject["mobilityKidsFitPaginateInfo"] = store.state.homeFitWorkoutState.mobilityKidsFitPaginateInfo;
        returnObject["mobilityWorkFitWorkouts"] = store.state.homeFitWorkoutState.mobilityWorkFitWorkouts;
        returnObject["mobilityWorkFitPaginateInfo"] = store.state.homeFitWorkoutState.mobilityWorkFitPaginateInfo;
        
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
        _mobilityResilienceWorkouts = stateObject["mobilityResilienceWorkouts"];
        _mobilityResiliencePaginateInfo = stateObject["mobilityResiliencePaginateInfo"];
        _mobilityFluidityWorkouts = stateObject["mobilityFluidityWorkouts"];
        _mobilityFluidityPaginateInfo = stateObject["mobilityFluidityPaginateInfo"];
        _mobilityActivationWorkouts = stateObject["mobilityActivationWorkouts"];
        _mobilityActivationPaginateInfo = stateObject["mobilityActivationPaginateInfo"];
        _mobilityKidsfitWorkouts = stateObject["mobilityKidsFitWorkouts"];
        _mobilityKidsFitPaginateInfo = stateObject["mobilityKidsFitPaginateInfo"];
        _mobilityWorkfitWorkouts = stateObject["mobilityWorkFitWorkouts"];
        _mobilityWorkFitPaginateInfo = stateObject["mobilityWorkFitPaginateInfo"];
        
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
        if(_mobilityResilienceWorkouts != null &&
          _mobilityFluidityWorkouts != null &&
          _mobilityActivationWorkouts != null &&
          _mobilityKidsfitWorkouts != null &&
          _mobilityWorkfitWorkouts != null) {
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
