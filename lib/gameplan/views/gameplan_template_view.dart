import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/gameplan/gameplan_network.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_config.dart';

class GameplanTemplateView extends StatelessWidget {
  final int clientId;
  final int engagementId;
  final Map searchParams;
  final String usageType;
  final String dhfMovementMeterType;
  final Map gameplanTemplate;
  
  GameplanTemplateView({
    this.clientId,
    this.engagementId,
    this.searchParams,
    this.usageType,
    this.dhfMovementMeterType,
    this.gameplanTemplate
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _GameplanTemplateView(
          clientId: this.clientId,
          engagementId: this.engagementId,
          searchParams: this.searchParams,
          usageType: this.usageType,
          dhfMovementMeterType: this.dhfMovementMeterType,
          gameplanTemplate: this.gameplanTemplate,
        ),
      ),
    );
  }
}

class _GameplanTemplateView extends StatefulWidget {
  final Map searchParams;
  final int clientId;
  final int engagementId;
  final String usageType;
  final String dhfMovementMeterType;
  final Map gameplanTemplate;
  
  _GameplanTemplateView({
    this.clientId,
    this.engagementId,
    this.searchParams,
    this.usageType,
    this.dhfMovementMeterType,
    this.gameplanTemplate,
  });

  @override
  _GameplanTemplateViewState createState() => new _GameplanTemplateViewState();
}

class _GameplanTemplateViewState extends State<_GameplanTemplateView> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  
  
  ScrollController controller;

  var _getGameplanTemplateWorkoutListAPI,
      _getGameplanTemplateHabitListAPI,
      _getGameplanTemplateNutritionListAPI,
      _getGameplanTemplateGuidanceListAPI,
      _createEngagementFromTemplateAPI;

  List<Map> _workoutList, _habitList, _nutritionList, _guidanceList; 

  List<Widget> _buildWorkoutRows() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_workoutList.length; i++) {
      Container _container =  new Container( 
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),  
        decoration: new BoxDecoration(                          
          border: new Border(
            bottom: new BorderSide(
              color: Colors.black12
            ),
          ),                              
        ),                
        child: new CheckboxListTile(
          activeColor: Colors.green,
          value: _workoutList[i]["selected_value"],
          onChanged: (bool selected) {
            setState(() {
              _workoutList[i]["selected_value"] = selected;
            });                                
          },
          title: Text(
            _workoutList[i]["name"]
          ),
        ),
      );
      _list.add(_container);
    }
    return _list;
  }

  List<Widget> _buildHabitRows() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_habitList.length; i++) {
      Container _container =  new Container( 
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),  
        decoration: new BoxDecoration(                          
          border: new Border(
            bottom: new BorderSide(
              color: Colors.black12
            ),
          ),                              
        ),                
        child: new CheckboxListTile(
          activeColor: Colors.green,
          value: _habitList[i]["selected_value"],
          onChanged: (bool selected) {
            setState(() {
              _habitList[i]["selected_value"] = selected;
            });                                
          },
          title: Text(
            _habitList[i]["name"]
          ),
        ),
      );
      _list.add(_container);
    }
    return _list;
  } 

  List<Widget> _buildNutritionDocumentRows() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_nutritionList.length; i++) {
      Container _container =  new Container( 
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),  
        decoration: new BoxDecoration(                          
          border: new Border(
            bottom: new BorderSide(
              color: Colors.black12
            ),
          ),                              
        ),                
        child: new CheckboxListTile(
          activeColor: Colors.green,
          value: _nutritionList[i]["selected_value"],
          onChanged: (bool selected) {
            setState(() {
              _nutritionList[i]["selected_value"] = selected;
            });                                
          },
          title: Text(
            _nutritionList[i]["name"]
          ),
        ),
      );
      _list.add(_container);
    }
    return _list;
  } 

  List<Widget> _buildGuidanceDocumentRows() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_guidanceList.length; i++) {
      Container _container =  new Container( 
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),  
        decoration: new BoxDecoration(                          
          border: new Border(
            bottom: new BorderSide(
              color: Colors.black12
            ),
          ),                              
        ),                
        child: new CheckboxListTile(
          activeColor: Colors.green,
          value: _guidanceList[i]["selected_value"],
          onChanged: (bool selected) {
            setState(() {
              _guidanceList[i]["selected_value"] = selected;
            });                                
          },
          title: Text(
            _guidanceList[i]["name"]
          ),
        ),
      );
      _list.add(_container);
    }
    return _list;
  } 


  @override
  void initState() {
    super.initState();
  }

  
  @override
  void deactivate() { 
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getGameplanTemplateWorkoutListAPI = stateObject["getGameplanTemplateWorkoutList"];
        _getGameplanTemplateHabitListAPI = stateObject["getGameplanTemplateHabitList"];         
        _getGameplanTemplateNutritionListAPI = stateObject["getGameplanTemplateNutritionList"];
        _getGameplanTemplateGuidanceListAPI = stateObject["getGameplanTemplateGuidanceList"];
        _createEngagementFromTemplateAPI = stateObject["createEngagementFromTemplate"];
        Map params = new Map();
        params["treatment_template_id"] = widget.gameplanTemplate["id"];
        _getGameplanTemplateWorkoutListAPI(context, params);
        params["id"] = widget.gameplanTemplate["id"];
        _getGameplanTemplateHabitListAPI(context, params);
        params["document_type"] = 1;
        _getGameplanTemplateNutritionListAPI(context, params);
        params["document_type"] = 2;
        _getGameplanTemplateGuidanceListAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getGameplanTemplateWorkoutList"] = (BuildContext context, Map params) =>
            store.dispatch(getGameplanTemplateWorkoutList(context, params));        
        returnObject["getGameplanTemplateHabitList"] = (BuildContext context, Map params) =>
            store.dispatch(getGameplanTemplateHabitList(context, params));        
        returnObject["getGameplanTemplateNutritionList"] = (BuildContext context, Map params) =>
            store.dispatch(getGameplanTemplateNutritionList(context, params));        
        returnObject["getGameplanTemplateGuidanceList"] = (BuildContext context, Map params) =>
            store.dispatch(getGameplanTemplateGuidanceList(context, params));
        returnObject["createEngagementFromTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(createEngagementFromTemplate(context, params));                
        returnObject["workoutList"] = store.state.gameplanState.gameplanTemplateWorkoutList;
        returnObject["habitList"] = store.state.gameplanState.gameplanTemplateHabitList;
        returnObject["nutritionList"] = store.state.gameplanState.gameplanTemplateNutritionDocumentList;
        returnObject["guidanceList"] = store.state.gameplanState.gameplanTemplateGuidanceDocumentList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workoutList = stateObject["workoutList"];    
        _habitList = stateObject["habitList"];
        _nutritionList = stateObject["nutritionList"];
        _guidanceList = stateObject["guidanceList"];
        if(_workoutList != null && _habitList != null && _nutritionList != null && _guidanceList != null) {                 
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
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                widget.gameplanTemplate["name"],             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[                
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
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: new Column(
                        children: <Widget>[
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Container(                                  
                              child: new Text(
                                "Select Workouts",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          _workoutList.length > 0
                          ? new Column(
                              children: _buildWorkoutRows()
                            )
                          : new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "No workouts are available",
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Container(                                  
                              child: new Text(
                                "Select Habits",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          _habitList.length > 0
                          ? new Column(
                              children: _buildHabitRows()
                            )
                          : new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "No habits are available",
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Container(                                  
                              child: new Text(
                                "Select Nutrition Documents",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          _nutritionList.length > 0
                          ? new Column(
                              children: _buildNutritionDocumentRows()
                            )
                          : new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "No nutrition documents are available",
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Container(                                  
                              child: new Text(
                                "Select Guidance Documents",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          _guidanceList.length > 0
                          ? new Column(
                              children: _buildGuidanceDocumentRows()
                            )
                          : new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "No guidance documents are available",
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 24.0, 
                              horizontal: 24.0
                            ),
                            child: new FlatButton(
                              color: primaryColor,                                
                              child: new Text(
                                'CREATE',
                                style: TextStyle(
                                  color: primaryTextColor
                                )
                              ),
                              onPressed: () {
                                String dateString = Utils.convertDateToValueString(new DateTime.now());
                                List<Map> _selectedWorkouts = new List<Map>();
                                for(int i=0; i<_workoutList.length; i++) {
                                  if(_workoutList[i]["selected_value"]) {
                                    _workoutList[i]["start_date"] = dateString;
                                    _selectedWorkouts.add(_workoutList[i]);
                                  }
                                }
                                List<Map> _selectedHabits = new List<Map>();
                                for(int i=0; i<_habitList.length; i++) {
                                  if(_habitList[i]["selected_value"]) {
                                    _habitList[i]["start_date"] = dateString;
                                    _selectedHabits.add(_habitList[i]);
                                  }
                                }
                                List<Map> _selectedNutrition = new List<Map>();
                                for(int i=0; i<_nutritionList.length; i++) {
                                  if(_nutritionList[i]["selected_value"]) {
                                    _selectedNutrition.add(_nutritionList[i]);
                                  }
                                }
                                List<Map> _selectedGuidance = new List<Map>();
                                for(int i=0; i<_guidanceList.length; i++) {
                                  if(_guidanceList[i]["selected_value"]) {
                                    _selectedGuidance.add(_guidanceList[i]);
                                  }
                                }
                                Map _params = new Map();
                                _params["treatment_template_id"] = widget.gameplanTemplate["id"];
                                _params["client_id"] = widget.clientId;
                                _params["engagement_id"] = widget.engagementId;
                                _params["workouts"] = _selectedWorkouts;
                                _params["habits"] = _selectedHabits;
                                _params["nutrition"] = _selectedNutrition;
                                _params["guidance"] = _selectedGuidance;
                                this._createEngagementFromTemplateAPI(context, _params);
                              },
                            ),
                          ),
                        ],
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
