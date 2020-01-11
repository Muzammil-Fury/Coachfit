import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/utils/utils.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/utils/gomotive_icons.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/user/user_network.dart';


class UserChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _UserChangePassword(),
        )        
      ),
    );
  }
}

class _UserChangePassword extends StatefulWidget {
  @override
  UserChangePasswordState createState() => new UserChangePasswordState();
}

class UserChangePasswordState extends State<_UserChangePassword> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _password, _newPassword, _confirmNewPassword;
  var _changePasswordAPI;

  void _handleSubmitted() {
    if (_formKey.currentState.validate()) {
      if(_newPassword != _confirmNewPassword) {
        Utils.showInSnackBar(
          _scaffoldKey, "Passwords dont match");
      }
      _formKey.currentState.save();
      Utils.alertDialog(context, "Sign in requried", "Kindly note that you will be asked to sign in again after updating your password").then((response) {
        Map params = Map();
        params["current_password"] = _password;
        params["new_password"] = _newPassword;
        _changePasswordAPI(context, params);
      });      
    } else {
      Utils.showInSnackBar(
        _scaffoldKey, 
        "Please fix the errors in red before submitting."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _changePasswordAPI = stateObject["changePassword"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["changePassword"] = (BuildContext context, Map params) =>
            store.dispatch(changePassword(context, params));
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
                color: dhfYellow,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: new Text(
              "Change Password",                
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
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0
                            ),
                            child: new TextFormField(
                              autofocus: false,
                              obscureText: true,
                              style: new TextStyle(
                                color: Colors.black87
                              ),
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                labelStyle: new TextStyle(color: Colors.black87),
                                border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                    color: Colors.black12
                                  )
                                )
                              ),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please enter your current password';
                                }
                              },
                              onSaved: (value) {
                                _password = value;
                              },
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0
                            ),
                            child: new TextFormField(
                              autofocus: false,
                              obscureText: true,
                              style: new TextStyle(
                                color: Colors.black87
                              ),
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: new TextStyle(
                                  color: Colors.black87
                                ),
                                border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                    color: Colors.black12
                                  )
                                )
                              ),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please enter your new password';
                                }
                              },
                              onSaved: (value) {
                                _newPassword = value;
                              },
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0
                            ),
                            child: new TextFormField(                          
                              autofocus: false,
                              obscureText: true,
                              style: new TextStyle(
                                color: Colors.black87
                              ),
                              decoration: InputDecoration(
                                labelText: 'Confirm new password',
                                labelStyle: new TextStyle(
                                  color: Colors.black87
                                ),
                                border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                    color: Colors.black12
                                  )
                                )
                              ),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'Please confirm your new password';
                                }
                              },
                              onSaved: (value) {
                                _confirmNewPassword = value;
                              },
                            ),
                          ),
                          // new Container(
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 8.0, horizontal: 24.0
                          //   ),
                          //   child: new FlatButton(
                          //     color: primaryColor,
                          //     child: new Text(
                          //       'Change Password',
                          //       style: TextStyle(
                          //         color: primaryTextColor
                          //       )
                          //     ),
                          //     onPressed: _handleSubmitted,
                          //   ),
                          // ),
                        ],
                      ),
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
