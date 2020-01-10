import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/exercise/views/exercise_list.dart';
import 'package:gomotive/gi/views/gi_3dmaps_assessment.dart';
import 'package:gomotive/workout/views/workout_template_list.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/dhf/views/dhf_movement_meter.dart';
import 'package:gomotive/dhf/views/dhf_assess.dart';
import 'package:gomotive/gameplan/views/gameplan_template_list.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerClients extends StatelessWidget {
  final String flowType;
  final String clientType;
  final Map searchParams;
  final String dhfMovementMeterType;

  PractitionerClients({
    this.flowType,
    this.clientType,
    this.searchParams,
    this.dhfMovementMeterType
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerClients(
          flowType: this.flowType,
          clientType: this.clientType,
          searchParams: this.searchParams,
          dhfMovementMeterType: this.dhfMovementMeterType
        ),
      ),
    );
  }
}

class _PractitionerClients extends StatefulWidget {
  final String flowType;
  final String clientType;
  final Map searchParams;
  final String dhfMovementMeterType;
  _PractitionerClients({
    this.flowType,
    this.clientType,
    this.searchParams,
    this.dhfMovementMeterType
  });

  @override
  _PractitionerClientsState createState() => new _PractitionerClientsState();
}

class _PractitionerClientsState extends State<_PractitionerClients> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _searchController = new TextEditingController();

  ScrollController _controller;
  var _getClients, _toggleClientVisibility;
  List<Map> _clients;
  Map _paginateInfo;
  Map _businessPartner;

  _fetchClients(int pageNumber) {
    var params = new Map();
    params["page"] = pageNumber;
    if(widget.clientType != null) {
      params["client_type"] = widget.clientType;
    } else {
      params["client_type"] = "all";
    }
    if(_searchController.text != null) {
      params["search"] = _searchController.text;
    }
    _getClients(context, params);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _fetchClients(_paginateInfo["page"] + 1);
        }
    }
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
        _getClients = stateObject["getClients"];
        _toggleClientVisibility = stateObject["toggleClientVisibility"];
        _fetchClients(0);     
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClients"] = (BuildContext context, Map params) =>
            store.dispatch(getClients(context, params));
        returnObject["toggleClientVisibility"] = (BuildContext context, Map params) =>
            store.dispatch(toggleClientVisibility(context, params));
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        returnObject["clients"] = store.state.practitionerState.clients; 
        returnObject["paginateInfo"] = store.state.practitionerState.paginateInfo;       
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _businessPartner = stateObject["businessPartner"];
        _clients = stateObject["clients"];
        _paginateInfo = stateObject["paginateInfo"];
        if(_clients != null) {
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
                  if(widget.flowType == "client_home") {
                    Navigator.of(context).popAndPushNamed("/practitioner/home");
                  } else if(widget.flowType == "gi_3dmaps_exercise_list") {
                    Navigator.of(context).popAndPushNamed("/gi/3dmaps");
                  } else if(widget.flowType == "gi_golf_exercise_list") {
                    Navigator.of(context).popAndPushNamed("/gi/golf");
                  } else if(widget.flowType == "gi_3dmaps_assessment") {
                    Navigator.of(context).popAndPushNamed("/gi/3dmaps");
                  } else if(widget.flowType == "exercise_list") {
                    Navigator.of(context).popAndPushNamed("/practitioner/exercises");
                  } else if(widget.flowType == "workout_template_list") {
                    Navigator.of(context).popAndPushNamed("/practitioner/exercises");
                  } else if(widget.flowType == "gi_3dmaps_workout_template_list") {
                    Navigator.of(context).popAndPushNamed("/gi/3dmaps");
                  } else if(widget.flowType == "gi_golf_workout_template_list") {
                    Navigator.of(context).popAndPushNamed("/gi/golf");
                  } else if(
                    widget.flowType == "dhf_exercise_list" || 
                    widget.flowType == "dhf_workout_template_list" ||
                    widget.flowType == "dhf_workout_template_list_browse" || 
                    widget.flowType == "dhf_assessment" ||
                    widget.flowType == "dhf_gameplan_template_list"
                  ) {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new DHFMovementMeter(
                          movementMeterType: widget.dhfMovementMeterType
                        ),
                      ),
                    );              
                  } else {
                    Navigator.of(context).popAndPushNamed("/practitioner/home");
                  }
                },
              ),   
              backgroundColor: Colors.white,
              title: new Text(
                'Clients',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                       
              actions: <Widget>[                
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 36.0,
                      color: primaryColor,
                    ),
                    onPressed: () { 
                      Navigator.of(context).pushNamed("/practitioner/client/invite");                     
                    },
                  ),                
                ), 
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                child: Column(
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
                                hintText: "Search Clients",
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
                                _fetchClients(0);
                              },
                              child: new Image.asset(
                                'assets/images/search.png',
                                color: Colors.blue,                                
                              ),
                            )
                          )
                        ],
                      )                      
                    ),
                    new Expanded(
                      child: new ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: _clients.length,
                        itemBuilder: (context, i) {
                          final slideMenuKey = new GlobalKey<SlideMenuState>();
                          return new GestureDetector(                      
                            onTap: () {
                              if(widget.flowType == "client_home") {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new PractitionerClientHome(
                                      clientId: _clients[i]["id"],                           
                                    ),
                                  ),
                                );                        
                              } else if(widget.flowType == "gi_3dmaps_exercise_list") {
                                Map params = new Map();
                                params['threedmaps_filter'] = 'gi_3dmaps';
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new ExerciseList(
                                      exerciseSearchParams: params,
                                      usageType: "to_workout",
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "gi_golf_exercise_list") {
                                Map params = new Map();
                                params['threedmaps_filter'] = 'gi_golf';
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new ExerciseList(
                                      exerciseSearchParams: params,
                                      usageType: "to_workout",
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "gi_3dmaps_assessment") {                          
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new GI3dmapsAssessment(
                                      client: _clients[i],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "exercise_list") {                                
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new ExerciseList(
                                      exerciseSearchParams: widget.searchParams,
                                      usageType: "to_workout",
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "workout_template_list") {
                                Map params;
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new WorkoutTemplateList(
                                      searchParams: params,
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "gi_3dmaps_workout_template_list") {
                                Map params;
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new WorkoutTemplateList(
                                      searchParams: params,
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "gi_golf_workout_template_list") {
                                Map params;
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new WorkoutTemplateList(
                                      searchParams: params,
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "dhf_exercise_list") {                                
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new ExerciseList(
                                      exerciseSearchParams: widget.searchParams,
                                      usageType: "to_workout",
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "dhf_workout_template_list") {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new WorkoutTemplateList(
                                      searchParams: widget.searchParams,
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                      usageType: widget.flowType,
                                      dhfMovementMeterType: widget.dhfMovementMeterType,
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "dhf_assessment") {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new DHFAssessment(
                                      clientId: _clients[i]["id"],
                                      movementMeterType: widget.dhfMovementMeterType,
                                    ),
                                  ),
                                );
                              } else if(widget.flowType == "dhf_gameplan_template_list") {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new GameplanTemplateList(
                                      searchParams: widget.searchParams,
                                      clientId: _clients[i]["id"],
                                      engagementId: _clients[i]["active_engagement_id"],
                                      usageType: widget.flowType,
                                      dhfMovementMeterType: widget.dhfMovementMeterType,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: new SlideMenu(
                              key: slideMenuKey,
                              child: new ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                title: new Container(
                                  decoration: new BoxDecoration(
                                    border: new Border(
                                      bottom: new BorderSide(
                                        color: Colors.black12
                                      ),
                                    ),                              
                                  ),
                                  child: new Row(    
                                    children: <Widget>[
                                      new Container (                              
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        child: new Avatar(
                                          name: _clients[i]["name"],
                                          url: null,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                              child: new Text(_clients[i]["name"])
                                            ),
                                            new Container(
                                              child: new Text(
                                                _clients[i]["email"],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12.0,
                                                )
                                              )
                                            )
                                          ],
                                        )                              
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                              menuItems: 
                              _clients[i]["user_state"] == 3
                              ? <Widget>[
                                  new GestureDetector(
                                    onTap: () { 
                                      Map params = new Map();
                                      params["client_id"] = _clients[i]["id"];
                                      if(widget.clientType != "hidden") {
                                        params["visibility_type"] = "hide";
                                      } else {
                                        params["visibility_type"] = "show";
                                      }                               
                                      params["client_index"] = i;
                                      this._toggleClientVisibility(context, params);
                                    },
                                    child: new Container(
                                      color:Colors.yellowAccent,
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(
                                            GomotiveIcons.hide,
                                            color: Colors.black87
                                          ),                
                                          new Text(
                                            "HIDE",
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
                              : <Widget>[
                                  new GestureDetector(
                                    onTap: () { 
                                      Map params = new Map();
                                      params["client_id"] = _clients[i]["id"];
                                      if(widget.clientType != "hidden") {
                                        params["visibility_type"] = "hide";
                                      } else {
                                        params["visibility_type"] = "show";
                                      }                               
                                      params["client_index"] = i;
                                      this._toggleClientVisibility(context, params);                               
                                    },
                                    child: new Container(
                                      color:Colors.yellowAccent,
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(
                                            GomotiveIcons.hide,
                                            color: Colors.black87
                                          ),                
                                          new Text(
                                            "HIDE",
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
                            ),                      
                          );
                        },
                      ),
                    ),
                  ],
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
