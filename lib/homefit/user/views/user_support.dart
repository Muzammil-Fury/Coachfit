import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/core/app_constants.dart';


class UserSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _UserSupport(),
        )        
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
      _formKey.currentState.save();
      Map _requester = new Map();
      _requester["email"] = _user["email"];
      _requester["name"] = _user["name"];      
      Map ticketParams = new Map();
      ticketParams["requester"] = _requester;
      ticketParams["subject"] = _supportTitle;
      Map commentParams = new Map();
      commentParams["body"] = _supportDetails;
      ticketParams["comment"] =commentParams;
      Map params = new Map();
      params["request"] = ticketParams;
      http.post(
        "https://gomotivehelp.zendesk.com/api/v2/requests.json", 
        body: json.encode(params), 
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        }
      ).then((http.Response response) {          
        Utils.alertDialog(context, "Thank you", "Your support issue has been submitted. We will get in touch with you at the earliest.").then((int response) {
          Navigator.of(context).pop();
        });
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["user"] = store.state.homeFitHomeState.user;
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
                color: dhfYellow,
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
                child: IconButton(
                  icon: Icon(
                    GomotiveIcons.select,
                    color: dhfYellow,
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
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),                 
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          new Container(                            
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: new TextFormField(                                
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
                              maxLines: 8,
                              style: new TextStyle(color: Colors.black87),
                              decoration: InputDecoration(                  
                                labelText: 'Issue Details',
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
