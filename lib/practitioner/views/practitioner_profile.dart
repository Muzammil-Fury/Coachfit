import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/auth/auth_network.dart';

class PractitionerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerProfile(),
      ),
    );
  }
}

class _PractitionerProfile extends StatefulWidget {
  @override
  _PractitionerProfileState createState() => new _PractitionerProfileState();
}

class _PractitionerProfileState extends State<_PractitionerProfile> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _pageName = "profile";
  List<Map> _menuList;
  Map _user;

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
        returnObject["menuList"] = store.state.practitionerState.menuItems;      
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _user = stateObject["user"];       
        _menuList = stateObject["menuList"];
        if(_user != null && _menuList != null) {
          int _currentIndex = PractitionerUtils.getCurrentIndex(_menuList, _pageName);
          String _privacyPolicyURL = baseURL + "site_media/static/files/privacy_policy.pdf";
          String _userAgreementURL = baseURL + "site_media/static/files/practitioner_terms_of_service.pdf";
          String _trainingManualURL;
          if(partnerAppType != "gi") {
            _trainingManualURL = baseURL + "site_media/static/files/dhf_coachfit_training_manual.pdf";
          }
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
              items: PractitionerUtils.buildNavigationMenuBar(_menuList, _pageName),
              onTap: (int index) {
                PractitionerUtils.menubarTap(
                  context, _menuList, _pageName, index
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
                                _trainingManualURL != null
                                ? new GestureDetector(
                                    onTap: () {
                                      Utils.launchInWebViewOrVC(_trainingManualURL);
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
                                          Icons.picture_as_pdf,
                                          color: primaryColor,
                                        ),
                                        title: Text('Training Manual'),
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
                                        GomotiveIcons.privacy,
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
                                    Map _params = new Map();
                                    _params["device_id"] = deviceId;
                                    _userSignoutAPI(context, _params);
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
