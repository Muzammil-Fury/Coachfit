import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/message/message_network.dart';
import 'package:gomotive/utils/dialog.dart';

class PractitionerEmailAllClients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: _PractitionerEmailAllClients(),
      ),
    );
  }
}

class _PractitionerEmailAllClients extends StatefulWidget {
  @override
  PractitionerEmailAllClientsState createState() => new PractitionerEmailAllClientsState();
}

class PractitionerEmailAllClientsState extends State<_PractitionerEmailAllClients> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  
  String _subject, _body;
  var _messagePracticeAllClientsAPI;

  void _handleSubmitted() async {
    if (_formKey.currentState.validate()) {      
      _formKey.currentState.save();
      Map _params = new Map();
      _params["subject"] = _subject;
      _params["body"] = _body;      
      this._messagePracticeAllClientsAPI(context, _params);
    } 
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _messagePracticeAllClientsAPI = stateObject["messagePracticeAllClients"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["messagePracticeAllClients"] = (BuildContext context, Map params) =>
            store.dispatch(messagePracticeAllClients(context, params));
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
                size: 30.0,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: new Text(
              "Email All Clients",                
              style: TextStyle(
                color: Colors.black87,
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
                    _handleSubmitted();
                  },
                ),                
              ),
            ],
          ),            
          body: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: new Container(                    
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          new Container(                            
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: new TextFormField(                                
                              autofocus: true,
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
                                if(value == "" || value == null) {
                                  return 'Please enter email subject';
                                }
                              },
                              onSaved: (value) {
                                _subject = value;
                              },
                            ),
                          ),
                          new Container(                            
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: new TextFormField(                                
                              autofocus: false,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: new TextStyle(color: Colors.black87),
                              decoration: InputDecoration(                  
                                labelText: 'Body',
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
                                if(value == "" || value == null) {
                                  return 'Please enter email body';
                                }
                              },
                              onSaved: (value) {
                                _body = value;
                              },
                            ),
                          ),
                        ]
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
