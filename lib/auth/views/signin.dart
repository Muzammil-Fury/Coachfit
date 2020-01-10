import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gomotive/components/text_tap.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/auth/auth_network.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/core/app_constants.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _SignIn(),
      ),
    );
  }
}

class _SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<_SignIn> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email = "";
  String _password = "";
  bool _acceptTerms = false;

  var _loginApi, _getPartnerDetailsApi;
  Map _businessPartner;


  void _handleSubmitted() {
    if (_formKey.currentState.validate()) {
      if (!_acceptTerms) {
        Utils.showInSnackBar(_scaffoldKey,
            "Please accept user agreement and privacy policy before submitting.");
        return;
      } else {
        _formKey.currentState.save();
        Map params = Map();
        params["email"] = _email;
        params["password"] = _password;
        params["notification_token"] = notificationStr;        
        _loginApi(context, params);
      }
    } else {
      Utils.showInSnackBar(
          _scaffoldKey, "Please fix the errors in red before submitting.");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _loginApi = stateObject["loginAPI"];        
        _getPartnerDetailsApi = stateObject["partnerDetailsAPI"];
        var params = new Map();
        params["subdomain"] = partnerSubdomain;
        _getPartnerDetailsApi(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["partnerDetailsAPI"] = (BuildContext context, Map params) =>
            store.dispatch(getPartnerDetails(context, params));
        returnObject["loginAPI"] = (BuildContext context, Map params) =>
            store.dispatch(login(context, params));
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _businessPartner = stateObject["businessPartner"];    
        if(_businessPartner != null) {
          String _privacyPolicyURL = baseURL + "site_media/static/files/privacy_policy.pdf";
          String _userAgreementURL = baseURL + "terms_of_use";
          return new Scaffold(
            key: _scaffoldKey,
            body: new LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: new Container(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: new Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[                            
                            partnerAppType == "gi" ?
                              new Container(
                                width: 300.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new AssetImage(
                                      'assets/images/logo_big.png', 
                                    ),
                                  ),
                                )
                              )
                            : new Container(),
                            partnerAppType == "dhf" ?
                              new Container(
                                width: 300.0,
                                height: 80.0,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: new AssetImage(
                                      'assets/images/logo_big.png', 
                                    ),
                                  ),
                                )
                              )
                            : new Container(),
                            new Container(                            
                              padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
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
                            new Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0, 
                                horizontal: 24.0
                              ),
                              child: new TextFormField(
                                autofocus: false,
                                obscureText: true,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  icon: new Icon(
                                    Icons.lock,
                                    color: primaryColor,
                                  ),
                                  labelText: 'Password',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87
                                  ),
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter password';
                                  }
                                },
                                onSaved: (value) {
                                  this._password = value;
                                },
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new TextTap(
                                    "User Agreement", 
                                    "web",
                                    _userAgreementURL,
                                    textColor: Colors.green
                                  ),
                                  new TextTap(
                                    "Privacy Policy", 
                                    "web",
                                    _privacyPolicyURL,
                                    textColor: Colors.green
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0, 
                                horizontal: 24.0
                              ),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    child: new Checkbox(
                                      value: _acceptTerms,
                                      activeColor: primaryColor,
                                      onChanged: (value) {
                                        setState((){
                                          this._acceptTerms = value;
                                        });                                        
                                      },
                                    ),
                                  ),
                                  new Container(
                                    child: new Expanded(
                                      child: Text(
                                        'By signing in, I accept User Agreement & Privacy Policy',
                                        style: new TextStyle(
                                          color: Colors.black87
                                        )
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0, 
                                horizontal: 24.0
                              ),
                              child: new FlatButton(
                                color: primaryColor,                                
                                child: new Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: primaryTextColor
                                  )
                                ),
                                onPressed: () {
                                  _handleSubmitted();                                  
                                },
                              ),
                            ),
                            new Container(
                              padding:
                                  EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // _businessPartner["display_signup_button"] ?
                                  //   new Container(
                                  //     padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                  //     child: TextTap(
                                  //       "Create Account", "route", "/auth/signup",
                                  //       textColor: Colors.blue
                                  //     ),
                                  //   )
                                  // : new Container(),                                  
                                  new Container (
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                    child: TextTap(
                                      "Forgot Password", "route", "/auth/forgot_password",
                                      textColor: Colors.green
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      }
    );
  }
}
