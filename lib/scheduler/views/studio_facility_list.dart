import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/scheduler/scheduler_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/scheduler/views/studio_facility_booking.dart';
import 'package:gomotive/core/app_config.dart';

class StudioFacilityList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: _StudioFacilityList(),
      ),
    );
  }
}

class _StudioFacilityList extends StatefulWidget {
  @override
  _StudioFacilityListState createState() => new _StudioFacilityListState();
}

class _StudioFacilityListState extends State<_StudioFacilityList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getStudioFacilityListAPI;

  List<Map> _studioFacilityList;
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) { 
        _getStudioFacilityListAPI = stateObject["getStudioFacilityList"];
        Map _params = new Map();
        _params["current_role_type"] = "client";
        _getStudioFacilityListAPI(context, _params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getStudioFacilityList"] = (BuildContext context, Map params) =>
            store.dispatch(getStudioFacilityList(context, params));
        returnObject["studioFacilityList"] = store.state.schedulerState.studioFacilityList;   
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _studioFacilityList = stateObject["studioFacilityList"];     
        if(this._studioFacilityList != null) {          
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
                'Studio Facility',             
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
                      child: _studioFacilityList.length > 0
                      ? new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _studioFacilityList.length,
                          itemBuilder: (context, i) {
                            return new GestureDetector(
                              onTap: () {   
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new StudioFacilityBooking(
                                      studioFacilityId: _studioFacilityList[i]["id"],
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
                                          _studioFacilityList[i]["name"],
                                          style: TextStyle(
                                            fontSize: 20.0
                                          ),
                                        )
                                      ),
                                      new Container(
                                        child: new Text(
                                          _studioFacilityList[i]["practice"]["name"],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight:FontWeight.w100
                                          ),
                                        )
                                      )
                                    ],
                                  )                                
                                )                                
                              ),
                            );
                          }
                        )
                      : new Center(
                        child: new Text(
                          "No Studio Facility is available for you to schedule bookings.",
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
