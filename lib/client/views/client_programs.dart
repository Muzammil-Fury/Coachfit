import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/client/views/client_workouts_today.dart';
import 'package:gomotive/client/views/client_habits_today.dart';
import 'package:gomotive/client/views/client_nutrition.dart';
import 'package:gomotive/client/views/client_tracking_goals.dart';
import 'package:gomotive/core/app_config.dart';

class ClientPrograms extends StatelessWidget {
  final String type;
  ClientPrograms({
    this.type
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientPrograms(
          type: this.type
        ),
      ),
    );
  }
}

class _ClientPrograms extends StatefulWidget {
  final String type;
  _ClientPrograms({
    this.type
  });
  
  @override
  _ClientProgramsState createState() => new _ClientProgramsState();
}

class _ClientProgramsState extends State<_ClientPrograms> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  var _getProgramListAPI;
  List<Map> _programList;
  

  List<Widget> _displayProgramWidgets() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_programList.length; i++){
      GestureDetector c = new GestureDetector(
        onTap: () {
          if(widget.type == "workout") {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ClientWorkoutsToday(
                  id: _programList[i]["details"]["id"],
                  type: _programList[i]["type"],
                  displayProgramTitle: true,
                ),
              ),
            );
          } else if(widget.type == "habit") {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ClientHabitsToday(
                  id: _programList[i]["details"]["id"],
                  type: _programList[i]["type"],
                  displayProgramTitle: true,
                ),
              ),
            );
          } else if(widget.type == "nutrition") {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ClientNutrition(
                  id: _programList[i]["details"]["id"],
                  type: _programList[i]["type"],
                  displayProgramTitle: true,
                ),
              ),
            );
          } else if(widget.type == "goal") {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ClientTrackingGoal(
                  id: _programList[i]["details"]["id"],
                  type: _programList[i]["type"],
                ),
              ),
            );
          }
        },
        child: new Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black12
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              _programList[i]["type"] == "engagement" ?
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24.0),
                  child: new Icon(
                    GomotiveIcons.game_plan,
                    color: Colors.black,
                  )
                )
              : new Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24.0),
                  child: new Icon(
                    GomotiveIcons.group,
                    color: Colors.black,
                  ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        _programList[i]["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16
                        )
                      ),
                    ),
                    _programList[i]["type"] == "engagement" ?
                      new Container(
                        child: new Text(
                          _programList[i]["details"]["practitioner"]["name"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45
                          )
                        )
                      )
                    : new Container(
                        child: new Text(
                          _programList[i]["details"]["owner"]["name"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black45
                          )
                        )
                      ),
                    new Container(
                      child: new Text(
                        _programList[i]["details"]["practice"]["name"] + " practice",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45
                        )
                      ),
                    ),
                  ],
                )
              )            
            ],
          )
        )
      );
      _list.add(c);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _getProgramListAPI = stateObject["getProgramList"];
        Map params = new Map();
        _getProgramListAPI(context, params);   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getProgramList"] = (BuildContext context, Map params) =>
            store.dispatch(getProgramList(context, params));        
        returnObject["programList"] = store.state.clientState.programList;        
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _programList = stateObject["programList"];        
        if(_programList != null) {          
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
                  Navigator.of(context).pop();
                },
              ),
              title: new Text(
                'Select One',             
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _displayProgramWidgets()
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
