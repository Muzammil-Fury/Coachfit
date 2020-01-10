import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/core/app_config.dart';

class UserSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: _UserSupport(),
      ),
    );
  }
}

class _UserSupport extends StatefulWidget {
  @override
  UserSupportState createState() => new UserSupportState();
}

class UserSupportState extends State<_UserSupport> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  
  String _supportTitle, _supportDetails;
  Map _user;

  void _handleSubmitted() async {
    if (_formKey.currentState.validate()) {
      String authToken = Utils.base64Encode(_user["email"]+"/token:Rq2oWyntxPBPIEOgj2sVrO8EctdneuIhTU1BF1hx");
      _formKey.currentState.save();
      Map ticketParams = new Map();
      ticketParams["subject"] = _supportTitle;
      Map commentParams = new Map();
      commentParams["body"] = _supportDetails;
      ticketParams["comment"] =commentParams;
      Map params = new Map();
      params["ticket"] = ticketParams;
      http.post(
        "https://gomotivehelp.zendesk.com/api/v2/tickets.json", 
        body: json.encode(params), 
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': "Basic " + authToken
        }
      ).then((http.Response response) {
        CustomDialog.alertDialog(context, "Thank you", "Your support issue has been submitted. We will get in touch with you at the earliest.").then((int response) {
          Navigator.of(context).pop();
        });
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["user"] = store.state.authState.user;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _user = stateObject["user"];  
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
              "Support",                
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
                                  return 'Please enter subject';
                                }
                              },
                              onSaved: (value) {
                                _supportTitle = value;
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
                                labelText: 'Details',
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
                                  return 'Please enter details';
                                }
                              },
                              onSaved: (value) {
                                _supportDetails = value;
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
