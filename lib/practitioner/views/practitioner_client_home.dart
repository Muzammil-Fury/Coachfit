import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';

class PractitionerClientHome extends StatelessWidget {
  final int clientId;
  final bool fromExternal;
  PractitionerClientHome({
    this.clientId,
    this.fromExternal: false,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerClientHome(
          clientId: this.clientId,
          fromExternal: this.fromExternal,
        ),
      ),
    );
  }
}

class _PractitionerClientHome extends StatefulWidget {
  final int clientId;
  final bool fromExternal;
  _PractitionerClientHome({
    this.clientId,
    this.fromExternal,
  });
  @override
  _PractitionerClientHomeState createState() => new _PractitionerClientHomeState();
}

class _PractitionerClientHomeState extends State<_PractitionerClientHome> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getClientHomePageDetails, _clearClientHomePage, _createEngagementAPI, _closeEngagementAPI;

  Map _clientObj, _engagementObj;
  int activeEngagementId;

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getClientHomePageDetails = stateObject["getClientHomePageDetails"];
        _clearClientHomePage = stateObject["clearClientHomePage"];
        _createEngagementAPI = stateObject["createEngagement"];
        _closeEngagementAPI = stateObject["closeEngagement"];
        Map params = new Map();
        params["id"] = widget.clientId;
        _getClientHomePageDetails(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClientHomePageDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getClientHomePageDetails(context, params));    
        returnObject["createEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(createEngagement(context, params));    
        returnObject["closeEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(closeEngagement(context, params));    
        returnObject["clearClientHomePage"] = () =>
            store.dispatch(ClearPractitionerClientHomeActionCreator());    
        returnObject["clientObj"] = store.state.practitionerState.clientObj;
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _clientObj = stateObject["clientObj"];  
        _engagementObj = stateObject["engagement"];
        bool _isGoalDefined = true;
        if(_engagementObj != null && _engagementObj["goals"] != null && (_engagementObj["goals"].length == 0  ||  _engagementObj["goals"][0]["goal_tracking"].length+_engagementObj["goals"][0]["inactive_goal_tracking"].length == 0)) {
          _isGoalDefined = false;
        }
        if(_clientObj != null && _clientObj.keys.length > 0) {              
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
                  this._clearClientHomePage();
                  if(widget.fromExternal) {
                    Navigator.of(context).pushReplacementNamed("/home/route");
                  } else {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new PractitionerClients(
                          flowType: "client_home",
                        ),
                      ),
                    );
                  }
                },
              ),    
              backgroundColor: Colors.white,
              title: new Text(
                _clientObj["client"]["name"],             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                       
              actions: <Widget>[],
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
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            child: new Center (
                              child: new Avatar(
                                url: _clientObj["client"]["avatar_url"],
                                name: _clientObj["client"]["name"],
                                maxRadius: 100,
                              ),
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                            child: new Center(
                              child: new Text(
                                _clientObj["client"]["name"],
                                style: TextStyle(
                                  fontSize: 20,
                                )
                              )
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: new Center(
                              child: new Text(
                                _clientObj["client"]["email"],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100
                                )
                              )
                            )
                          ),
                          _clientObj["active_engagement_id"] != null
                          ? new Container(
                              color: Colors.blueGrey,
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: new Center(
                                child: new Text(
                                  _engagementObj["name"], 
                                  style: TextStyle(
                                    fontSize: 20,           
                                    color: Colors.white,                       
                                  ),              
                                  textAlign: TextAlign.center,               
                                ),
                              )
                            )                            
                          : new Container(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 32.0),
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    child: new Center(
                                      child: new Text(
                                        "No active gameplan."
                                      )
                                    )                                    
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
                                    child: new FlatButton(
                                      color: primaryColor,                                
                                      child: new Text(
                                        'Start New Gameplan',
                                        style: TextStyle(
                                          color: primaryTextColor
                                        )
                                      ),
                                      onPressed: () {
                                        Map _params = new Map();
                                        _params["client_id"] = _clientObj["client"]["id"];
                                        this._createEngagementAPI(context, _params);
                                      },
                                    ),
                                  )
                                ],
                              )                              
                            ),
                          _clientObj["active_engagement_id"] != null
                          ? PractitionerUtils.drawClientHomePage(
                              context,
                              partnerSubdomain, 
                              _clientObj, 
                              _isGoalDefined,
                              _closeEngagementAPI
                            )
                          : new Container(),
                        ],
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
