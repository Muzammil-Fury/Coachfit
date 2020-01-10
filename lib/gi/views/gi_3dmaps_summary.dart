import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/components/avatar.dart';
import 'package:gomotive/gi/gi_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class GI3dmapsSummary extends StatelessWidget {
  final Map client;
  final int engagementId;
  final int analysisType;
  final String notes;
  final String relativeSuccessCode;
  final Map performanceModality;

  GI3dmapsSummary({
    this.client,
    this.engagementId,
    this.analysisType,
    this.notes,
    this.relativeSuccessCode,
    this.performanceModality,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _GI3dmapsSummary(
          client: this.client,
          engagementId: this.engagementId,
          analysisType: this.analysisType,
          notes: this.notes,
          relativeSuccessCode: this.relativeSuccessCode,
          performanceModality: this.performanceModality
        ),
      ),
    );
  }
}

class _GI3dmapsSummary extends StatefulWidget {
  final Map client;
  final int engagementId;
  final int analysisType;
  final String notes;
  final String relativeSuccessCode;
  final Map performanceModality;

  _GI3dmapsSummary({
    this.client,
    this.engagementId,
    this.analysisType,
    this.notes,
    this.relativeSuccessCode,
    this.performanceModality,
  });

  @override
  _GI3dmapsSummaryState createState() => new _GI3dmapsSummaryState();
}

class _GI3dmapsSummaryState extends State<_GI3dmapsSummary> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _analysisType;
  TextEditingController _notesController = new TextEditingController();

  var _generateDraftWorkout;
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _generateDraftWorkout = stateObject["generateDraftWorkout"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["generateDraftWorkout"] = (BuildContext context, Map params) =>
            store.dispatch(generateDraftWorkout(context, params));
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _analysisType = widget.analysisType.toString();
        _notesController.text = widget.notes;
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
              "Assessment Summary",             
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
                    child: new Column(                      
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black12,
                          child: new Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                child: new Center (
                                  child: new Avatar(
                                    url: widget.client["avatar_url_tb"],
                                    name: widget.client["name"],
                                    maxRadius: 24,
                                  ),
                                )
                              ),
                              new Container(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      child: new Text(
                                        widget.client["name"]
                                      )
                                    ),
                                    new Container(
                                      child: new Text(
                                        widget.client["email"],
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w100
                                        )
                                      )
                                    )
                                  ],
                                )
                              )
                            ],
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blueGrey,
                          child: new Text(
                            "Relative Success Code",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            )
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: new Text(
                            widget.relativeSuccessCode
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blueGrey,
                          child: new Text(
                            "Performance Modality",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            
                            )
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: new Text(
                            widget.performanceModality["name"]
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blueGrey,
                          child: new Text(
                            "Analysis Type",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            
                            )
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          child: new DropdownFormField(                            
                            initialValue: _analysisType,        
                            decoration: InputDecoration(
                              border: new UnderlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            autovalidate: true,
                            options: [
                              {
                                "label": "Mobility Analysis",
                                "value": "1"
                              },
                              {
                                "label": "Stability Analysis",
                                "value": "2"
                              },
                              {
                                "label": "Mostability Analysis",
                                "value": "3"
                              },
                            ],
                            validator: (value) {   
                              _analysisType = value;                               
                            },        
                          ),
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blueGrey,
                          child: new Text(
                            "Notes",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            
                            )
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: new TextField(
                            controller: _notesController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(                                          
                                borderSide: const BorderSide(
                                  color: Colors.black87
                                ),                                          
                              ),
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Enter Notes",
                            ),
                          )
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          child: new FlatButton(
                            color: primaryColor,                                
                            child: new Text(
                              'Generate Draft Workout',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 13.5,
                              )
                            ),
                            onPressed: () {  
                              Map params = new Map();
                              params['client_id'] = widget.client["id"];
                              if(_analysisType == "1") {
                                params['analysis_type'] = "mobility";
                              } else if(_analysisType == "2") {
                                params['analysis_type'] = "stability";
                              } else if(_analysisType == "3") {
                                params['analysis_type'] = "mostability";
                              }
                              params['rsc'] = widget.relativeSuccessCode;
                              params['performance_modality'] = widget.performanceModality["id"];
                              this._generateDraftWorkout(context, params);
                            },
                          ),
                        )
                      ],
                    )                    
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
