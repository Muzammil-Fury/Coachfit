import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/components/text_tap.dart';
import 'package:gomotive/core/app_config.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,
        bottom: false,
        child: _SignUp(),
      ),
    );
  }
}

class _SignUp extends StatefulWidget {
  @override
  SignUpState createState() => new SignUpState();
}

class SignUpState extends State<_SignUp> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  bool _acceptTerms = false;

  void _handleSubmitted() {
    if (_formKey.currentState.validate()) {
      if (!_acceptTerms) {
        Utils.showInSnackBar(_scaffoldKey,
            "Please accept user agreement and privacy policy before submitting.");
        return;
      } else {
        _formKey.currentState.save();
      }
    } else {
      Utils.showInSnackBar(
          _scaffoldKey, "Please fix the errors in red before submitting.");
    }
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return new Scaffold(
      key: _scaffoldKey,
      body: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: new Container(
                padding: EdgeInsets.symmetric(vertical: 64.0),
                child: new Form(
                  key: _formKey,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new TextFormField(
                          autofocus: false,
                          style: new TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: new TextStyle(color: Colors.white),
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white))),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter first name';
                            }
                          },
                          onSaved: (value) {
                            _firstName = value;
                          },
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new TextFormField(
                          autofocus: false,
                          style: new TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: new TextStyle(color: Colors.white),
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white))),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter last name';
                            }
                          },
                          onSaved: (value) {
                            _lastName = value;
                          },
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          style: new TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: new TextStyle(color: Colors.white),
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white))),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter email';
                            }
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new TextFormField(
                          autofocus: false,
                          obscureText: true,
                          style: new TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: new TextStyle(color: Colors.white)),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Please enter password';
                            }
                          },
                          onSaved: (value) {
                            _password = value;
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
                                "User Agreement", "web", "https://flutter.io",
                                textColor: Colors.green),
                            new TextTap(
                                "Privacy Policy", "web", "https://flutter.io",
                                textColor: Colors.green),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new Row(
                          children: <Widget>[
                            new Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  _acceptTerms = value;
                                }),
                            new Expanded(
                                child: new Text(
                                    'By signing in, I accept GoMotive User Agreement and Privacy Policy',
                                    style: new TextStyle(color: Colors.white)))
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: new FlatButton(
                          child: new Text('Sign Up'),
                          onPressed: _handleSubmitted,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 32.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new TextTap("I already have an account", "route",
                                "/auth/signin",
                                textColor: Colors.green),
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
  }
}
