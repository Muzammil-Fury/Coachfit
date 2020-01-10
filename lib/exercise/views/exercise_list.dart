import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/exercise/exercise_network.dart';
import 'package:gomotive/exercise/exercise_actions.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/exercise/views/exercise_info.dart';
import 'package:gomotive/exercise/views/exercise_filter.dart';
import 'package:gomotive/dhf/views/dhf_movement_meter.dart';
import 'package:gomotive/core/app_config.dart';

class ExerciseList extends StatelessWidget {
  final Map exerciseSearchParams;
  final String usageType;
  final int clientId;
  final int engagementId;
  final String dhfMovementMeterType;

  ExerciseList({
    this.exerciseSearchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
    this.dhfMovementMeterType
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ExerciseList(
          exerciseSearchParams: this.exerciseSearchParams,
          usageType: this.usageType,
          clientId: this.clientId,
          engagementId: this.engagementId,
          dhfMovementMeterType: this.dhfMovementMeterType,
        ),
      ),
    );
  }
}

class _ExerciseList extends StatefulWidget {
  final Map exerciseSearchParams;
  final String usageType;
  final int clientId;
  final int engagementId;
  final String dhfMovementMeterType;

  _ExerciseList({
    this.exerciseSearchParams,
    this.usageType,
    this.clientId,
    this.engagementId,
    this.dhfMovementMeterType
  });

  @override
  _ExerciseListState createState() => new _ExerciseListState();
}

class _ExerciseListState extends State<_ExerciseList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  var _getExerciseListAPI, 
      _toggleFavoriteExerciseAPI, 
      _addToWorkoutCartActionCreator, 
      _removeToWorkoutCartActionCreator, 
      _clearWorkoutCartActionCreator, 
      _addExercisesToWorkoutProgression,
      _clearExerciseListActionCreator,
      _createWorkoutFromExercisesAPI;

  List<Map> _exerciseList;
  Map _paginateInfo;
  Map _searchParams;
  List<int> _workoutExercisesIdList;
  List<Map> _workoutExercises;

  ScrollController _controller;

  _fetchExercises(int pageNumber, bool firstPage) {
    Map _params;
    if(firstPage){
      if(widget.exerciseSearchParams != null) {
        _params = {}..addAll(widget.exerciseSearchParams);
      } else {   
        _params = new Map();
      }
    } else {
      _params = {}..addAll(_searchParams);
      if(widget.exerciseSearchParams != null) {
        _params = {}..addAll(widget.exerciseSearchParams);
      } 
    }     
    _params["page"] = pageNumber;
    // _params["search"] = "";
    _getExerciseListAPI(context, _params);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _fetchExercises(_paginateInfo["page"] + 1, false);
        }
    }
  }

  Widget _buildExerciseRow(Map _exercise, int selectedIndex) {    
    final slideMenuKey = new GlobalKey<SlideMenuState>();
    return new SlideMenu(
      key: slideMenuKey,
      child: new ListTile(
        onTap:  () {_openInfo(context, _exercise);},
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        title: new Container( 
          height: 80,                                         
          decoration: new BoxDecoration(                          
            border: new Border(
              bottom: new BorderSide(
                color: Colors.black12
              ),
            ),                              
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ 
              new Row(
                children: <Widget>[
                  _exercise["exercise_thumbnail_url_small"] != null 
                  ? new Container(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      width: MediaQuery.of(context).size.width*0.2,
                      height: 60,
                      child: new Thumbnail(                                    
                        url: _exercise["exercise_thumbnail_url_small"],
                      )
                    )
                  : new Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    height: 60,
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                    width: MediaQuery.of(context).size.width*0.8,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          _exercise["name"],
                          maxLines: 2,
                        ),
                        new Container(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                color: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                                child: new Text(
                                  _exercise["practice"]["name"],
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white
                                  )
                                )
                              ),
                              _exercise["is_favorite"] 
                                ? new Container(                                  
                                    child: new Icon(
                                      Icons.star,
                                      color: Colors.green,
                                      size: 16.0,
                                    )                        
                                  )                      
                                : new Container(),
                              widget.usageType == "from_workout"
                              ? new Container( 
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),                               
                                  child: new Icon(
                                    GomotiveIcons.select,
                                    color: _workoutExercisesIdList != null && _workoutExercisesIdList.contains(_exercise["id"]) ? Colors.green : Colors.black12,
                                    size: 12.0,
                                  )                        
                                )
                              : new Container(),          
                            ],
                          )
                        )                                        
                      ],
                    )                                   
                  ),                                
                ],
              )                                                                                                                              
            ]                            
          )
        )                        
      ),      
      
      menuItems: 
      widget.clientId != null
      ?  <Widget>[
          // new GestureDetector(
          //   onTap: () { 
          //     Navigator.push(
          //       context,
          //       new MaterialPageRoute(
          //         builder: (context) => new ExerciseInfo(
          //           exercise: _exercise,                  
          //         ),
          //       ),
          //     );           
          //   },
          //   child: new Container(
          //     color:Colors.yellowAccent,
          //     child: new Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         new Icon(
          //           Icons.info,
          //           color: Colors.black87
          //         ),                
          //         new Text(
          //           "INFO",
          //           style: TextStyle(
          //             color: Colors.black87,
          //             fontSize: 10.0,
          //             fontWeight: FontWeight.w500
          //           )
          //         )              
          //       ]
          //     )
          //   ),
          // ),
          new GestureDetector(
            onTap: () {
              Map params = new Map();
              params["id"] = _exercise["id"];
              params["selectedIndex"] = selectedIndex;
              _toggleFavoriteExerciseAPI(context, params);            
            },
            child: new Container(
              color:Colors.lightGreenAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.star,
                    color: Colors.black87
                  ),                
                  new Text(
                    "FAVORITES",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500
                    )
                  )                
                ]
              )
            ),
          ),        
          new GestureDetector( 
            onTap: () {
              if(_workoutExercisesIdList != null && _workoutExercisesIdList.contains(_exercise["id"])) {
                _removeToWorkoutCartActionCreator(_exercise);           
              } else {
                _exercise["usage_type"] = widget.usageType;
                _addToWorkoutCartActionCreator(_exercise);           
              }
            },
            child: new Container(
              color:Colors.lightBlueAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    GomotiveIcons.workouts,
                    color: Colors.black87
                  ),                
                  new Text(
                    "WORKOUT",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500
                    )
                  )              
                ]
              )
            ),
          )
        ]
      : <Widget>[
        // new GestureDetector(
        //   onTap: () {_openInfo(context, _exercise);},
        //   child: new Container(
        //     color:Colors.yellowAccent,
        //     child: new Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         new Icon(
        //           Icons.info,
        //           color: Colors.black87
        //         ),                
        //         new Text(
        //           "INFO1",
        //           style: TextStyle(
        //             color: Colors.black87,
        //             fontSize: 10.0,
        //             fontWeight: FontWeight.w500
        //           )
        //         )              
        //       ]
        //     )
        //   ),
        // ),
        new GestureDetector(
          onTap: () {
            Map params = new Map();
            params["id"] = _exercise["id"];
            params["selectedIndex"] = selectedIndex;
            _toggleFavoriteExerciseAPI(context, params);            
          },
          child: new Container(
            color:Colors.lightGreenAccent,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Icon(
                  Icons.star,
                  color: Colors.black87
                ),                
                new Text(
                  "FAVORITES",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500
                  )
                )                
              ]
            )
          ),
        ),
      ],
    );    
  }

  void _openInfo(context, _exercise) {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ExerciseInfo(
          exercise: _exercise,                  
        ),
      ),
    );
  }

    @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getExerciseListAPI = stateObject["getExerciseList"];
        _toggleFavoriteExerciseAPI = stateObject["toggleFavoriteExercise"];
        _addToWorkoutCartActionCreator = stateObject["addToWorkoutCart"];
        _removeToWorkoutCartActionCreator = stateObject["removeFromWorkoutCart"];
        _clearWorkoutCartActionCreator = stateObject["clearWorkoutCart"];
        _addExercisesToWorkoutProgression = stateObject["addExercisesToWorkoutProgression"];
        _clearExerciseListActionCreator = stateObject["clearExerciseList"];
        _createWorkoutFromExercisesAPI = stateObject["createWorkoutFromExercises"];
        _fetchExercises(0, true);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getExerciseList"] = (BuildContext context, Map params) =>
            store.dispatch(getExerciseList(context, params));
        returnObject["clearExerciseList"] = () =>
            store.dispatch(ClearExerciseListActionCreator());            
        returnObject["toggleFavoriteExercise"] = (BuildContext context, Map params) =>
            store.dispatch(toggleFavoriteExercise(context, params));
        returnObject["addToWorkoutCart"] = (Map exercise) =>
            store.dispatch(AddToWorkoutCartActionCreator(exercise));
        returnObject["removeFromWorkoutCart"] = (Map exercise) =>
            store.dispatch(RemoveFromWorkoutCartActionCreator(exercise));
        returnObject["clearWorkoutCart"] = () =>
            store.dispatch(ClearWorkoutCartActionCreator());
        returnObject["addExercisesToWorkoutProgression"] = (List<Map> exercises) =>
            store.dispatch(AddExercisesToWorkoutProgressionActionCreator(exercises));
        returnObject["createWorkoutFromExercises"] = (BuildContext context, Map params) =>
            store.dispatch(createWorkoutFromExercises(context, params));
        returnObject["exerciseList"] = store.state.exerciseState.exerciseList;
        returnObject["paginateInfo"] = store.state.exerciseState.paginateInfo;        
        returnObject["searchParams"] = store.state.exerciseState.searchParams;
        returnObject["workoutExerciseIdList"] = store.state.exerciseState.workoutExerciseIdList;        
        returnObject["workoutExercises"] = store.state.exerciseState.workoutExercises;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _exerciseList = stateObject["exerciseList"];        
        _paginateInfo = stateObject["paginateInfo"];
        _searchParams = stateObject["searchParams"];
        _workoutExercises = stateObject["workoutExercises"];
        _workoutExercisesIdList = stateObject["workoutExerciseIdList"];
        if(_exerciseList != null) {
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: primaryColor,
                ),
                onPressed: () {
                  this._clearExerciseListActionCreator();
                  if(widget.usageType == "gi_3dmaps_view_library") {
                    Navigator.of(context).pushNamed("/gi/3dmaps");
                  } else if(widget.usageType == "gi_golf_view_library") {
                    Navigator.of(context).pushNamed("/gi/golf");
                  } else if(widget.usageType == "generic_view_library") {
                    Navigator.of(context).pushNamed("/practitioner/exercises");
                  } else if(widget.usageType == "from_workout") {
                    Navigator.of(context).pop();
                  } else if(widget.usageType == "to_workout") {
                    Navigator.of(context).pop();
                  } else if(widget.usageType == "dhf_exercise_library") {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new DHFMovementMeter(
                          movementMeterType: widget.dhfMovementMeterType
                        ),
                      ),
                    );
                  }                  
                },
              ),
              title: new Text(
                'Exercises',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(
                      GomotiveIcons.filter,
                      color: primaryColor,
                    ),
                    onPressed: () {   
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new ExerciseFilter(
                            usageType: widget.usageType,
                            clientId: widget.clientId,
                            engagementId: widget.engagementId,
                            exerciseSearchParams: widget.exerciseSearchParams,
                          ),
                        ),
                      );                      
                    },
                  ),                
                ),              
                widget.usageType != "gi_3dmaps_view_library"  && widget.usageType != "gi_golf_view_library" && widget.usageType != "generic_view_library"
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                    child: new Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 36,
                            color: primaryColor
                          ),
                          onPressed: () {
                            if(widget.usageType == "from_workout") {
                              if(_workoutExercises.length > 0) {
                                this._addExercisesToWorkoutProgression(_workoutExercises);
                                this._clearWorkoutCartActionCreator();
                                Navigator.of(context).pop();
                              } else {
                                CustomDialog.alertDialog(context, "Exercise not selected", "Kindly add exercises to cart before creating the workout");
                              }
                            } else if(widget.usageType == "to_workout") {
                              if(_workoutExercises.length > 0) {
                                Map params = new Map();
                                params["client_id"] = widget.clientId;
                                params["engagement_id"] = widget.engagementId;
                                params["name"] = "Workout";
                                params["description"] = "Workout Description";
                                params["schedule_type"] = 2;
                                params["total_days"] = 7;
                                params["start_date"] = Utils.convertDateToValueString(DateTime.now());
                                params["per_day"] = 1;
                                params["per_week"] = 7;
                                params["progression_name"] = "Phase 1";
                                params["progression_description"] = "Phase 1 Description";
                                params["progression_duration"] = 60;                              
                                params["progression_exercises"] = _workoutExercises;
                                this._createWorkoutFromExercisesAPI(context, params);
                                this._clearWorkoutCartActionCreator();                                
                              } else {
                                CustomDialog.alertDialog(context, "Exercise not selected", "Kindly add exercises to cart before creating the workout");
                              }
                            }                                                   
                          },
                        ),
                        new Positioned(
                          child: new Stack(
                            children: <Widget>[
                              new Icon(
                                Icons.brightness_1,
                                size: 30.0, 
                                color: primaryColor                              
                              ),
                              new Positioned(
                                top: 7.0,
                                left: 7.0,
                                child: new Center(                          
                                  child: new Text(
                                    _workoutExercises != null
                                    ? _workoutExercises.length.toString()
                                    : "0",
                                    style: new TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    )                  
                  )
                : new Container(),
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: _exerciseList.length > 0
                ? ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _exerciseList.length+1,
                    itemBuilder: (context, i) {
                      if(i == 0) {
                        String descText;
                        if(widget.usageType == "from_workout") {
                          descText = "Kindly left swipe and click on workout of each exercise that needs to be assigned. Finally click on the cart icon in top right hand corner to add exercise to workout.";
                        } else if(widget.usageType == "to_workout") {
                          descText = "Kindly left swipe and click on workout of each exercise that needs to be assigned. Finally click on the cart icon in top right hand corner to create a new workout.";
                        } else if(widget.usageType != "gi_3dmaps_view_library" || widget.usageType != "gi_golf_view_library" || widget.usageType != "generic_view_library") {
                          descText = "Left swipe to add to Favorites";
                        }
                        return new Column(
                          children: <Widget>[                            
                            new Container(    
                              width: MediaQuery.of(context).size.width,   
                              decoration: BoxDecoration(
                                color: Colors.blueGrey
                              ),                       
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: new Container(                                  
                                child: new Text(
                                  descText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(  
                                    color: Colors.white,                                  
                                  ),
                                )
                              ),                              
                            ),
                          ],
                        );                        
                      } else {
                        return _buildExerciseRow(_exerciseList[i-1], i-1);                    
                      }
                    }
                  )
                : new Container(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    child: new Center(
                      child: new Text(
                        "There are no exercise(s) for the selected filters. Modify your search filter criteria.",
                        textAlign: TextAlign.center,
                      )
                    )
                  )
              )
            )
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
