import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/client/client_utils.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/auth/auth_network.dart';

class ClientProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientProfile(),
      ),
    );
  }
}

class _ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => new _ClientProfileState();
}

class _ClientProfileState extends State<_ClientProfile> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _pageName = "profile";
  List<Map> _menuList;
  int _programCount;
  String _programType;
  int _programId;


  Map _user;
  Map _businessPartner;  
  int _associatedPracticeCount;

  var _userSignoutAPI;

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {  
        _userSignoutAPI = stateObject["userSignout"];       
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map(); 
        returnObject["userSignout"] = (BuildContext context, Map params) =>
            store.dispatch(userSignout(context, params));        
        returnObject["user"] = store.state.authState.user; 
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        returnObject["associatedPracticeCount"] = store.state.clientState.associatedPracticeCount;
        returnObject["menuList"] = store.state.clientState.menuItems;
        returnObject["programCount"] = store.state.clientState.programCount;
        returnObject["programType"] = store.state.clientState.programType;
        returnObject["programId"] = store.state.clientState.programId;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _businessPartner = stateObject["businessPartner"];
        _user = stateObject["user"];   
        _associatedPracticeCount = stateObject["associatedPracticeCount"];     
        _menuList = stateObject["menuList"];
        _programCount = stateObject["programCount"];
        _programType = stateObject["programType"];
        _programId = stateObject["programId"];
        if(_menuList != null && _user != null && _businessPartner != null) {
          int _currentIndex = ClientUtils.getCurrentIndex(_menuList, _pageName); 
          String _privacyPolicyURL = baseURL + "site_media/static/files/privacy_policy.pdf";
          String _userAgreementURL = baseURL + "site_media/static/files/client_terms_of_use.pdf";
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home/route');
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
              currentIndex: _currentIndex,
              items: ClientUtils.buildNavigationMenuBar(_menuList, _pageName),
              onTap: (int index) {
                ClientUtils.menubarTap(
                  context, _menuList, _pageName, index, _programCount, _programType, _programId
                );                
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
                                maxRadius: 64.0,
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
                                        color: primaryColor,
                                      ),
                                      title: Text('Edit Profile'),
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
                                        color: primaryColor,
                                      ),
                                      title: Text('Change Password'),
                                    )
                                  ),
                                ),
                                // _associatedPracticeCount > 1 ?
                                //   new GestureDetector(
                                //     onTap: () {                                   
                                //     },
                                //     child: new Container(
                                //       decoration: new BoxDecoration(
                                //         border: new Border(
                                //           bottom: new BorderSide(
                                //             color: Colors.black12
                                //           ),
                                //         ),                              
                                //       ),
                                //       child: ListTile(
                                //         leading: Icon(
                                //           Icons.bookmark_border,
                                //           color: primaryColor,
                                //         ),
                                //         title: Text('Set Primary Practice'),
                                //       )
                                //     ),
                                //   )
                                // : new Container(),
                                _businessPartner["show_movement_graph"] == true ?
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
                                          GomotiveIcons.edit_profile,
                                          color: primaryColor,
                                        ),
                                        title: Text('Movement Meter Settings'),
                                      )
                                    ),
                                  )
                                : new Container(),
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
                                        color: primaryColor,
                                      ),
                                      title: Text('Support'),
                                    )
                                  ),
                                ),                            
                                new GestureDetector(
                                  onTap: () {
                                    Utils.launchInWebViewOrVC(_privacyPolicyURL);
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
                                        GomotiveIcons.password,
                                        color: primaryColor,
                                      ),
                                      title: Text('Privacy Policy'),
                                    )
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {
                                    Utils.launchInWebViewOrVC(_userAgreementURL);                                 
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
                                        GomotiveIcons.user_terms,
                                        color: primaryColor,
                                      ),
                                      title: Text('User Terms'),
                                    )
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {  
                                    Navigator.of(context).pushNamed("/user/about");                                  
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
                                        Icons.star_border,
                                        color: primaryColor,
                                      ),
                                      title: Text('About'),
                                    )
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {
                                    CustomDialog.confirmDialog(context, "Are you sure?", "Would you like to sign out from the App?", "Yes, I am", "No").then((int response){
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
                                        color: primaryColor,
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
