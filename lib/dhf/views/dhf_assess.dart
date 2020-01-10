import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/dhf/dhf_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/education/views/education_content_view.dart';
import 'package:gomotive/core/app_config.dart';

class DHFAssessment extends StatelessWidget {
  final int clientId;
  final String movementMeterType;
  DHFAssessment({
    this.clientId,
    this.movementMeterType
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _DHFAssessment(
          clientId: this.clientId,
          movementMeterType: this.movementMeterType,
        ),
      ),
    );
  }
}

class _DHFAssessment extends StatefulWidget {
  final int clientId;
  final String movementMeterType;
  _DHFAssessment({
    this.clientId,
    this.movementMeterType
  });
  
  @override
  _DHFAssessmentState createState() => new _DHFAssessmentState();
}

class _DHFAssessmentState extends State<_DHFAssessment> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getDHFAssessmentAPI, _saveDHFAssesmentAPI;
  Map _assessment;
  
  List<Widget> _listAssessmentDetails() {
    List<Widget> _list = new List<Widget>();
    if(_assessment != null) {
      for(int i=0; i<_assessment["sections"].length; i++) {
        Container _assessmentType = new Container(
          width: MediaQuery.of(context).size.width,   
          decoration: BoxDecoration(
            color: Colors.blueGrey
          ),      
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),                 
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                _assessment["sections"][i]["name"],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                )
              ),
              new Switch(
                value: _assessment["sections"][i]["assessed"],
                activeColor: Colors.green,
                onChanged: (bool value) {    
                  if(value) {
                    setState(() {
                      _assessment["sections"][i]["assessed"] = true;                  
                    });                  
                  } else {
                    setState(() {
                      _assessment["sections"][i]["assessed"] = false;                  
                    });
                  }                               
                },               
              )
            ],
          )          
        );
        _list.add(_assessmentType);
        if(_assessment["sections"][i]["assessed"]) {
          for(int j=0;j<_assessment["sections"][i]["questions"].length;j++) {            
            Container _assessmentQuestion = new Container(
              width: MediaQuery.of(context).size.width,                           
              child: new Container(                 
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: new Text(
                  _assessment["sections"][i]["questions"][j]["name"],
                  textAlign: TextAlign.left,
                  style: TextStyle(  
                    fontSize: 12.0,                                  
                  ),
                )
              ),
            );
            _list.add(_assessmentQuestion);
            if(_assessment["sections"][i]["questions"][j]["measure"] == "boolean"){
              Container _assessmentQuestionOptions = new Container(            
                child: RadioButtonGroup(
                  activeColor: primaryColor,
                  orientation: GroupedButtonsOrientation.VERTICAL,
                  labels: <String>[
                    "Yes",
                    "No",
                  ],
                  onSelected: (String selected) => {
                    selected == "yes" 
                    ? _assessment["sections"][i]["questions"][j]["value"] = true  
                    : _assessment["sections"][i]["questions"][j]["value"] = false                  
                  }
                ),                                         
              );
              _list.add(_assessmentQuestionOptions);
            } else {
              Container _assessmentNumberOption = new Container(    
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),        
                child: new TextField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  style: new TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    _assessment["sections"][i]["questions"][j]["value"] = value;
                  },                  
                ),
              );
              _list.add(_assessmentNumberOption);
            }
            Container _helpContainer = new Container(              
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    child: new IconButton(                  
                      icon: Icon(
                        Icons.help_outline,
                        size: 24.0,
                        color: Colors.green,
                      ),
                      onPressed: () { 
                        if(_assessment["sections"][i]["questions"][j]["description"] != null) { 
                          CustomDialog.alertDialog(context, "Description", _assessment["sections"][i]["questions"][j]["description"]);
                        } else {
                          CustomDialog.alertDialog(context, "Description", "Description has not been defined for this assessment");
                        }
                      },
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    child: new IconButton(                  
                      icon: Icon(
                        GomotiveIcons.play,
                        size: 24.0,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        if(_assessment["sections"][i]["questions"][j]["video_url"] != null) { 
                          Map _params = new Map();
                          _params["name"] = "Video Tutorial";
                          _params["video_url"] = _assessment["sections"][i]["questions"][j]["video_url"];
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new EducationContentView(
                                content: _params,
                              ),
                            ),
                          );                          
                        } else {
                          CustomDialog.alertDialog(context, "Video Tutorial", "Video tutorial has not been defined for this assessment");
                        }                    
                      },
                    )
                  ),
                ],
              )
            );
            _list.add(_helpContainer);
            Container _requiredContainer = new Container(
              width: MediaQuery.of(context).size.width,   
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(
                    color: _assessment["sections"][i]["questions"][j].containsKey("required") && _assessment["sections"][i]["questions"][j]["required"] == true ? Colors.red : Colors.black12,
                  ),
                ),                              
              ),                
              child: 
                _assessment["sections"][i]["questions"][j].containsKey("required") && _assessment["sections"][i]["questions"][j]["required"] == true 
                ? new Text(
                    _assessment["sections"][i]["questions"][j]["required_text"],
                    style: TextStyle(
                      color: Colors.red,
                    )
                  )
                : new Container(),
            );
            _list.add(_requiredContainer);            
          }
          List<Map> _gamePlanTemplates = Utils.parseList(_assessment["sections"][i], "game_plan_templates");
          Container _gameplanTemplateContainer = new Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
            child: new DropdownFormField(
              labelKey: "name",
              valueKey: "id",  
              initialValue: _assessment["sections"][i]["selected_game_plan"].toString(),                            
              decoration: InputDecoration(
                labelText: "Select Game Plan Template",
                border: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                    color: Colors.black87,
                  ),
                ),
              ),
              autovalidate: true,
              options: _gamePlanTemplates,
              validator: (value) {
                _assessment["sections"][i]["selected_game_plan"] = value;
              },        
            ),
          );
          _list.add(_gameplanTemplateContainer);
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
        _getDHFAssessmentAPI = stateObject["getAssessment"];
        _saveDHFAssesmentAPI = stateObject["saveAssessment"];
        _getDHFAssessmentAPI(context, {});   
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();   
        returnObject["getAssessment"] = (BuildContext context, Map params) =>
            store.dispatch(getAssessment(context, params));         
        returnObject["saveAssessment"] = (BuildContext context, Map params) =>
            store.dispatch(saveAssessment(context, params));         
        returnObject["assessment"] = store.state.dhfState.assessment;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        List<Map> _allAssessment = stateObject["assessment"];
        if(_allAssessment != null) {
          for(int i=0; i<_allAssessment.length; i++) {
            if(_allAssessment[i]["id"].toString().toUpperCase() == widget.movementMeterType.toUpperCase()) {
              _assessment = _allAssessment[i];
            }
          }        
        }
        return new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(                  
              icon: Icon(
                GomotiveIcons.back,
                size: 40.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            title: new Text(
              _assessment != null ? _assessment["name"] : "",             
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black87
              )   
            ),              
            actions: <Widget>[
              new Container(
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                child: FlatButton(
                  color: primaryColor,                                
                  child: new Text(
                    'Submit',
                    style: TextStyle(
                      color: primaryTextColor
                    )
                  ),
                  onPressed: () {
                    bool validated = true;    
                    for(int i=0; i<_assessment["sections"].length; i++) {
                      if(_assessment["sections"][i]["assessed"] == true) {
                        for(int j=0;j<_assessment["sections"][i]["questions"].length;j++){
                          if(_assessment["sections"][i]["questions"][j]["measure"] == "boolean") {
                            if(_assessment["sections"][i]["questions"][j]["value"] == null) {
                              validated = false;
                              setState(() {
                                _assessment["sections"][i]["questions"][j]["required"] = true;
                                _assessment["sections"][i]["questions"][j]["required_text"] = "Required";
                              });                            
                            } else {
                              setState(() {
                                _assessment["sections"][i]["questions"][j]["required"] = false;
                              });
                            }
                          } else if(_assessment["sections"][i]["questions"][j]["measure"] == "number") {
                            int minValue, maxValue, currentValue;
                            if(_assessment["sections"][i]["questions"][j]["value"] != null) {
                              currentValue = int.parse(_assessment["sections"][i]["questions"][j]["value"]); 
                            }
                            if(_assessment["sections"][i]["questions"][j].containsKey("min_value")) {
                              minValue = _assessment["sections"][i]["questions"][j]["min_value"];
                            }
                            if(_assessment["sections"][i]["questions"][j].containsKey("max_value")) {
                              maxValue = _assessment["sections"][i]["questions"][j]["max_value"];
                            }                            
                            if(currentValue == null) {
                              validated = false;
                              setState(() {
                                _assessment["sections"][i]["questions"][j]["required"] = true;
                                _assessment["sections"][i]["questions"][j]["required_text"] = "Required";
                              });                              
                            } else {
                              if(minValue != null) {
                                if(currentValue < minValue) {
                                  validated = false;
                                  setState(() {
                                    _assessment["sections"][i]["questions"][j]["required"] = true;
                                    _assessment["sections"][i]["questions"][j]["required_text"] = "Value must be more than " + minValue.toString();
                                  });                                  
                                } else {
                                  setState(() {
                                    _assessment["sections"][i]["questions"][j]["required"] = false;                                    
                                  });
                                }
                              }
                              if(maxValue != null) {
                                if(currentValue > maxValue) {
                                  validated = false;
                                  setState(() {
                                    _assessment["sections"][i]["questions"][j]["required"] = true;
                                    _assessment["sections"][i]["questions"][j]["required_text"] = "Value must be less than " + maxValue.toString();
                                  });                                  
                                } else {
                                  setState(() {
                                    _assessment["sections"][i]["questions"][j]["required"] = false;                                    
                                  });
                                }
                              }
                            } 
                          } else if(_assessment["sections"][i]["questions"][j]["measure"] == "seconds" || _assessment["sections"][i]["questions"][j]["measure"] == "millisecond") {
                            int currentValue;
                            if(_assessment["sections"][i]["questions"][j]["value"] != null) {
                              currentValue = int.parse(_assessment["sections"][i]["questions"][j]["value"]);                             
                            }
                            if(currentValue == null) {
                              validated = false;
                              _assessment["sections"][i]["questions"][j]["required"] = true;
                              _assessment["sections"][i]["questions"][j]["required_text"] = "Required";
                            } else {
                              _assessment["sections"][i]["questions"][j]["required"] = false;
                            } 
                          }
                        }
                      }
                    } 
                    if(!validated){
                      CustomDialog.alertDialog(context, "Required fields", "Populate all the required fields and submit once again");
                    } else {
                      _assessment["assessed"] = true;
                      Map params = new Map();
                      params["client"] = widget.clientId;
                      params["assessments"] = [_assessment];
                      _saveDHFAssesmentAPI(context, params);
                    }                                         
                  },
                ),                
              ),
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 64),
                    child: new Column(
                      children: _listAssessmentDetails()
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
