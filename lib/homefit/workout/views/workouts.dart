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
import 'package:gomotive/homefit/components/text_tap.dart';

class Workouts extends StatelessWidget {

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
          child: _Workouts(),
        )        
      ),
    );
  }
}

class _Workouts extends StatefulWidget {
  @override
  _WorkoutsState createState() => new _WorkoutsState();
}

class _WorkoutsState extends State<_Workouts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getMobilityWorkouts, _getStrengthWorkouts, _getMetabolicWorkouts, _getPowerWorkouts;
  List<Map> _mobilityWorkouts, _strengthWorkouts, _metabolicWorkouts, _powerWorkouts;
  var _mobilityWorkoutsPaginateInfo, _strengthWorkoutsPaginateInfo, _metabolicWorkoutsPaginateInfo, _powerWorkoutsPaginateInfo;
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

  ScrollController _mobilityController, _strengthController, _metabolicController, _powerController;

  _mobilityScrollListener() {
    if (_mobilityController.offset >= _mobilityController.position.maxScrollExtent && !_mobilityController.position.outOfRange) {
      if(_mobilityWorkoutsPaginateInfo.containsKey("total_pages") && ((_mobilityWorkoutsPaginateInfo["page"]+1) < _mobilityWorkoutsPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_mobilityWorkoutsPaginateInfo["page"] + 1);
        _getMobilityWorkouts(context, params);    
      }
    }
  }

  _strengthScrollListener() {
    if (_strengthController.offset >= _strengthController.position.maxScrollExtent && !_strengthController.position.outOfRange) {
      if(_strengthWorkoutsPaginateInfo.containsKey("total_pages") && ((_strengthWorkoutsPaginateInfo["page"]+1) < _strengthWorkoutsPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_strengthWorkoutsPaginateInfo["page"] + 1);
        _getStrengthWorkouts(context, params);    
      }
    }
  }

  _metabolicScrollListener() {
    if (_metabolicController.offset >= _metabolicController.position.maxScrollExtent && !_metabolicController.position.outOfRange) {
      if(_metabolicWorkoutsPaginateInfo.containsKey("total_pages") && ((_metabolicWorkoutsPaginateInfo["page"]+1) < _metabolicWorkoutsPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_metabolicWorkoutsPaginateInfo["page"] + 1);
        _getMetabolicWorkouts(context, params);    
      }
    }
  }

  _powerScrollListener() {
    if (_powerController.offset >= _powerController.position.maxScrollExtent && !_powerController.position.outOfRange) {
      if(_powerWorkoutsPaginateInfo.containsKey("total_pages") && ((_powerWorkoutsPaginateInfo["page"]+1) < _powerWorkoutsPaginateInfo["total_pages"])){
        Map params = _getSearchParams(_powerWorkoutsPaginateInfo["page"] + 1);
        _getPowerWorkouts(context, params);    
      }
    }
  }

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

  _fetchWorkouts(int pageNumber) {
    Map params = _getSearchParams(pageNumber);
    _getMobilityWorkouts(context, params);    
    _getStrengthWorkouts(context, params);
    _getMetabolicWorkouts(context, params);
    _getPowerWorkouts(context, params);
  }

  @override
  void initState() {
    _mobilityController = ScrollController();
    _mobilityController.addListener(_mobilityScrollListener);   
    _strengthController = ScrollController();
    _strengthController.addListener(_strengthScrollListener); 
    _metabolicController = ScrollController();
    _metabolicController.addListener(_metabolicScrollListener); 
    _powerController = ScrollController();
    _powerController.addListener(_powerScrollListener); 
    super.initState();
  }

  List<Widget> _listWorkouts() {
    double width = 300;
    double height = 200;

    List<Widget> list = new List();
    Container _mobilityHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Mobility Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              )
            )
          ),
          _mobilityWorkouts.length > 0
          ? new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: new TextTap(
                "View All", 
                "route",
                "/workouts/mobility",
                textColor: Colors.green
              ),
            )
          : new Container(),
        ],                              
      )
    );      
    list.add(_mobilityHeaderContainer);  

    if(_mobilityWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _mobilityWorkouts.length,
          controller: _mobilityController,
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
                      WorkoutPreview(workoutId: _mobilityWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _mobilityWorkouts[i], _user, width, height)
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


    Container _strengthHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Strength Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              )
            )
          ),
          _strengthWorkouts.length > 0
          ? new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: new TextTap(
                "View All", 
                "route",
                "/workouts/strength",
                textColor: Colors.green
              ),
            )
          : new Container(),
        ],                              
      )
    );      
    list.add(_strengthHeaderContainer);  

    if(_strengthWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _strengthWorkouts.length,
          controller: _strengthController,
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
                      WorkoutPreview(workoutId: _strengthWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _strengthWorkouts[i], _user, width, height)
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
    

    
    Container _metabolicHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Metabolic Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              )
            )
          ),
          _metabolicWorkouts.length > 0
          ? new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: new TextTap(
                "View All", 
                "route",
                "/workouts/metabolic",
                textColor: Colors.green
              ),
            )
          : new Container()
        ],                              
      )
    );      
    list.add(_metabolicHeaderContainer);  

    if(_metabolicWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _metabolicWorkouts.length,
          controller: _metabolicController,
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
                      WorkoutPreview(workoutId: _metabolicWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _metabolicWorkouts[i], _user, width, height)
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
    

    Container _powerHeaderContainer = new Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
            child: new Text(
              'Power Workouts',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              )
            )
          ),
          _powerWorkouts.length > 0
          ? new Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: new TextTap(
                "View All", 
                "route",
                "/workouts/power",
                textColor: Colors.green
              ),
            )
          : new Container(),
        ],                              
      )
    );      
    list.add(_powerHeaderContainer);  

    if(_powerWorkouts.length > 0) {
      Container _workoutContainer = new Container(
        height: 200,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: _powerWorkouts.length,
          controller: _powerController,
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
                      WorkoutPreview(workoutId: _powerWorkouts[i]["id"])
                    ),
                  );                                                                                                                       
                },
                child: Utils.drawWorkout(context, _powerWorkouts[i], _user, width, height)
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
                          // (token != "" && token != null) ? 
                          //   new Container(
                          //     padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                          //     child: new MaterialButton(
                          //       height: 50.0, 
                          //       minWidth: 120.0,
                          //       color: _filterFavoriteEnabled ? Colors.green : dhfYellow,
                          //       child: new Text(
                          //         'My Favorites',
                          //         textScaleFactor: 1.5,
                          //       ),
                          //       textColor: Colors.black87, 
                          //       onPressed: () {
                          //         setState(() {
                          //           _filterFavoriteEnabled = !_filterFavoriteEnabled;                                      
                          //           _fetchWorkouts(0);
                          //         });                                      
                          //       },
                          //     ),
                          //   )
                          // : new Container(),
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
            'Workouts'
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
    // SystemChrome.setPreferredOrientations(
    //     [
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //       DeviceOrientation.landscapeLeft, 
    //       DeviceOrientation.landscapeRight
    //     ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getMobilityWorkouts = stateObject["getMobilityWorkouts"];
        _getStrengthWorkouts = stateObject["getStrengthWorkouts"];
        _getMetabolicWorkouts = stateObject["getMetabolicWorkouts"];
        _getPowerWorkouts = stateObject["getPowerWorkouts"];
        _fetchWorkouts(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getMobilityWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMobilityWorkouts(context, params));
        returnObject["getStrengthWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getStrengthWorkouts(context, params));
        returnObject["getMetabolicWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getMetabolicWorkouts(context, params));
        returnObject["getPowerWorkouts"] = (BuildContext context, Map params) =>
          store.dispatch(getPowerWorkouts(context, params));
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["mobilityWorkouts"] = store.state.homeFitWorkoutState.mobilityWorkouts;
        returnObject["strengthWorkouts"] = store.state.homeFitWorkoutState.strengthWorkouts;
        returnObject["metabolicWorkouts"] = store.state.homeFitWorkoutState.metabolicWorkouts;
        returnObject["powerWorkouts"] = store.state.homeFitWorkoutState.powerWorkouts;
        returnObject["mobilityWorkoutsPaginateInfo"] = store.state.homeFitWorkoutState.mobilityWorkoutsPaginateInfo;
        returnObject["strengthWorkoutsPaginateInfo"] = store.state.homeFitWorkoutState.strengthWorkoutsPaginateInfo;
        returnObject["metabolicWorkoutsPaginateInfo"] = store.state.homeFitWorkoutState.metabolicWorkoutsPaginateInfo;
        returnObject["powerWorkoutsPaginateInfo"] = store.state.homeFitWorkoutState.powerWorkoutsPaginateInfo;
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
        _mobilityWorkouts = stateObject["mobilityWorkouts"];
        _mobilityWorkoutsPaginateInfo = stateObject["mobilityWorkoutsPaginateInfo"];
        _strengthWorkouts = stateObject["strengthWorkouts"];
        _strengthWorkoutsPaginateInfo = stateObject["strengthWorkoutsPaginateInfo"];
        _metabolicWorkouts = stateObject["metabolicWorkouts"];
        _metabolicWorkoutsPaginateInfo = stateObject["metabolicWorkoutsPaginateInfo"];
        _powerWorkouts = stateObject["powerWorkouts"];
        _powerWorkoutsPaginateInfo = stateObject["powerWorkoutsPaginateInfo"];
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
        if(_mobilityWorkouts != null && _strengthWorkouts != null && _metabolicWorkouts != null && _powerWorkouts != null) {
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
