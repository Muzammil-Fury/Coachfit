import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/client/views/client_programs.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/client/views/client_tracking_goals.dart';
import 'package:gomotive/core/app_config.dart';

class ClientTracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientTracking(),
      ),
    );
  }
}

class _ClientTracking extends StatefulWidget {
  @override
  _ClientTrackingState createState() => new _ClientTrackingState();
}

class _ClientTrackingState extends State<_ClientTracking> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _pageName = "tracking";
  List<Map> _menuList;
  int _programCount;
  String _programType;
  int _programId;

  List<Map> data = [
    {"date": new DateTime(2017, 9, 5), "count": 25},
    {"date": new DateTime(2017, 9, 12), "count": 15},
    {"date": new DateTime(2017, 9, 19), "count": 5},
    {"date": new DateTime(2017, 9, 26), "count": 25},
    {"date": new DateTime(2017, 10, 3), "count": 105},
    {"date": new DateTime(2017, 10, 10), "count": 75},      
    {"date": new DateTime(2017, 10, 17), "count": 121},      
    {"date": new DateTime(2017, 10, 24), "count": 45},
    {"date": new DateTime(2017, 10, 31), "count": 20},            

  ];

  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {        
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["menuList"] = store.state.clientState.menuItems;
        returnObject["programCount"] = store.state.clientState.programCount;
        returnObject["programType"] = store.state.clientState.programType;
        returnObject["programId"] = store.state.clientState.programId;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _menuList = stateObject["menuList"];
        _programCount = stateObject["programCount"];
        _programType = stateObject["programType"];
        _programId = stateObject["programId"];
        if(_menuList != null) {
          int _currentIndex = ClientUtils.getCurrentIndex(_menuList, _pageName);
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
                'Tracking',             
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
                      child: new Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                        child: new Center(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                                child: new GestureDetector(
                                  onTap:() {                                     
                                    if(_programCount > 1) {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new ClientPrograms(
                                            type: "goal",
                                          ),
                                        ),
                                      );
                                    } else if(_programCount == 1) {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new ClientTrackingGoal(
                                            type: this._programType,
                                            id: this._programId
                                          ),
                                        ),
                                      );
                                    } else {
                                      CustomDialog.alertDialog(context, "No goals to track", "You are not associated with any game plan or groups");
                                    }                               
                                  },
                                  child: new PhysicalModel(
                                    borderRadius: new BorderRadius.circular(125.0),
                                    color: Colors.blueGrey,
                                    child: new Container(
                                      width: 250.0,
                                      height: 250.0,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(125.0),                                  
                                      ),
                                      child: new Center(
                                        child: new Text(
                                          'GOAL',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                          )
                                        )
                                      ),
                                    ),
                                  ),                            
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 32),
                                child: new GestureDetector(
                                  onTap:() {   
                                    Navigator.pushNamed(context, "/client/tracking/movement_meter");                               
                                  },
                                  child: new PhysicalModel(
                                    borderRadius: new BorderRadius.circular(125.0),
                                    color: Colors.blueGrey,
                                    child: new Container(
                                      width: 250.0,
                                      height: 250.0,
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.circular(125.0),                                  
                                      ),
                                      child: new Center(
                                        child: new Text(
                                          'MOVEMENT METER',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white
                                          )
                                        )
                                      ),
                                    ),
                                  ),                            
                                ),
                              ),
                            ],
                          )                              
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
