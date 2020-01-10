import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/core/app_config.dart';

class Client3dmaps extends StatelessWidget {
  final int activeEngagementIndex;
  final bool fromNavigationBar;
  Client3dmaps({
    this.activeEngagementIndex,
    this.fromNavigationBar
  });

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _Client3dmaps(
          activeEngagementIndex: this.activeEngagementIndex,
          fromNavigationBar: this.fromNavigationBar
        ),
      ),
    );
  }
}

class _Client3dmaps extends StatefulWidget {
  final int activeEngagementIndex;
  final bool fromNavigationBar;
  _Client3dmaps({
    this.activeEngagementIndex,
    this.fromNavigationBar
  });
  @override
  _Client3dmapsState createState() => new _Client3dmapsState();
}

class _Client3dmapsState extends State<_Client3dmaps> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getClientActiveEngagementAPI;
  List<Map> _activeEngagements;
  List<Map> _assessments;

  List<Widget> _listEngagementAssessments() {
    List<Widget> _list = new List<Widget>();
    if(_assessments != null) {
      for(int i=0; i<_assessments.length; i++) {
        if(_assessments[i]["assessment_mode"] == 2) {
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
        _getClientActiveEngagementAPI = stateObject["getClientActiveEngagement"];      
        _getClientActiveEngagementAPI(context, new Map()); 
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClientActiveEngagement"] = (BuildContext context, Map params) =>
            store.dispatch(getClientActiveEngagement(context, params));  
        returnObject["activeEngagements"] = store.state.clientState.activeEngagements;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _activeEngagements = stateObject["activeEngagements"];
        if(_activeEngagements != null) {          
          if(_activeEngagements.length > 0) {
            if(widget.activeEngagementIndex != null) {
              _assessments = Utils.parseList(_activeEngagements[widget.activeEngagementIndex], "assessments");
            } else {
              _assessments = Utils.parseList(_activeEngagements[0], "assessments");
            }
          }  else {
            _assessments = [];
          }        
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
                  if(widget.fromNavigationBar == null || widget.fromNavigationBar) {
                    Navigator.of(context).pushReplacementNamed('/home/route');
                  } else {
                    Navigator.of(context).pop();
                  }                  
                },
              ),
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
                          'Your practitioner has not carried out 3DMAPS assessments.',
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
