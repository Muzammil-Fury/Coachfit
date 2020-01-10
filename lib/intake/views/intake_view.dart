import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/components/multiselect.dart';
import 'package:gomotive/utils/utils.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:gomotive/core/app_config.dart';

class IntakeView extends StatelessWidget {
  final int engagementId;
  final bool enableSubmit;
  final int intakeFormId;
  final String formName;
  final List<Map> formFields;
  IntakeView({
    this.engagementId,
    this.enableSubmit,
    this.intakeFormId,
    this.formName,
    this.formFields
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _IntakeView(
          engagementId: this.engagementId,
          enableSubmit: this.enableSubmit,
          intakeFormId: this.intakeFormId,
          formName: this.formName,
          formFields: this.formFields,
        ),
      ),
    );
  }
}

class _IntakeView extends StatefulWidget {
  final int engagementId;
  final bool enableSubmit;
  final int intakeFormId;
  final String formName;
  final List<Map> formFields;
  _IntakeView({
    this.engagementId,
    this.enableSubmit,
    this.intakeFormId,
    this.formName,
    this.formFields
  });

  
  @override
  _IntakeViewState createState() => new _IntakeViewState();
}

class _IntakeViewState extends State<_IntakeView> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _submitIntakeFormAPI;
  Map<String, TextEditingController> _dateController = new Map<String, TextEditingController>();

  Future _chooseDate(BuildContext context, String fieldGuid, int i) async {    
    var result = await showDatePicker(
      context: context,
      firstDate: new DateTime(1970, 1, 1),
      initialDate: new DateTime.now(),
      lastDate: new DateTime(2100,1,1),
    );

    if (result == null) return;

    setState(() {
      widget.formFields[i]["value"] =  new DateFormat.yMMMMd().format(result);         
    });
  }


  List<Widget> _listFormFields() {
    List<Widget> _list = new List<Widget>();
    for(int i=0; i<widget.formFields.length;i++) { 
      if(widget.formFields[i]["field_type"] == 5) {
        _dateController[widget.formFields[i]["field_guid"]] = new TextEditingController();
        if(widget.formFields[i]["value"] != "") {
          _dateController[widget.formFields[i]["field_guid"]].text = widget.formFields[i]["value"];            
        }
      }      
      Container _fieldContainer;
      if(widget.formFields[i]["field_type"] == 99) {
        _fieldContainer = new Container(         
          child: new Column(
            children: <Widget>[
              new Container(
                width: MediaQuery.of(context).size.width, 
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),                   
                decoration: BoxDecoration(
                  color: Colors.blueGrey
                ),                
                child: new Text(
                  widget.formFields[i]["name"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                )
              ),
              widget.formFields[i]["note"] != null && widget.formFields[i]["note"] != ""
              ? new Container(
                  width: MediaQuery.of(context).size.width, 
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),                   
                  decoration: BoxDecoration(
                    color: Colors.black12
                  ),                
                  child: new Text(
                    widget.formFields[i]["note"],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                    ),
                    textAlign: TextAlign.center,
                  )
                )
              : new Container(),
            ],
          )                                           
        );
      } else {
        _fieldContainer = new Container(
          width: MediaQuery.of(context).size.width,  
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),                   
          child: new Column(
            children: <Widget>[
              widget.formFields[i]["field_type"] == 1              
              ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        widget.formFields[i]["name"],
                        textAlign: TextAlign.left,
                      )
                    ),
                    new Container(
                      child: new TextFormField(                    
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        initialValue: widget.formFields[i]["value"],
                        style: new TextStyle(color: Colors.black87),
                        decoration: InputDecoration(                                            
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if(widget.formFields[i]["is_required"] && value.trim().isEmpty) {
                            return 'Please enter ' + widget.formFields[i]["name"];
                          }
                        },
                        onSaved: (value) {
                          widget.formFields[i]["value"] = value;
                        },
                      ),
                    )
                  ],
                )                
              : new Container(),
              widget.formFields[i]["field_type"] == 2
              ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        widget.formFields[i]["name"],
                        textAlign: TextAlign.left,
                      )
                    ),
                    new Container(
                      child: new TextFormField(                    
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        initialValue: widget.formFields[i]["value"],
                        style: new TextStyle(color: Colors.black87),
                        decoration: InputDecoration(                          
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if(widget.formFields[i]["is_required"] && value.trim().isEmpty) {
                            return 'Please enter ' + widget.formFields[i]["name"];
                          }
                        },
                        onSaved: (value) {
                          widget.formFields[i]["value"] = value;
                        },
                      ),
                    )
                  ]
                )
              : new Container(),
              widget.formFields[i]["field_type"] == 14 || widget.formFields[i]["field_type"] == 3             
              ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        widget.formFields[i]["name"],
                        textAlign: TextAlign.left,
                      )
                    ),
                    new Container(
                      child: new DropdownFormField(                                            
                        initialValue: widget.formFields[i]["value"] == '' ? null : widget.formFields[i]["value"],
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),                      
                        ),
                        options: Utils.parseList(widget.formFields[i],"field_choices"),
                        autovalidate: true,
                        validator: (value) {
                          if(widget.formFields[i]["is_required"]) {
                            if(value == null || value == '') {
                              return 'Please select a value';
                            } else {
                              widget.formFields[i]["value"] = value;
                            }
                          } else {
                            if(value != null && value != "") {
                              widget.formFields[i]["value"] = value;
                            }
                          }
                        },                        
                      ),            
                    )
                  ]
                )
              : new Container(),
              widget.formFields[i]["field_type"] == 4
              ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        widget.formFields[i]["name"],
                        textAlign: TextAlign.left,
                      )
                    ),
                    new Container(
                      child: new MultiSelect(  
                        context: context,                  
                        autovalidate: true,
                        enabled: true,                           
                        decoration: InputDecoration(
                          border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.black87,
                            ),
                          ),                      
                        ),                        
                        optionList: Utils.parseList(widget.formFields[i],"field_choices"),
                        initialValue: widget.formFields[i]["value"] == '' || widget.formFields[i]["value"] == null ? new List<String>() : widget.formFields[i]["value"],
                        validator: (value) {
                          if(widget.formFields[i]["is_required"]) {
                            if(value.length == 0) {
                              return 'Please select values';
                            } else {
                              if(widget.formFields[i]["value"] == '' || widget.formFields[i]["value"] == null) {
                                widget.formFields[i]["value"] = new List<String>();
                              } else {                                                             
                                widget.formFields[i]["value"] = value;
                              }                              
                            }
                          } else {
                            if(widget.formFields[i]["value"] == '' || widget.formFields[i]["value"] == null) {
                              widget.formFields[i]["value"] = new List<String>();
                            } else {                              
                              widget.formFields[i]["value"] = widget.formFields[i]["value"];
                            }
                          }
                        },                         
                      ),            
                    )
                  ]
                )
              : new Container(),
              widget.formFields[i]["field_type"] == 5 
              ? new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        widget.formFields[i]["name"],
                        textAlign: TextAlign.left,
                      )
                    ),
                    new Container(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new TextFormField(
                              decoration: new InputDecoration(                                
                                border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              controller: _dateController[widget.formFields[i]["field_guid"]],
                              // controller: _controller,
                              keyboardType: TextInputType.datetime,
                              validator: (value) { 
                                if(value == "" || value == null) {
                                  return 'Please select ' + widget.formFields[i]["name"];
                                }
                              },
                              onSaved: (value) { 
                                widget.formFields[i]["value"] = _dateController[widget.formFields[i]["field_guid"]].text;
                              },
                            )
                          ),
                          new Container(                                  
                            child: new IconButton(
                              icon: new Icon(Icons.calendar_today),
                              tooltip: 'Choose date',
                              onPressed: (() {
                                _chooseDate(context, widget.formFields[i]["field_guid"], i);
                              }),
                            )
                          )
                        ]
                      ),             
                    )
                  ]
                )
              : new Container(),
              widget.formFields[i]["show_additional_field"] == true
              ? new Container(
                  child: new TextFormField(                    
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,                    
                    initialValue: widget.formFields[i]["additional_value"],
                    style: new TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Enter any additional info", 
                      hintStyle: new TextStyle(
                        fontSize: 12
                      ),                     
                      border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                    ),                    
                    onSaved: (value) {
                      widget.formFields[i]["additional_value"] = value;
                    },
                  ),
                )
              : new Container(),
            ],
          )
          
        );
      }
      _list.add(_fieldContainer);
    }
    return _list;
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {     
        _submitIntakeFormAPI = stateObject["submitIntakeForm"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();      
        returnObject["submitIntakeForm"] = (BuildContext context, Map params) =>
            store.dispatch(submitIntakeForm(context, params));  
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
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
                Navigator.of(context).pop();
              },
            ),
            title: new Text(
              widget.formName,             
              style: TextStyle(
                color: Colors.black87
              )   
            ),              
            actions: <Widget>[
              widget.enableSubmit
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      'Submit',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () { 
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Map _params = new Map();
                        _params["id"] = widget.intakeFormId;
                        _params["engagement"] = widget.engagementId;
                        _params["form"] = widget.formFields;
                        _submitIntakeFormAPI(context, _params);
                        Navigator.of(context).pop();
                      }
                    },
                  ),                
                )
              : new Container(),                
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 32),  
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: _listFormFields(),
                      )
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
