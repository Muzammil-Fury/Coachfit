import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/home/home_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/components/text_tap.dart';

class SignIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _SignIn(),
        )
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

  int _emailExists = -1;

  bool _acceptTerms = false;
  String _email = "";
  String _password = "";
  String _name = "";
  String _privacyPolicyURL, _userAgreementURL;
  var _loginAPI, _verifyEmailAPI, _clearVerifyEmailActionCreator;

  void _verifyEmailSubmitted() {
    if (_formKey.currentState.validate()) {      
      _formKey.currentState.save();
      Map params = Map();
      params["email"] = _email;        
      _verifyEmailAPI(context, params);
    } else {
      Utils.alertDialog(context, "Error", "Kindly fix errors in red before submitting");
    }
  }

  void _loginSubmitted() {
    if (_formKey.currentState.validate()) {
      if (!_acceptTerms) {
        Utils.alertDialog(context, "Error", "Kindly accept user agreement and privacy policy");
        return;
      } else {
        _formKey.currentState.save();
        Map params = Map();
        params["email"] = _email;
        params["password"] = _password;
        if(_emailExists == 0) {
          params["name"] = _name;  
        }    
        params["notification_token"] = notificationStr;  
        _loginAPI(context, params);
      }
    } else {
      Utils.alertDialog(context, "Error", "Kindly fix errors in red before submitting");
    }
  }

  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
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
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8),
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover
                  ),
                ),

                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 32.0, horizontal: 24.0),
                        child: new Center(
                          child: new Text(
                            'Step 1: Sign In',
                            style: new TextStyle(
                              fontSize: 48.0,
                            ),
                          ),
                        ),
                      ),                      
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 128.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          style: new TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.email,
                              color: dhfYellow,
                            ),
                            labelText: 'Email Address',
                            labelStyle: new TextStyle(
                              color: Colors.black87,
                            ),
                            border: new OutlineInputBorder(
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
                      _emailExists != -1
                      ? new Column(
                          children: <Widget>[
                            _emailExists == 0
                            ? new Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 128.0),
                                child: new TextFormField(
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    icon: const Icon(
                                      Icons.person,
                                      color: dhfYellow,
                                    ),
                                    labelText: 'Name',
                                    labelStyle: new TextStyle(
                                      color: Colors.black87
                                    ),
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if(_emailExists == 0) {
                                      if (value.trim().isEmpty) {
                                        return 'Please enter your name';
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    this._name = value;
                                  },
                                ),
                              )
                            : new Container(),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 128.0),
                              child: new TextFormField(
                                autofocus: false,
                                obscureText: true,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.lock,
                                    color: dhfYellow,
                                  ),
                                  labelText: 'Password',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87
                                  ),
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
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
                                horizontal: 64.0
                              ),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Container(
                                    child: new Checkbox(
                                      value: _acceptTerms,
                                      activeColor: dhfYellow,
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
                          ]
                        )
                      : new Container(),                                                
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 24.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                              height: 50.0, 
                              minWidth: 120.0,
                              color: dhfYellow,
                              child: new Text(
                                'Submit',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black87, 
                              onPressed: () {
                                if(_emailExists == -1) {
                                  _verifyEmailSubmitted();
                                } else {
                                  _loginSubmitted();
                                }
                              },
                            ),
                            new MaterialButton(
                              height: 50.0, 
                              minWidth: 120.0,                              
                              child: new Text(
                                'Back',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black87, 
                              onPressed: () {
                                Navigator.pop(context);
                              }
                            )
                          ],
                        )
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
  }

  Widget _drawSmallerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new Scaffold(      
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Step 1: Sign In'
          )
        ),
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
                padding: EdgeInsets.symmetric(
                            vertical: 64.0, horizontal: 8.0),               
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[                                            
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          style: new TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.email,
                              color: dhfYellow,
                            ),
                            labelText: 'Email Address',
                            labelStyle: new TextStyle(
                              color: Colors.black87,
                            ),
                            border: new OutlineInputBorder(
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
                      _emailExists != -1
                      ? new Column(
                          children: <Widget>[
                            _emailExists == 0
                            ? new Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8.0),
                                child: new TextFormField(
                                  autofocus: false,
                                  style: new TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    icon: const Icon(
                                      Icons.person,
                                      color: dhfYellow,
                                    ),
                                    labelText: 'Name',
                                    labelStyle: new TextStyle(
                                      color: Colors.black87
                                    ),
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if(_emailExists == 0) {
                                      if (value.trim().isEmpty) {
                                        return 'Please enter your name';
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    this._name = value;
                                  },
                                ),
                              )
                            : new Container(),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: new TextFormField(
                                autofocus: false,
                                obscureText: true,
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.lock,
                                    color: dhfYellow,
                                  ),
                                  labelText: 'Password',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87
                                  ),
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
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
                                      activeColor: dhfYellow,
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
                          ]
                        )
                      : new Container(),                       
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 24.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new MaterialButton(
                              height: 50.0, 
                              minWidth: 120.0,
                              color: dhfYellow,
                              child: new Text(
                                'Submit',
                                textScaleFactor: 1.5,
                              ),
                              textColor: Colors.black87, 
                              onPressed: () {
                                if(_emailExists == -1) {
                                  _verifyEmailSubmitted();
                                } else {
                                  _loginSubmitted();
                                }
                              },
                            ),                            
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              )
            )
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.landscapeLeft, 
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.portraitDown
    // ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _loginAPI = stateObject["login"];
        _verifyEmailAPI = stateObject["verifyEmail"];
        _clearVerifyEmailActionCreator = stateObject["clearVerifyEmail"];
        this._clearVerifyEmailActionCreator();
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["login"] = (BuildContext context, Map params) =>
            store.dispatch(login(context, params));
        returnObject["verifyEmail"] = (BuildContext context, Map params) =>
            store.dispatch(verifyEmail(context, params));
        returnObject["clearVerifyEmail"] = () =>
            store.dispatch(ClearVerifyEmailActionCreator());
        returnObject["emailExists"] = store.state.homeFitHomeState.userEmailExists;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {        
        _emailExists = stateObject["emailExists"];
        _privacyPolicyURL = homeFitBaseURL + "site_media/static/files/privacy_policy.pdf";
        _userAgreementURL = homeFitBaseURL + "terms_of_use";
        if(mobileLayout) {
          return this._drawSmallerDeviceWidget();
        } else {
          return this._drawLargerDeviceWidget();
        }        
      },
    );
  }
}
