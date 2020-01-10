import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/intake/intake_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/message/message_network.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/components/dropdown_form_field.dart';
import 'package:gomotive/core/app_config.dart';

class EngagementIntakeInvite extends StatelessWidget {
  final Map client;
  final int engagementId;
  EngagementIntakeInvite({
    this.client,
    this.engagementId,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _EngagementIntakeInvite(
          client: this.client,
          engagementId: this.engagementId,
        ),
      ),
    );
  }
}

class _EngagementIntakeInvite extends StatefulWidget {
  final Map client;
  final int engagementId;
  _EngagementIntakeInvite({
    this.client,
    this.engagementId
  });
  @override
  _EngagementIntakeInviteState createState() => new _EngagementIntakeInviteState();
}

class _EngagementIntakeInviteState extends State<_EngagementIntakeInvite> {  
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getCannedMessageAPI, _getIntakeListAPI, _assignIntakeFormAPI;
  List<Map> _intakeList;
  Map _cannedMessage;
  String _email, _subject, _intakeId;

  _sendIntakeForm() {
    if (_formKey.currentState.validate()) {      
      _formKey.currentState.save();
      Map params = new Map();
      params["engagement_id"] = widget.engagementId;
      params["subject"] = _subject;
      params["body"] = _cannedMessage["body"];
      params["intake_form"] = _intakeId;
      _assignIntakeFormAPI(context, params);
      Navigator.of(context).pop();
    } else {
      CustomDialog.alertDialog(context, "Error", "Kindly fix errors before inviting your client");
    }
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getCannedMessageAPI = stateObject["getCannedMessage"];        
        _getIntakeListAPI = stateObject["getIntakeList"];
        _assignIntakeFormAPI = stateObject["assignIntakeForm"];
        Map params = new Map();
        params["message_type"] = 7;
        _getCannedMessageAPI(context, params);
        Map params2 = new Map();
        params2["fetch_type"] = "practitioner_assign";
        params2["form_type"] = 1;
        _getIntakeListAPI(context, params2);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getCannedMessage"] = (BuildContext context, Map params) =>
            store.dispatch(getCannedMessage(context, params)); 
        returnObject["getIntakeList"] = (BuildContext context, Map params) =>
            store.dispatch(getIntakeList(context, params)); 
        returnObject["assignIntakeForm"] = (BuildContext context, Map params) =>
            store.dispatch(assignIntakeForm(context, params)); 
        returnObject["cannedMessage"] = store.state.messageState.cannedMessageObj;                 
        returnObject["intakeList"] = store.state.intakeState.eformList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _cannedMessage = stateObject["cannedMessage"];
        _intakeList = stateObject["intakeList"];
        if(_cannedMessage != null && _intakeList != null) {
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(  
              backgroundColor: Colors.white,
              title: new Text(
                'Intake Form',             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),    
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
              actions: <Widget>[                 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: FlatButton(
                    color: primaryColor,                                
                    child: new Text(
                      'Send',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () { 
                      _sendIntakeForm();                     
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
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 8, 0),              
                              child: new DropdownFormField(
                                labelKey: "name",
                                valueKey: "id",
                                initialValue: _intakeId,
                                decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  labelText: 'Select Intake List',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                options: _intakeList,
                                autovalidate: true,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select intake form';
                                  } else {
                                    _intakeId = value;
                                  }
                                },                                
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                              child: new TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                style: new TextStyle(color: Colors.black87),
                                enabled: false,
                                initialValue: widget.client["email"],
                                decoration: InputDecoration(                                  
                                  labelText: 'Client Email Address',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter email address';
                                  }
                                },
                                onSaved: (value) {
                                  this._email = value;
                                },
                              ),
                            ),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: new TextFormField(
                                autofocus: false,
                                initialValue: _cannedMessage["subject"],
                                maxLines: 2,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                                  
                                  labelText: 'Subject',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter message subject';
                                  }
                                },
                                onSaved: (value) {
                                  this._subject = value;
                                },
                              ),
                            ),  
                            new Container(
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        child: new Text(
                                          'Body',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          )
                                        ),
                                      ),
                                      // new Container(
                                      //   child: new IconButton(
                                      //     icon: Icon(
                                      //       GomotiveIcons.edit,
                                      //       size: 20.0, 
                                      //       color: primaryColor
                                      //     ),
                                      //     onPressed: () {
                                      //       // Navigator.push(
                                      //       //   context,
                                      //       //   new MaterialPageRoute(
                                      //       //     builder: (context) => new MessageBodyEdit(
                                      //       //       title: "Invite Client Body",
                                      //       //       body: _cannedMessage["body"]                            
                                      //       //     ),
                                      //       //   ),
                                      //       // );
                                      //     },
                                      //   ),                                        
                                      // )
                                    ],
                                  ),                                  
                                  new Html(
                                    padding: EdgeInsets.all(8.0),
                                    data: _cannedMessage["body"]
                                  ),
                                ],
                              )
                            )                                                      
                          ],
                        )
                      ),
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
