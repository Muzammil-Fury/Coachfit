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

class WorkoutsStrength extends StatelessWidget {

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
          child: _WorkoutsStrength(),
        )        
      ),
    );
  }
}

class _WorkoutsStrength extends StatefulWidget {
  @override
  _WorkoutsStrengthState createState() => new _WorkoutsStrengthState();
}

class _WorkoutsStrengthState extends State<_WorkoutsStrength> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getStrengthPushPullWorkouts, _getStrengthLiftingCarryingWorkouts, _getStrengthGrand2StandWorkouts, _getStrengthRotationalStrengthWorkouts, _getStrengthKidsfitWorkouts, _getStrengthWorkfitWorkouts;
  List<Map> _strengthPushPullWorkouts, _strengthLiftingCarryingWorkouts, _strengthGrand2StandWorkouts, _strengthRotationalStrengthWorkouts, _strengthKidsFitWorkouts, _strengthWorkFitWorkouts;
  Map _strengthPushPullPaginateInfo, _strengthLiftingCarryingPaginateInfo, _strengthGrand2StandPaginateInfo, _strengthRotationalStrengthPaginateInfo, _strengthKidsFitPaginateInfo, _strengthWorkFitPaginateInfo;
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

  ScrollController  _strengthPushPullController, 
                    _strengthLiftingCarryingController, 
                    _strengthGrand2StandController, 
                    _strengthRotationalStrengthController, 
                    _strengthKidsFitController, 
                    _strengthWorkFitController;
  
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


  _strengthPushPullScrollListener() {
    if (_strengthPushPullController.offset >= _strengthPushPullController.position.maxScrollExtent && !_strengthPushPullController.position.outOfRange) {
      if(_strengthPushPullPaginateInfo.containsKey("total_pages") && ((_strengthPushPullPaginateInfo["page"]+1) < _strengthPushPullPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthPushPullPaginateInfo["page"] + 1);
        _getStrengthPushPullWorkouts(context, params);  
      }
    }
  }

  _strengthLiftingCarryingScrollListener() {
    if (_strengthLiftingCarryingController.offset >= _strengthLiftingCarryingController.position.maxScrollExtent && !_strengthLiftingCarryingController.position.outOfRange) {
      if(_strengthLiftingCarryingPaginateInfo.containsKey("total_pages") && ((_strengthLiftingCarryingPaginateInfo["page"]+1) < _strengthLiftingCarryingPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthLiftingCarryingPaginateInfo["page"] + 1);
        _getStrengthLiftingCarryingWorkouts(context, params);    
      }
    }
  }

  _strengthGrand2StandScrollListener() {
    if (_strengthGrand2StandController.offset >= _strengthGrand2StandController.position.maxScrollExtent && !_strengthGrand2StandController.position.outOfRange) {
      if(_strengthGrand2StandPaginateInfo.containsKey("total_pages") && ((_strengthGrand2StandPaginateInfo["page"]+1) < _strengthGrand2StandPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthGrand2StandPaginateInfo["page"] + 1);
        _getStrengthGrand2StandWorkouts(context, params);    
      }
    }
  }

  _strengthRotationalStrengthScrollListener() {
    if (_strengthRotationalStrengthController.offset >= _strengthRotationalStrengthController.position.maxScrollExtent && !_strengthRotationalStrengthController.position.outOfRange) {
      if(_strengthRotationalStrengthPaginateInfo.containsKey("total_pages") && ((_strengthRotationalStrengthPaginateInfo["page"]+1) < _strengthRotationalStrengthPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthRotationalStrengthPaginateInfo["page"] + 1);
        _getStrengthRotationalStrengthWorkouts(context, params);    
      }
    }
  }


  _strengthKidsFitScrollListener() {
    if (_strengthKidsFitController.offset >= _strengthKidsFitController.position.maxScrollExtent && !_strengthKidsFitController.position.outOfRange) {
      if(_strengthKidsFitPaginateInfo.containsKey("total_pages") && ((_strengthKidsFitPaginateInfo["page"]+1) < _strengthKidsFitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthKidsFitPaginateInfo["page"] + 1);
        _getStrengthKidsfitWorkouts(context, params);    
      }
    }
  }

  _strengthWorkFitScrollListener() {
    if (_strengthWorkFitController.offset >= _strengthWorkFitController.position.maxScrollExtent && !_strengthWorkFitController.position.outOfRange) {
      if(_strengthWorkFitPaginateInfo.containsKey("total_pages") && ((_strengthWorkFitPaginateInfo["page"]+1) < _strengthWorkFitPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthWorkFitPaginateInfo["page"] + 1);
        _getStrengthWorkfitWorkouts(context, params);    
      }
    }
  }


  _fetchWorkouts(int pageNumber) {
    Map params = _getSearchParams(pageNumber);
    _getStrengthPushPullWorkouts(context, params);    
    _getStrengthLiftingCarryingWorkouts(context, params);
    _getStrengthGrand2StandWorkouts(context, params);
    _getStrengthRotationalStrengthWorkouts(context, params);
    _getStrengthKidsfitWorkouts(context, params);
    _getStrengthWorkfitWorkouts(context, params);
  }

  @override
  void initState() {
    _strengthPushPullController = ScrollController();
    _strengthPushPullController.addListener(_strengthPushPullScrollListener);   
    _strengthLiftingCarryingController = ScrollController();
    _strengthLiftingCarryingController.addListener(_strengthLiftingCarryingScrollListener);   
    _strengthGrand2StandController = ScrollController();
    _strengthGrand2StandController.addListener(_strengthGrand2StandScrollListener);   
    _strengthRotationalStrengthController = ScrollController();
    _strengthRotationalStrengthController.addListener(_strengthRotationalStrengthScrollListener);   
    _strengthKidsFitController = ScrollController();
    _strengthKidsFitController.addListener(_strengthKidsFitScrollListener);   
    _strengthWorkFitController = ScrollController();
    _strengthWorkFitController.addListener(_strengthWorkFitScrollListener);   
    super.initState();
  }

  List<Widget> _listWorkouts() {
    double width = 300;
    double height = 200;

    List<Widget> list = new List();
    Container _pushPullHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Push / Pull Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_pushPullHeaderContainer);  

    if(_strengthPushPullWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthPushPullWorkouts.length,
          controller: _strengthPushPullController,
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
                      WorkoutPreview(workoutId: _strengthPushPullWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthPushPullWorkouts[i], _user, width, height)
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

    
    Container _liftingHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Lifting / Carrying Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_liftingHeaderContainer);  

    if(_strengthLiftingCarryingWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthLiftingCarryingWorkouts.length,
          controller: _strengthLiftingCarryingController,
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
                      WorkoutPreview(workoutId: _strengthLiftingCarryingWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthLiftingCarryingWorkouts[i], _user, width, height)
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

    
    Container _grand2StandHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Grand2Stand Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_grand2StandHeaderContainer);  

    if(_strengthGrand2StandWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthGrand2StandWorkouts.length,
          controller: _strengthGrand2StandController,
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
                      WorkoutPreview(workoutId: _strengthGrand2StandWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthGrand2StandWorkouts[i], _user, width, height)
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


    
    Container _rotationalHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Rotational Strength Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_rotationalHeaderContainer);  

    if(_strengthRotationalStrengthWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthRotationalStrengthWorkouts.length,
          controller: _strengthRotationalStrengthController,
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
                      WorkoutPreview(workoutId: _strengthRotationalStrengthWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthRotationalStrengthWorkouts[i], _user, width, height)
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

    if(_strengthKidsFitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthKidsFitWorkouts.length,
          controller: _strengthKidsFitController,
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
                      WorkoutPreview(workoutId: _strengthKidsFitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthKidsFitWorkouts[i], _user, width, height)
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

    
    Container _workFitHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Strength WorkFit Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18
              )
            )
          ),            
        ],                              
      )
    );      
    list.add(_workFitHeaderContainer);  

    if(_strengthWorkFitWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthWorkFitWorkouts.length,
          controller: _strengthWorkFitController,
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
                      WorkoutPreview(workoutId: _strengthWorkFitWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthWorkFitWorkouts[i], _user, width, height)
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
            'Strength Workouts'
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
    SystemChrome.setPreferredOrientations(
        [
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown,
         DeviceOrientation.landscapeLeft,
         DeviceOrientation.landscapeRight
         ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getStrengthPushPullWorkouts = stateObject["getStrengthPushPullWorkouts"];
        _getStrengthLiftingCarryingWorkouts = stateObject["getStrengthLiftingCarryingWorkouts"];
        _getStrengthGrand2StandWorkouts = stateObject["getStrengthGrand2StandWorkouts"];
        _getStrengthRotationalStrengthWorkouts = stateObject["getStrengthRotationalStrengthWorkouts"];
        _getStrengthKidsfitWorkouts = stateObject["getStrengthKidsfitWorkouts"];
        _getStrengthWorkfitWorkouts = stateObject["getStrengthWorkfitWorkouts"];
        _fetchWorkouts(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getStrengthPushPullWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthPushPullWorkouts(context, params));
        returnObject["getStrengthLiftingCarryingWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthLiftingCarryingWorkouts(context, params));
        returnObject["getStrengthGrand2StandWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthGrand2StandWorkouts(context, params));
        returnObject["getStrengthRotationalStrengthWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthRotationalStrengthWorkouts(context, params));
        returnObject["getStrengthKidsfitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthKidsfitWorkouts(context, params));
        returnObject["getStrengthWorkfitWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthWorkfitWorkouts(context, params));
        
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["strengthPushPullWorkouts"] = store.state.homeFitWorkoutState.strengthPushPullWorkouts;
        returnObject["strengthLiftingCarryingWorkouts"] = store.state.homeFitWorkoutState.strengthLiftingCarryingWorkouts;
        returnObject["strengthGrand2StandWorkouts"] = store.state.homeFitWorkoutState.strengthGrand2StandWorkouts;
        returnObject["strengthRotationalStrengthWorkouts"] = store.state.homeFitWorkoutState.strengthRotationalStrengthWorkouts;
        returnObject["strengthKidsFitWorkouts"] = store.state.homeFitWorkoutState.strengthKidsFitWorkouts;
        returnObject["strengthWorkFitWorkouts"] = store.state.homeFitWorkoutState.strengthWorkFitWorkouts;
        returnObject["strengthPushPullPaginateInfo"] = store.state.homeFitWorkoutState.strengthPushPullPaginateInfo;
        returnObject["strengthLiftingCarryingPaginateInfo"] = store.state.homeFitWorkoutState.strengthLiftingCarryingPaginateInfo;
        returnObject["strengthGrand2StandPaginateInfo"] = store.state.homeFitWorkoutState.strengthGrand2StandPaginateInfo;
        returnObject["strengthRotationalStrengthPaginateInfo"] = store.state.homeFitWorkoutState.strengthRotationalStrengthPaginateInfo;
        returnObject["strengthKidsFitPaginateInfo"] = store.state.homeFitWorkoutState.strengthKidsFitPaginateInfo;
        returnObject["strengthWorkFitPaginateInfo"] = store.state.homeFitWorkoutState.strengthWorkFitPaginateInfo;
        
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
        _strengthPushPullWorkouts = stateObject["strengthPushPullWorkouts"];        
        _strengthLiftingCarryingWorkouts = stateObject["strengthLiftingCarryingWorkouts"];
        _strengthGrand2StandWorkouts = stateObject["strengthGrand2StandWorkouts"];
        _strengthRotationalStrengthWorkouts = stateObject["strengthRotationalStrengthWorkouts"];
        _strengthKidsFitWorkouts = stateObject["strengthKidsFitWorkouts"];
        _strengthWorkFitWorkouts = stateObject["strengthWorkFitWorkouts"];
        _strengthPushPullPaginateInfo = stateObject["strengthPushPullPaginateInfo"];        
        _strengthLiftingCarryingPaginateInfo = stateObject["strengthLiftingCarryingPaginateInfo"];
        _strengthGrand2StandPaginateInfo = stateObject["strengthGrand2StandPaginateInfo"];
        _strengthRotationalStrengthPaginateInfo = stateObject["strengthRotationalStrengthPaginateInfo"];
        _strengthKidsFitPaginateInfo = stateObject["strengthKidsFitPaginateInfo"];
        _strengthWorkFitPaginateInfo = stateObject["strengthWorkFitPaginateInfo"];
        
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
        if( _strengthPushPullWorkouts != null && 
            _strengthLiftingCarryingWorkouts != null && 
            _strengthRotationalStrengthWorkouts != null && 
            _strengthKidsFitWorkouts != null && 
            _strengthWorkFitWorkouts != null) {
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
