import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/auth/auth_network.dart';
import 'package:gomotive/core/app_config.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new _ForgotPassword(),
      ),
    );
  }
}

class _ForgotPassword extends StatefulWidget {
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<_ForgotPassword> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  var _forgotPasswordAPI;

  String _email;

  _forgotPassword() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = Map();
      params["email"] = _email;      
      _forgotPasswordAPI(context, params);
    }
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _forgotPasswordAPI = stateObject["forgotPassword"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["forgotPassword"] = (BuildContext context, Map params) =>
            store.dispatch(forgotPassword(context, params));
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
              'Forgot Password?',             
              style: TextStyle(
                color: Colors.black87
              )   
            ),              
            actions: <Widget>[
              new Container(
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
                    _forgotPassword();                     
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[ 
                          new Container(    
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Container(                                  
                              child: new Text(
                                "Enter your registered email address and we will send you details to sign in to the App.",
                                textAlign: TextAlign.center,
                                style: TextStyle(  
                                  color: Colors.white,                                  
                                ),
                              )
                            ),                              
                          ),
                          new Container(                            
                            padding: EdgeInsets.fromLTRB(8, 24, 8, 8),
                            child: new TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autofocus: false,
                              style: new TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                icon: new Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                                labelText: 'Email Address',
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
                        ]
                      )
                    )
                  ),
                )
              );
            }
          )
        );
      }
    );
  }
}

