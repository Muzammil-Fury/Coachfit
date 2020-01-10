import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/workout/workout_network.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/workout/views/workout_template_setup.dart';
import 'package:gomotive/dhf/views/dhf_movement_meter.dart';
import 'package:gomotive/workout/views/workout_template_filter.dart';
import 'package:gomotive/core/app_config.dart';

class WorkoutTemplateList extends StatelessWidget {
  final int clientId;
  final int engagementId;
  final Map searchParams;
  final String usageType;
  final String dhfMovementMeterType;
  
  WorkoutTemplateList({
    this.clientId,
    this.engagementId,
    this.searchParams,
    this.usageType,
    this.dhfMovementMeterType,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _WorkoutTemplateList(
          clientId: this.clientId,
          engagementId: this.engagementId,
          searchParams: this.searchParams,
          usageType: this.usageType,
          dhfMovementMeterType: this.dhfMovementMeterType,
        ),
      ),
    );
  }
}

class _WorkoutTemplateList extends StatefulWidget {
  final Map searchParams;
  final int clientId;
  final int engagementId;
  final String usageType;
  final String dhfMovementMeterType;
  
  _WorkoutTemplateList({
    this.clientId,
    this.engagementId,
    this.searchParams,
    this.usageType,
    this.dhfMovementMeterType,
  });

  @override
  _WorkoutTemplateListState createState() => new _WorkoutTemplateListState();
}

class _WorkoutTemplateListState extends State<_WorkoutTemplateList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  TextEditingController _searchController = new TextEditingController();

  var _getWorkoutTemplateListAPI, 
      _togglePublishWorkoutTemplateAPI, 
      _createWorkoutFromWorkoutTemplateAPI,
      _clearWorkoutTemplateListActionCreator;       

  List<Map> _workoutTemplateList;
  Map _paginateInfo;
  Map _searchParams;
  
  ScrollController _controller;

  _fetchWorkoutTemplates(int pageNumber) {
    Map _params = new Map();    
    if(widget.searchParams != null) {
      _params = {}..addAll(widget.searchParams);
    } 
    _params["page"] = pageNumber;
    _params["first"] = false;
    if(_searchController.text != null) {
      _params["search"] = _searchController.text;
    }
    _getWorkoutTemplateListAPI(context, _params);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _fetchWorkoutTemplates(_paginateInfo["page"] + 1,);
        }
    }
  }

  Widget _buildWorkoutTemplateRow(Map _workoutTemplate, int selectedIndex) {    
    final slideMenuKey = new GlobalKey<SlideMenuState>();
    return new SlideMenu(
      key: slideMenuKey,
      child: new ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        title: new Container( 
          height: 80,                 
          // margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),                        
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
                  _workoutTemplate["image_url"] != null 
                  ? new Container(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      width: MediaQuery.of(context).size.width*0.2,
                      height: 60,
                      child: new Thumbnail(                                    
                        url: _workoutTemplate["image_url"],
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
                          _workoutTemplate["name"],
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
                                  _workoutTemplate["practice"]["name"],
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white
                                  )
                                )
                              ),
                              _workoutTemplate["is_favorite"] 
                                ? new Container(                                  
                                    child: new Icon(
                                      Icons.star,
                                      color: Colors.green,
                                      size: 16.0,
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
      
      menuItems: widget.clientId != null
        ? <Widget>[        
            new GestureDetector(
              onTap: () { 
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new WorkoutTemplateSetup(
                      workoutTemplateId: _workoutTemplate["id"],
                    ),
                  ),
                );
              },
              child: new Container(
                color:Colors.yellowAccent,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Icon(
                      Icons.info,
                      color: Colors.black87
                    ),                
                    new Text(
                      "INFO",
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
                Map params = new Map();
                params["id"] = _workoutTemplate["id"];
                params["selectedIndex"] = selectedIndex;
                _togglePublishWorkoutTemplateAPI(context, params);       
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
                Map params = new Map();
                params["client_id"] = widget.clientId;
                params["engagement_id"] = widget.engagementId;
                params["program_id"] = _workoutTemplate["id"];
                _createWorkoutFromWorkoutTemplateAPI(context, params);    
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
            new GestureDetector(
              onTap: () { 
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new WorkoutTemplateSetup(
                      workoutTemplateId: _workoutTemplate["id"],
                    ),
                  ),
                );
              },
              child: new Container(
                color:Colors.yellowAccent,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Icon(
                      Icons.info,
                      color: Colors.black87
                    ),                
                    new Text(
                      "INFO",
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
                Map params = new Map();
                params["id"] = _workoutTemplate["id"];
                params["selectedIndex"] = selectedIndex;
                _togglePublishWorkoutTemplateAPI(context, params);       
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
          ] 
    );    
  }

    @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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
        _getWorkoutTemplateListAPI = stateObject["getWorkoutTemplateList"]; 
        _togglePublishWorkoutTemplateAPI = stateObject["togglePublishWorkoutTemplate"];   
        _createWorkoutFromWorkoutTemplateAPI = stateObject["createWorkoutFromWorkoutTemplate"];    
        _clearWorkoutTemplateListActionCreator = stateObject["clearWorkoutTemplateListActionCreator"];
        _fetchWorkoutTemplates(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getWorkoutTemplateList"] = (BuildContext context, Map params) =>
            store.dispatch(getWorkoutTemplateList(context, params));
        returnObject["togglePublishWorkoutTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(toggleFavoriteWorkoutTemplate(context, params));            
        returnObject["createWorkoutFromWorkoutTemplate"] = (BuildContext context, Map params) =>
            store.dispatch(createWorkoutFromWorkoutTemplate(context, params));                        
        returnObject["clearWorkoutTemplateListActionCreator"] = () =>
            store.dispatch(WorkoutTemplateListClearActionCreator());
        returnObject["workoutTemplateList"] = store.state.workoutState.workoutTemplateList;
        returnObject["paginateInfo"] = store.state.workoutState.workoutTemplatePaginateInfo;
        returnObject["searchParams"] = store.state.workoutState.workoutTemplateSearchParams;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _workoutTemplateList = stateObject["workoutTemplateList"];        
        _paginateInfo = stateObject["paginateInfo"];
        _searchParams = stateObject["searchParams"];                
        if(_workoutTemplateList != null) {
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
                  this._clearWorkoutTemplateListActionCreator();
                  if(widget.dhfMovementMeterType != null) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new DHFMovementMeter(
                          movementMeterType: widget.dhfMovementMeterType
                        ),
                      ),
                    );                  
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: new Text(
                'Workout Templates',             
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
                          builder: (context) => new WorkoutTemplateFilter(
                            usageType: widget.usageType,
                            clientId: widget.clientId,
                            engagementId: widget.engagementId,
                            searchParams: widget.searchParams,
                            dhfMovementMeterType: widget.dhfMovementMeterType,
                          ),
                        ),
                      );
                    },
                  ),                
                ),                                            
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: _workoutTemplateList.length > 0
                ? new ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _workoutTemplateList.length+1,
                    itemBuilder: (context, i) {
                      if(i == 0) {
                        return new Column(
                          children: <Widget>[
                            new Container(    
                              width: MediaQuery.of(context).size.width,   
                              decoration: BoxDecoration(
                                color: Colors.blueGrey
                              ),                       
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                              child: new Container(                                  
                                child: new Text(
                                  "Left swipe a row for additional features",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(  
                                    color: Colors.white,                                  
                                  ),
                                )
                              ),                              
                            ),
                            new Container(
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    width: MediaQuery.of(context).size.width*.9,
                                    child: new TextField(
                                      controller: _searchController,
                                      decoration: new InputDecoration(
                                        border: new UnderlineInputBorder(                                          
                                          borderSide: const BorderSide(
                                            color: Colors.black12
                                          ),                                          
                                        ),                          
                                        hintText: "Search Workout Templates",
                                        hintStyle: new TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                    width: MediaQuery.of(context).size.width*.1,
                                    child: new GestureDetector(                              
                                      onTap:() {    
                                        _fetchWorkoutTemplates(0);
                                      },
                                      child: new Image.asset(
                                        'assets/images/search.png',
                                        color: Colors.blue,                                
                                      ),
                                    )
                                  )
                                ],
                              )                      
                            )
                          ],
                        );                        
                      } else {
                        return _buildWorkoutTemplateRow(_workoutTemplateList[i-1], i-1);                    
                      }
                    },
                  )
                : new Container(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                    child: new Center(
                      child: new Text(
                        "There are no workout template(s) for the selected filters. Modify your search filter criteria.",
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
