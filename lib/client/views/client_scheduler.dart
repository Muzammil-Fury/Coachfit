import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class ClientScheduler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientScheduler(),
      ),
    );
  }
}

class _ClientScheduler extends StatefulWidget {
  @override
  _ClientSchedulerState createState() => new _ClientSchedulerState();
}

class _ClientSchedulerState extends State<_ClientScheduler> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _pageName = "scheduler";
  List<Map> _menuList;
  int _programCount;
  String _programType;
  int _programId;


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
                'Scheduler',             
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
                      child: new Center(
                        child: new Column(                      
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                              child: new GestureDetector(
                                onTap:() {         
                                  Navigator.of(context).pushNamed("/scheduler/group_classes");                       
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
                                        'Group Classes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white
                                        )
                                      )
                                    ),
                                  ),
                                ),                            
                              ),
                            ),                          
                            new Container(
                              padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                              child: new GestureDetector(
                                onTap:() {     
                                  Navigator.of(context).pushNamed("/scheduler/studio_facility");                           
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
                                        'Studio Facility',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
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
                      ),
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
