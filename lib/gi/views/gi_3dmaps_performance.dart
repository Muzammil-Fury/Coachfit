import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/gi/views/gi_3dmaps_summary.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class GI3dmapsPerformance extends StatelessWidget {
  final Map client;
  final int engagementId;
  final int analysisType;
  final String notes;
  final String relativeSuccessCode;

  GI3dmapsPerformance({
    this.client,
    this.engagementId,
    this.analysisType,
    this.notes,
    this.relativeSuccessCode,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _GI3dmapsPerformance(
          client: this.client,
          engagementId: this.engagementId,
          analysisType: this.analysisType,
          notes: this.notes,
          relativeSuccessCode: this.relativeSuccessCode,
        ),
      ),
    );
  }
}

class _GI3dmapsPerformance extends StatefulWidget {
  final Map client;
  final int engagementId;
  final int analysisType;
  final String notes;
  final String relativeSuccessCode;

  _GI3dmapsPerformance({
    this.client,
    this.engagementId,
    this.analysisType,
    this.notes,
    this.relativeSuccessCode,
  });

  @override
  _GI3dmapsPerformanceState createState() => new _GI3dmapsPerformanceState();
}

class _GI3dmapsPerformanceState extends State<_GI3dmapsPerformance> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  List<Map> _performanceModalityList;

  @override
  void initState() {
    _performanceModalityList = [
        {
            "id": "analysis",
            "name": "Analysis"
        },
        {
            "id": "support",
            "name": "Support"
        },
        {
            "id": "elevated_lungeleg",
            "name": "Elevated (Lunge Leg)"
        },
        {
            "id": "fixedtrunk",
            "name": "Fixed Trunk"
        },
        {
            "id": "unilateralhandswing",
            "name": "Unilateral Hand Swing"
        },
        {
            "id": "plane_hands",
            "name": "Plane (Hands)"
        },
        {
            "id": "plane_foot",
            "name": "Plane (Foot)"
        },
        {
            "id": "hybrid_hands",
            "name": "Hybrid (Hands)"
        },
        {
            "id": "hybrid_foot",
            "name": "Hybrid (Foot)"
        },
        {
            "id": "pivot_in_chain",
            "name": "Pivot (In-Chain)"
        },
        {
            "id": "pivot_out_of_chain",
            "name": "Pivot (Out-of-Chain)"
        },
        {
            "id": "load",
            "name": "Load"
        },
        {
            "id": "elevated_stanceleg",
            "name": "Elevated (Stance Leg)"
        },
        {
            "id": "locomotor",
            "name": "Locomotor"
        },
        {
            "id": "spherical",
            "name": "Spherical"
        }
    ];
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
              "Performance Modality",             
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
                        mainAxisAlignment: MainAxisAlignment.start,                    
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blueGrey,
                            child: new Text(
                              "Relative Success Code",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blueGrey,
                            child: new Text(
                              widget.relativeSuccessCode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black12,
                            child: new Text(
                              "Select Performance Modality to generate draft workout",                              
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w100,
                              ),
                            )
                          ),
                          new ListView.builder(                  
                            shrinkWrap: true,
                            itemCount: _performanceModalityList.length,
                            itemBuilder: (context, i) {
                              return new Container(
                                child: new GestureDetector(
                                  onTap:() {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new GI3dmapsSummary(
                                          client: widget.client,
                                          engagementId: widget.engagementId,
                                          analysisType: widget.analysisType,
                                          notes: widget.notes,
                                          relativeSuccessCode: widget.relativeSuccessCode,
                                          performanceModality: _performanceModalityList[i]
                                        ),
                                      ),
                                    );
                                  },
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black12
                                        ),
                                      ),
                                    ),
                                    child: new Text(
                                      _performanceModalityList[i]["name"]
                                    )
                                  )
                                )
                              );
                            }
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
