import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/dhf/views/dhf_assess.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/dialog.dart';

class EngagementAssessmentAdd extends StatelessWidget {
  final int clientId;
  EngagementAssessmentAdd({
    this.clientId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementAssessmentAdd(
          clientId: this.clientId
        ),
      ),
    );
  }
}

class _EngagementAssessmentAdd extends StatefulWidget {
  final int clientId;
  _EngagementAssessmentAdd({
    this.clientId,
  });

  @override
  _EngagementAssessmentAddState createState() => new _EngagementAssessmentAddState();
}

class _EngagementAssessmentAddState extends State<_EngagementAssessmentAdd> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
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
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              "Select One",             
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
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(
                    child: new Center(
                      child: new Column(                           
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            child: new RawMaterialButton(
                              onPressed: () {
                                if(selectedRole["is_dhf_assessment_enabled"]) { 
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new DHFAssessment(
                                        clientId: widget.clientId,
                                        movementMeterType: "Mobility",
                                      ),
                                    ),
                                  );                      
                                } else {
                                  CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                                }
                              },
                              child: new Column(
                                children: <Widget> [
                                  new Image.asset(
                                    'assets/images/dhf_mobility.png'
                                  ),
                                  new Text(
                                    'Mobility',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  )
                                ]
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.lightBlue,
                              padding: const EdgeInsets.all(30.0),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            child:new RawMaterialButton(
                              onPressed: () {
                                if(selectedRole["is_dhf_assessment_enabled"]) { 
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new DHFAssessment(
                                        clientId: widget.clientId,
                                        movementMeterType: "Strength",
                                      ),
                                    ),
                                  );                                                    
                                } else {
                                  CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                                }
                              },
                              child: new Column(
                                children: <Widget> [
                                  new Image.asset(
                                    'assets/images/dhf_strength.png'
                                  ),
                                  new Text(
                                    'Strength',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  )
                                ]
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.lightGreen,
                              padding: const EdgeInsets.all(30.0),
                            ),
                          ),                  
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            child: new RawMaterialButton(
                              onPressed: () {
                                if(selectedRole["is_dhf_assessment_enabled"]) {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new DHFAssessment(
                                        clientId: widget.clientId,
                                        movementMeterType: "Metabolic",
                                      ),
                                    ),
                                  );                                   
                                } else {
                                  CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                                }
                              },
                              child: new Column(
                                children: <Widget> [
                                  new Image.asset(
                                    'assets/images/dhf_metabolic.png'
                                  ),
                                  new Text(
                                    'Metabolic',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  )
                                ]
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.yellow,
                              padding: const EdgeInsets.all(30.0),
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            child: new RawMaterialButton(
                              onPressed: () {  
                                if(selectedRole["is_dhf_assessment_enabled"]) { 
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new DHFAssessment(
                                        clientId: widget.clientId,
                                        movementMeterType: "Power",
                                      ),
                                    ),
                                  );                              
                                } else {
                                  CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                                }                                
                              },
                              child: new Column(
                                children: <Widget> [
                                  new Image.asset(
                                    'assets/images/dhf_power.png'
                                  ),
                                  new Text(
                                    'Power',
                                    style: TextStyle(
                                      fontSize: 24.0
                                    )
                                  )
                                ]
                              ),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.red,
                              padding: const EdgeInsets.all(30.0),
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
        
      }
    );
  }
}
