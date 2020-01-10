import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/message/message_network.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/core/app_config.dart';

class PractitionerClientInvite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _PractitionerClientInvite(),
      ),
    );
  }
}

class _PractitionerClientInvite extends StatefulWidget {
  @override
  _PractitionerClientInviteState createState() => new _PractitionerClientInviteState();
}

class _PractitionerClientInviteState extends State<_PractitionerClientInvite> {  
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _getCannedMessageAPI, _inviteClientAPI;
  Map _cannedMessage;
  String _email, _subject;

  _inviteClient() {
    if (_formKey.currentState.validate()) {      
      _formKey.currentState.save();
      Map params = new Map();
      params["invite_type"] = "0";
      params["subject"] = _subject;
      params["body"] = _cannedMessage["body"];
      params["email"] = _email;
      _inviteClientAPI(context, params);
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
        _inviteClientAPI = stateObject["inviteClient"];
        Map params = new Map();
        params["message_type"] = 2;
        _getCannedMessageAPI(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getCannedMessage"] = (BuildContext context, Map params) =>
            store.dispatch(getCannedMessage(context, params));   
        returnObject["inviteClient"] = (BuildContext context, Map params) =>
            store.dispatch(inviteClient(context, params));
        returnObject["cannedMessage"] = store.state.messageState.cannedMessageObj;                 
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _cannedMessage = stateObject["cannedMessage"];
        if(_cannedMessage != null) {
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(  
              backgroundColor: Colors.white,
              title: new Text(
                'Invite Client',             
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
                      'Invite',
                      style: TextStyle(
                        color: primaryTextColor
                      )
                    ),
                    onPressed: () { 
                      _inviteClient();                     
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
                              padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                              child: new TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                style: new TextStyle(color: Colors.black87),
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
