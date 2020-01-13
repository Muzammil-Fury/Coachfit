import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/components/avatar.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/utils/menu_utils.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/home/home_network.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _UserProfile(),
        )        
      ),
    );
  }
}

class _UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => new _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _userSignoutAPI;

  Map _user;
  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {  
        _userSignoutAPI = stateObject["userSignout"];      
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map(); 
        returnObject["userSignout"] = (BuildContext context, Map params) =>
            store.dispatch(userSignout(context, params));
        returnObject["user"] = store.state.homeFitHomeState.user;         
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _user = stateObject["user"];           
        if(_user != null && token != null && token != "") {                    
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:dhfYellow,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                'My Profile',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),
              actions: <Widget>[              
              ],
            ), 
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 3,
              items: MenuUtils.buildNavigationMenuBar("profile"),
              onTap: (int index) {
                if(index != 3) {
                  MenuUtils.menubarTap(
                    context, "profile", index
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
                        mainAxisSize: MainAxisSize.min,                                                  
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            child: Center(
                              child: Avatar(
                                url: _user["avatar_url_tb"],
                                name: _user["name"],
                                maxRadius: 48.0,
                              ),
                            ),
                          ),
                          new Container(                            
                            child: Center(
                              child: Text(
                                _user["name"],
                                style: TextStyle(
                                  fontSize: 24.0
                                )
                              )
                            ),
                          ),
                          new Container(
                            child: Center(
                              child: Text(
                                _user["email"],
                                style: TextStyle(
                                  fontSize: 14.0
                                )
                              )
                            ),
                          ),                          
                          new Container(   
                            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 0),                                                       
                            child: new ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/user/movement_meter_settings");
                                  },
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        bottom: new BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),                              
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        GomotiveIcons.global_settings,
                                        color: dhfYellow,
                                      ),
                                      title: Text('Movement Meter Settings'),
                                    )
                                  ),
                                ),                                
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/user/edit_profile");                                    
                                  },
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        top: new BorderSide(
                                          color: Colors.black12
                                        ),
                                        bottom: new BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),                              
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        GomotiveIcons.edit_profile,
                                        color: dhfYellow,
                                      ),
                                      title: Text('Update Name'),
                                    )
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/user/change_password");
                                  },
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        bottom: new BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),                              
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        GomotiveIcons.change_password,
                                        color: dhfYellow,
                                      ),
                                      title: Text('Change Password'),
                                    )
                                  ),
                                ),                                                                
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/user/support");
                                  },
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        bottom: new BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),                              
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.help_outline,
                                        color: dhfYellow,
                                      ),
                                      title: Text('Support'),
                                    )
                                  ),
                                ),                                                            
                                new GestureDetector(
                                  onTap: () {
                                    Utils.confirmDialog(context, "Are you sure?", "Would you like to sign out from the App?", "Yes, I am", "No").then((int response){
                                      if(response == 1) {
                                        Map _params = new Map();
                                        _params["device_id"] = deviceId;
                                        _userSignoutAPI(context, _params);
                                      }
                                    });                                    
                                  },
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      border: new Border(
                                        bottom: new BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),                              
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        GomotiveIcons.signout,
                                        color: dhfYellow,
                                      ),
                                      title: Text('Sign Out'),
                                    )
                                  ),
                                ),                                
                              ],
                            ),
                          ),                            
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
