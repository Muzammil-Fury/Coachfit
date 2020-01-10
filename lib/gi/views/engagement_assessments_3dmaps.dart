import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementAssessments3DMAPS extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementAssessments3DMAPS(
        ),
      ),
    );
  }
}

class _EngagementAssessments3DMAPS extends StatefulWidget {  
  @override
  _EngagementAssessments3DMAPSState createState() => new _EngagementAssessments3DMAPSState();
}

class _EngagementAssessments3DMAPSState extends State<_EngagementAssessments3DMAPS> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // var _getClientEngagementAPI, _clearClientEngagementActionCreator;
  List<Map> _assessments;

  List<Widget> _listEngagementAssessments() {
    List<Widget> _list = new List<Widget>();
    if(_assessments != null) {
      for(int i=0; i<_assessments.length; i++) {
        if(_assessments[i]["assessment_mode"] == 2 || _assessments[i]["assessment_mode"] == 1) {
          Container assessmentContainer = new Container(
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: new Column(
              children: <Widget>[
                new Container(                  
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          _assessments[i]["assessment_name"],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )      
                        )
                      ),
                      new Container(
                        child: new Text(
                          " (" + Utils.convertDateStringToDisplayStringDate(_assessments[i]["assessment_date"]) + ")",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 14.0,
                          )
                        )
                      )
                    ],
                  )
                ),                
                new Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: new Text(
                    _assessments[i]["assessment_note"]
                  )
                )
              ],
            )
          );
          _list.add(assessmentContainer);
        }
      }
    }    
    return _list;
  }
  
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        // _getClientEngagementAPI = stateObject["getClientEngagement"];
        // _clearClientEngagementActionCreator = stateObject["clearClientEngagement"];
        // Map params = new Map();
        // params["id"] = widget.engagementId;
        // _getClientEngagementAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        // returnObject["getClientEngagement"] = (BuildContext context, Map params) =>
        //     store.dispatch(getClientEngagement(context, params));  
        // returnObject["clearClientEngagement"] = () =>
        //     store.dispatch(PractitionerEngagementClearActionCreator());  
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;    
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {                
        if(stateObject["engagement"] != null && stateObject["engagement"].containsKey("assessments")) {
          _assessments = Utils.parseList(stateObject["engagement"], "assessments");
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
                  // this._clearClientEngagementActionCreator();
                  Navigator.of(context).pop();
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                '3DMAPS',             
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
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 32.0),
                      child: _assessments.length > 0
                      ? new Column(
                          children: _listEngagementAssessments()
                        )
                      : new Center(
                        child: new Text(
                          'There is no 3DMAPS Assessment, please assess.',
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
      }
    );
  }
}
