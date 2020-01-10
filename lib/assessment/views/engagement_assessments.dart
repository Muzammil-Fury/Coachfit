import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/slide_menu.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/assessment/views/engagement_assessment_add.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementAssessments extends StatelessWidget {
  final int clientId;
  final int engagementId;
  EngagementAssessments({
    this.clientId,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementAssessments(
          clientId: this.clientId,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _EngagementAssessments extends StatefulWidget {
  final int clientId;
  final int engagementId;
  _EngagementAssessments({
    this.clientId,
    this.engagementId,
  });


  @override
  _EngagementAssessmentsState createState() => new _EngagementAssessmentsState();
}

class _EngagementAssessmentsState extends State<_EngagementAssessments> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  Map _engagementObj;
  List<Map> _assessments;

  List<Widget> _listAssessments() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<_assessments.length; i++) {
      final slideMenuKey = new GlobalKey<SlideMenuState>();
      SlideMenu _item = new SlideMenu(
        key: slideMenuKey,
        child: new ListTile(        
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), 
          title: new Container(          
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),         
            decoration: new BoxDecoration(                          
              border: new Border(
                bottom: new BorderSide(
                  color: Colors.black12
                ),
              ),                              
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),                                    
                  child: new Text(
                    _assessments[i]["assessment_name"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0
                    )
                  )
                ),                
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),                                    
                  child: new Text(
                    _assessments[i]["practitioner"]["name"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0
                    )
                  )
                ),
                new Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),                                    
                  child: new Text(
                    Utils.convertDateStringToDisplayStringDate(_assessments[i]["assessment_date"]),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0
                    )
                  )
                ),
              ]
            ),            
          )
        ),
        menuItems: <Widget>[
          // new GestureDetector(
          //   onTap: () { 
          //     CustomDialog.alertDialog(context, "Work In Progress", "Feature yet to be implemented");                           
          //   },
          //   child: new Container(
          //     color: Colors.blueAccent,
          //     child: new Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         new Icon(
          //           Icons.info_outline,
          //           color: Colors.white
          //         ),                
          //         new Text(
          //           "VIEW",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 10.0,
          //             fontWeight: FontWeight.w500
          //           )
          //         )              
          //       ]
          //     )
          //   ),
          // ),          
        ]
      );
      _list.add(_item);
    }
    return _list;
  }
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {           
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();          
        returnObject["engagement"] = store.state.practitionerState.activeClientEngagement;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {      

        _engagementObj = stateObject["engagement"];        
        if(_engagementObj != null) {
          if(_engagementObj.containsKey("assessments")) {
            _assessments = Utils.parseList(_engagementObj, "assessments");
          } else {
            _assessments = [];
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
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new PractitionerClientHome(
                        clientId: widget.clientId,                           
                      ),
                    ),
                  );
                },
              ),     
              backgroundColor: Colors.white,
              title: new Text(
                'Assessments',
                style: TextStyle(
                  color: Colors.black87
                )   
              ),                     
              actions: <Widget>[                
              ],
            ),  
            floatingActionButton: new FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () async {   
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new EngagementAssessmentAdd(
                      clientId: widget.clientId,                           
                    ),
                  ),
                );
              },
              child: new Text(
                "ADD",
                style: TextStyle(
                  color: primaryTextColor
                )
              ),            
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,                      
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
                          children: _listAssessments()
                        )
                      : new Center(
                        child: new Text(                          
                          "No assessment has been conducted. Kindly click on Add to conduct an assessment.",
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
