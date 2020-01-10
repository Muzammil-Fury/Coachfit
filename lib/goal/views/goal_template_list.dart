import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/goal/goal_network.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/goal/views/engagement_goal.dart';
import 'package:gomotive/core/app_config.dart';

class GoalTemplateList extends StatelessWidget {
  final int clientId;
  final int engagementId;
  GoalTemplateList({
    this.clientId,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _GoalTemplateList(
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _GoalTemplateList extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _GoalTemplateList({
    this.clientId,
    this.engagementId,
  });

  @override
  _GoalTemplateListState createState() => new _GoalTemplateListState();
}

class _GoalTemplateListState extends State<_GoalTemplateList> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  var _getGoalTemplateListAPI, _addGoalToEngagementAPI;
  List<Map> _goalTemplateList;

  List<Widget> _listGoalTemplates() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_goalTemplateList.length; i++) {
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu _item = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(        
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),                                    
                  child: new Text(
                    _goalTemplateList[i]["text"],
                    textAlign: TextAlign.start,
                  )
                ),                
              ]
            ),            
          )
        ),
        menuItems: <Widget>[
          new GestureDetector(
            onTap: () {   
              Map params = new Map();
              params["client_id"] = widget.clientId;
              params["engagement"] = widget.engagementId;
              params["goal_id"] = _goalTemplateList[i]["id"];
              _addGoalToEngagementAPI(context, params);              
            },
            child: new Container(
              color:Colors.greenAccent,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Icon(
                    Icons.add_circle_outline,
                    color: Colors.white
                  ),                
                  new Text(
                    "CREATE",
                    style: TextStyle(
                      color: Colors.white,
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
      _list.add(_item);
    }
    return _list;
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getGoalTemplateListAPI = stateObject["getGoalTemplateList"];  
        _addGoalToEngagementAPI = stateObject["addGoalToEngagement"];      
        Map params = new Map();
        params["fetch_type"] = "practitioner_assign";
        _getGoalTemplateListAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getGoalTemplateList"] = (BuildContext context, Map params) =>
            store.dispatch(getGoalTemplateList(context, params));  
        returnObject["addGoalToEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(addGoalToEngagement(context, params));                        
        returnObject["goalTemplateList"] = store.state.goalState.goalTemplateList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _goalTemplateList = stateObject["goalTemplateList"];
        if(_goalTemplateList != null) {
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
                  Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new EngagementGoal(
                        clientId: widget.clientId,
                        engagementId: widget.engagementId,                  
                      ),
                    ),
                  );                  
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                "Goal Templates",
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
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),                        
                      child: _goalTemplateList.length > 0
                      ? new Column(
                          children: _listGoalTemplates()
                        )
                      : new Center(
                        child: new Text(                          
                          'No goal templates available.',                          
                          textAlign: TextAlign.center,
                        )
                      )                      
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return new Container();
        }
      }
    );
  }
}
