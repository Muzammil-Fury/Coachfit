import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/practitioner/practitioner_utils.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/exercise/views/exercise_list.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerExercises extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerExercises(          
        ),
      ),
    );
  }
}

class _PractitionerExercises extends StatefulWidget {  
  @override
  _PractitionerExercisesState createState() => new _PractitionerExercisesState();
}

class _PractitionerExercisesState extends State<_PractitionerExercises> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  

  String _pageName = "exercises";
  List<Map> _menuList;
  



  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["menuList"] = store.state.practitionerState.menuItems;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _menuList = stateObject["menuList"];
        if(_menuList != null) {
          int _currentIndex = PractitionerUtils.getCurrentIndex(_menuList, _pageName);
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
                  Navigator.of(context).popAndPushNamed("/practitioner/home");
                }
              ),
              backgroundColor: Colors.white,
              title: new Text(
                'Exercises',             
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
                      child: new Center(
                        child: new Column(                      
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                              child: new GestureDetector(
                                onTap:() {
                                  Map params = new Map();
                                  params['partners'] = [2];
                                  params['my_exercises'] = false;
                                  params['my_practice_exercise'] = false;
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new PractitionerClients(
                                        searchParams: params,
                                        flowType: "exercise_list",
                                      ),
                                    ),
                                  );
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
                                        'Assign Exercises',
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
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new PractitionerClients(
                                        flowType: "workout_template_list",
                                      ),
                                    ),
                                  );
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
                                        'Assign Workout Templates',
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
                                  Map params = new Map();
                                  params['partners'] = [2];
                                  params['my_exercises'] = false;
                                  params['my_practice_exercise'] = false;
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new ExerciseList(
                                        exerciseSearchParams: params,
                                        usageType: "generic_view_library",
                                      ),
                                    ),
                                  );
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
                                        'Browse Library',
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
