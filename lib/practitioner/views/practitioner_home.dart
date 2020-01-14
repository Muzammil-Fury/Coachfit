import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gomotive/homefit/home/views/verify_user.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';
import 'package:gomotive/auth/auth_network.dart';

class PractitionerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerHome(),
      ),
    );
  }
}

class _PractitionerHome extends StatefulWidget {
  @override
  _PractitionerHomeState createState() => new _PractitionerHomeState();
}

class _PractitionerHomeState extends State<_PractitionerHome> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _pageName = "home";
  var _practitionerHomePageDetailsAPI, _getPartnerDetailsAPI;
  List<Map> _menuList;
  int _alertCount;
 
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _practitionerHomePageDetailsAPI = stateObject["getPractitionerHomePageDetails"]; 
        _practitionerHomePageDetailsAPI(context, {});      
        _getPartnerDetailsAPI = stateObject["partnerDetailsAPI"]; 
        var params = new Map();
        params["subdomain"] = partnerSubdomain;
        _getPartnerDetailsAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getPractitionerHomePageDetails"] = (BuildContext context, Map params) =>
            store.dispatch(getHomePageDetails(context, params));
        returnObject["partnerDetailsAPI"] = (BuildContext context, Map params) =>
            store.dispatch(getPartnerDetails(context, params));            
        returnObject["menuList"] = store.state.practitionerState.menuItems;
        returnObject["alertCount"] = store.state.practitionerState.alertCount;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _menuList = stateObject["menuList"];
        _alertCount = stateObject["alertCount"];
        if(_menuList != null) {
          int _currentIndex = PractitionerUtils.getCurrentIndex(_menuList, _pageName);
          return new Scaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>new VerifyUser()));
                }
            ),
            key: _scaffoldKey,
            appBar: new AppBar(
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
              backgroundColor: Colors.white,
              title: new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                      height: 28,
                      width: 228,
                      child:Image.asset(
                        "assets/images/logo_big.png"
                      ),
                    ),                    
                  ],
                )
              ),
              actions: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                        icon: Icon(
                          GomotiveIcons.chat,
                          size: 36,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/practitioner/alerts');
                        },
                      ),
                      new Positioned(
                        child: new Stack(
                          children: <Widget>[
                            new Icon(
                              Icons.brightness_1,
                              size: 30.0, 
                              color: Colors.black87                              
                            ),
                            new Positioned(
                              top: 7.0,
                              left: 7.0,
                              child: new Center(                          
                                child: new Text(
                                  _alertCount != null ? _alertCount.toString() : "0",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  )                  
                ),                
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
                      child: PractitionerUtils.drawPractitionerHomePage(partnerSubdomain, context)                        
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
