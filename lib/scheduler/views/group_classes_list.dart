import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/scheduler/scheduler_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/scheduler/views/group_classes_booking.dart';
import 'package:gomotive/core/app_config.dart';

class GroupClassesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: _GroupClassesList(),
      ),
    );
  }
}

class _GroupClassesList extends StatefulWidget {
  @override
  _GroupClassesListState createState() => new _GroupClassesListState();
}

class _GroupClassesListState extends State<_GroupClassesList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getGroupClassesListAPI;

  List<Map> _groupClassesList;
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) { 
        _getGroupClassesListAPI = stateObject["getGroupClassesList"];
        Map _params = new Map();
        _params["current_role_type"] = "client";
        _getGroupClassesListAPI(context, _params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getGroupClassesList"] = (BuildContext context, Map params) =>
            store.dispatch(getGroupClassesList(context, params));
        returnObject["groupClassesList"] = store.state.schedulerState.studioFacilityList;   
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _groupClassesList = stateObject["groupClassesList"];     
        if(this._groupClassesList != null) {          
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
                  Navigator.of(context).pushReplacementNamed("/client/scheduler");
                },
              ),
              title: new Text(
                'Group Classes',             
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
                      child: _groupClassesList.length > 0
                      ? new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _groupClassesList.length,
                          itemBuilder: (context, i) {
                            String _trainers;
                            if(_groupClassesList[i]["practitioners"] != null) {
                              for(int j=0; j<_groupClassesList[i]["practitioners"].length; j++) {
                                if(j == 0) {
                                  _trainers = _groupClassesList[i]["practitioners"][j]["name"];
                                } else {
                                  _trainers = _trainers + ", " + _groupClassesList[i]["practitioners"][j]["name"];
                                }
                              }
                            }
                            return new GestureDetector(
                              onTap: () {   
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new GroupClassBooking(
                                      groupClassId: _groupClassesList[i]["id"],
                                    ),
                                  ),
                                );
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  border: new Border(
                                    bottom: new BorderSide(
                                      color: Colors.black12
                                    ),
                                  ),                              
                                ),
                                child: new Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          _groupClassesList[i]["name"],
                                          style: TextStyle(
                                            fontSize: 20.0
                                          ),
                                        )
                                      ),
                                      _trainers != null
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                          child: new Text(
                                            "Trainers: " + _trainers,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight:FontWeight.w100
                                            ),
                                          )
                                        )
                                      : new Container(),                                      
                                      new Container(
                                        child: new Text(
                                          _groupClassesList[i]["practice"]["name"],
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight:FontWeight.w100
                                          ),
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          Utils.convertDateStringToDisplayStringDate(_groupClassesList[i]["start_date"]) + 
                                          " to " + 
                                          Utils.convertDateStringToDisplayStringDate(_groupClassesList[i]["end_date"]),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight:FontWeight.w100
                                          ),
                                        )
                                      ),
                                    ],
                                  )                                
                                )                                
                              ),
                            );
                          }
                        )
                      : new Center(
                        child: new Text(
                          "No Group Class is available for you to schedule bookings.",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
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
      },  
    );
  }
}
