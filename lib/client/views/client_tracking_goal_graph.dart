import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/core/app_config.dart';

class ClientTrackingGoalGraph extends StatelessWidget {
  final String type;
  final int id;
  final int goalTrackId;
  ClientTrackingGoalGraph({
    this.type,
    this.id,
    this.goalTrackId 
  });  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientTrackingGoalGraph(
          type: this.type,
          id: this.id,
          goalTrackId: this.goalTrackId,
        ),
      ),
    );
  }
}

class _ClientTrackingGoalGraph extends StatefulWidget {
  final String type;
  final int id;
  final int goalTrackId;
  _ClientTrackingGoalGraph({
    this.type,
    this.id,
    this.goalTrackId 
  });  


  @override
  _ClientTrackingGoalGraphState createState() => new _ClientTrackingGoalGraphState();
}


class _ClientTrackingGoalGraphState extends State<_ClientTrackingGoalGraph> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getGoalTrackingChartAPI, _clearGoalTrackingChartDetailsActionCreator;
  List<Map> _goalTrackingChartDetails;

  List<charts.Series<Map, DateTime>> _createChartSeriesData() {    
    return [
      new charts.Series(
        id: "goal_tracking",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Map dataObj, _) => dataObj["tracked_date_dt"],
        measureFn: (Map dataObj, _) => dataObj["current_value"],
        data: _goalTrackingChartDetails,        
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _clearGoalTrackingChartDetailsActionCreator = stateObject["ClearGoalTrackingChartDetailsActionCreator"];
        if(widget.type == "engagement") {
          _getGoalTrackingChartAPI = stateObject["getEngagementGoalTrackingChart"];
          Map _params = new Map();
          _params["type"] = widget.type;
          _params["engagement"] = widget.id;
          _params["goal_track_id"] = widget.goalTrackId;
          _getGoalTrackingChartAPI(context, _params);
        } else {
          _getGoalTrackingChartAPI = stateObject["getGroupGoalTrackingChart"];
          Map _params = new Map();
          _params["type"] = widget.type;
          _params["group_id"] = widget.id;
          _params["group_goal_client_question_id"] = widget.goalTrackId;
          _getGoalTrackingChartAPI(context, _params);
        }
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getEngagementGoalTrackingChart"] = (BuildContext context, Map params) =>
            store.dispatch(getEngagementGoalTrackingChart(context, params)); 
        returnObject["getGroupGoalTrackingChart"] = (BuildContext context, Map params) =>
            store.dispatch(getGroupGoalTrackingChart(context, params)); 
        returnObject["ClearGoalTrackingChartDetailsActionCreator"] = () =>
            store.dispatch(ClearGoalTrackingChartDetailsActionCreator()); 
        returnObject["goalTrackingChartDetails"] = store.state.clientState.goalTrackingChartDetails;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _goalTrackingChartDetails = stateObject["goalTrackingChartDetails"];
        if(_goalTrackingChartDetails != null && _goalTrackingChartDetails.length > 0)  {
          for(int i=0;i<_goalTrackingChartDetails.length;i++) {
            _goalTrackingChartDetails[i]["tracked_date_dt"] = DateTime.parse(
                                                            _goalTrackingChartDetails[i]["tracked_date"]
                                                          );
          }
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
                  this._clearGoalTrackingChartDetailsActionCreator();
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                "Graph",             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),          
              actions: <Widget>[ ],
            ),
            body: new LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(                
                  child: new Container(                    
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width,  
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Text(
                              _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["question"],
                              textAlign: TextAlign.center,
                              style: TextStyle(  
                                color: Colors.white, 
                                fontSize: 16.0,                                 
                              ),
                            )
                          ),   
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Chip(        
                                  backgroundColor: Colors.black26,        
                                  label: Text(
                                    _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["initial_value"] != null ? 'Baseline Value: ' + _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["initial_value"].toString() : 'Baseline Value: N/A' , 
                                    style: TextStyle(
                                      color: primaryTextColor
                                    ),
                                  )
                                ),  
                                new Chip(    
                                  backgroundColor: Colors.black26,            
                                  label: Text(
                                    _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["target_value"] != null ? 'Target Value: ' + _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["target_value"].toString() : 'Target Value: N/A' ,                                    
                                    style: TextStyle(
                                      color: primaryTextColor
                                    ),
                                  )
                                ),   
                              ],
                            )
                          ), 
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Chip(        
                              backgroundColor: Colors.green,        
                              label: Text(
                                'Current Value: ' + _goalTrackingChartDetails[_goalTrackingChartDetails.length-1]["current_value"].toString(),
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              )
                            ),
                          ),                      
                          new Container(
                            height: 300,
                            child: new charts.TimeSeriesChart(
                              _createChartSeriesData(),
                              animate: false,                        
                              dateTimeFactory: const charts.LocalDateTimeFactory(),
                            )
                          )
                        ],
                      )                      
                    )
                  )
                );
              }
            )
          );
        } else {
          return new Container();
        }
      }
    );
  }  
}