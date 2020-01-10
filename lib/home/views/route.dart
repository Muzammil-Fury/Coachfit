import 'package:flutter/material.dart';
import 'package:gomotive/auth/auth_network.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:flutter/scheduler.dart';
import 'package:gomotive/utils/external.dart';

class Route extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _Route(),
      ),
    );
  }
}

class _Route extends StatefulWidget {
  @override
  _RouteState createState() => new _RouteState();
}

class _RouteState extends State<_Route> {  

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map> _roles;  

  var _userSignoutAPI;

  @override
  void initState() { 
    super.initState();        
  }

  _loadURL(BuildContext context) {    
    if(loadInitialURL != null) {
      External.parseURL(loadInitialURL);
      loadInitialURL = null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => this._loadURL(context)); 
    }    
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {    
        _userSignoutAPI = stateObject["userSignout"];    
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["userSignout"] = (BuildContext context, Map params) =>
            store.dispatch(userSignout(context, params));        
        returnObject["roles"] = store.state.authState.roles;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _roles = stateObject["roles"];    
        if(_roles != null) {           
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {
                },
              ),
              title: new Text(
                'Choose Role',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    GomotiveIcons.signout,
                    color: primaryColor,
                  ),
                  onPressed: () {   
                    CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to sign out from the App?", "Yes, I am", "No").then((int response){
                      if(response == 1) {
                        Map _params = new Map();
                        _params["device_id"] = deviceId;
                        _userSignoutAPI(context, _params);                        
                      }
                    });                                     
                  },
                ),
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
                      child: new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _roles.length,
                        itemBuilder: (context, i) {
                          return new GestureDetector(
                            onTap: () {
                              if(_roles[i]["role"]["id"] == 4) {
                                selectedRole = _roles[i];
                                selectedRoleId = _roles[i]["role"]["id"].toString();
                                selectedRoleName = _roles[i]["role"]["name"];
                                Navigator.of(context).pushReplacementNamed("/client/home");
                              } else {
                                selectedRole = _roles[i];
                                selectedRoleId = _roles[i]["practice"]["id"].toString();
                                selectedRoleName = _roles[i]["role"]["name"];
                                if(_roles[i]["practice"]["short_name"] != null) {
                                  practiceDisplayName = _roles[i]["practice"]["short_name"];
                                } else {
                                  practiceDisplayName = _roles[i]["practice"]["name"];
                                }
                                Navigator.of(context).pushReplacementNamed("/practitioner/home");
                              }
                            },
                            child: new Container(
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
                                    child: Avatar(
                                      url: _roles[i]["avatar_url"],
                                      name: _roles[i]["name"]
                                    ),
                                  ),
                                  new Flexible(
                                    child: new Container(
                                      child: new Text(_roles[i]["name"])
                                    )
                                  ),
                                ]
                              ),
                            ),
                          );
                        },
                      )                                      
                    ),
                  ),
                );
              },
            ),
          );          
        } else {
          return Container();
        }
      }
    );
  }
}
