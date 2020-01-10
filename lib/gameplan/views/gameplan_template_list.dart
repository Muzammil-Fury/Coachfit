import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/gameplan/gameplan_network.dart';
import 'package:gomotive/gameplan/gameplan_actions.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/dhf/views/dhf_movement_meter.dart';
import 'package:gomotive/gameplan/views/gameplan_template_view.dart';
import 'package:gomotive/core/app_config.dart';

class GameplanTemplateList extends StatelessWidget {
  final int clientId;
  final int engagementId;
  final Map searchParams;
  final String usageType;
  final String dhfMovementMeterType;
  
  GameplanTemplateList({
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
        child: _GameplanTemplateList(
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

class _GameplanTemplateList extends StatefulWidget {
  final Map searchParams;
  final int clientId;
  final int engagementId;
  final String usageType;
  final String dhfMovementMeterType;
  
  _GameplanTemplateList({
    this.clientId,
    this.engagementId,
    this.searchParams,
    this.usageType,
    this.dhfMovementMeterType,
  });

  @override
  _GameplanTemplateListState createState() => new _GameplanTemplateListState();
}

class _GameplanTemplateListState extends State<_GameplanTemplateList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  TextEditingController _searchController = new TextEditingController();

  var _getGameplanTemplateListAPI, 
      _clearGameplanTemplateListActionCreator;       

  List<Map> _gameplanTemplateList;
  Map _paginateInfo;
  
  ScrollController _controller;

  _fetchWorkoutTemplates(int pageNumber) {
    Map _params = new Map();    
    if(widget.searchParams != null) {
      _params = {}..addAll(widget.searchParams);
    } 
    _params["page"] = pageNumber;
    _params["treatment_type"] = 1;
    _params["treatment_state"] = "active";
    _params["show_partner_templates"] = true;
    _params["show_published"] = true;
    if(_searchController.text != null) {
      _params["search"] = _searchController.text;
    }
    _getGameplanTemplateListAPI(context, _params);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
        if(_paginateInfo.containsKey("total_pages") && (_paginateInfo["page"]+1) < _paginateInfo["total_pages"]){
          _fetchWorkoutTemplates(_paginateInfo["page"] + 1,);
        }
    }
  }

  Widget _buildRow(Map _template, int selectedIndex) {    
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
                  new Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    width: MediaQuery.of(context).size.width*0.8,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          _template["name"],
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
                                  _template["practice"]["name"],
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white
                                  )
                                )
                              ),                              
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
                  builder: (context) => new GameplanTemplateView(
                    clientId: widget.clientId,
                    engagementId: widget.engagementId,
                    searchParams: widget.searchParams,
                    usageType: widget.usageType,
                    dhfMovementMeterType: widget.dhfMovementMeterType,
                    gameplanTemplate: _gameplanTemplateList[selectedIndex]
                  ),
                ),
              );
            },
            child: new Container(
              color:Colors.lightBlueAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.add_circle_outline,
                    color: Colors.black87
                  ),                
                  new Text(
                    "ADD",
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
      : <Widget>[],
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
        _getGameplanTemplateListAPI = stateObject["getGameplanTemplateList"];         
        _clearGameplanTemplateListActionCreator = stateObject["clearGameplanTemplateListActionCreator"];
        _fetchWorkoutTemplates(0);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getGameplanTemplateList"] = (BuildContext context, Map params) =>
            store.dispatch(getGameplanTemplateList(context, params));        
        returnObject["clearGameplanTemplateListActionCreator"] = () =>
            store.dispatch(GamePlanTemplateListClearActionCreator());
        returnObject["gameplanTemplateList"] = store.state.gameplanState.gameplanTemplateList;
        returnObject["paginateInfo"] = store.state.gameplanState.gameplanPaginateInfo;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _gameplanTemplateList = stateObject["gameplanTemplateList"];        
        _paginateInfo = stateObject["paginateInfo"];             
        if(_gameplanTemplateList != null) {
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
                  this._clearGameplanTemplateListActionCreator();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new DHFMovementMeter(
                        movementMeterType: widget.dhfMovementMeterType
                      ),
                    ),
                  );                  
                },
              ),
              title: new Text(
                'Gameplan Templates',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[                
              ],
            ),            
            body: new SafeArea(
              bottom: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: _gameplanTemplateList.length > 0
                ? new ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _gameplanTemplateList.length+1,
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
                                        hintText: "Search gameplan templates",
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
                            ),
                          ],
                        );                        
                      } else {                      
                        return _buildRow(_gameplanTemplateList[i-1], i-1);                    
                      }
                    },
                  )
                : new Container(
                    child: new Column(
                      children: <Widget>[
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
                                    hintText: "Search gameplan templates",
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
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
                          child: new Center(
                            child: new Text(
                              "No gameplan templates available."
                            )
                          )
                        )
                      ],
                    )                    
                  ),
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
