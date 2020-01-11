import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/utils/preferences.dart';
import 'package:gomotive/homefit/home/views/dashboard.dart';
import 'package:gomotive/homefit/home/home_actions.dart';


class UserProfileIpad extends StatelessWidget {

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
          child: _UserProfileIpad(),
        )        
      ),
    );
  }
}

class _UserProfileIpad extends StatefulWidget {
  @override
  _UserProfileIpadState createState() => new _UserProfileIpadState();
}

class _UserProfileIpadState extends State<_UserProfileIpad> {
  final GlobalKey<FormState> _updateNameFormKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _changePasswordFormKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final customDurationController = TextEditingController();

  
  var _changePasswordAPI, 
      _updateNameAPI, 
      _dashboardDetailsMovementMeterSuccessActionCreator, 
      _updateMovementMeterSettingsAPI, 
      _homeCleanupActionCreator,
      _signoutAPI;
  Map _user;
  Map _movementMeterConfiguration;

  String _displayScreen;
  String _firstName, _lastName, _currentPassword, _newPassword, _confirmNewPassword;
  String _dropdownSelectedValue;
  double _mobilityMinutes, _strengthMinutes, _metabolicMinutes, _powerMinutes, _totalDuration;


  void _updateProfileName() {
    if (_updateNameFormKey.currentState.validate()) {
      _updateNameFormKey.currentState.save();
      Map params = Map();
      params["id"] = _user["id"];
      params["first_name"] = _firstName;
      params["last_name"] = _lastName;
      params["timezone"] = "homefit";
      params["is_avatar_uploaded"] = false;
      _updateNameAPI(context, params);
    } else {
      Utils.showInSnackBar(
          _scaffoldKey, "Please fix the errors in red before submitting.");
    }
  }

  void _changePassword() {
    if (_changePasswordFormKey.currentState.validate()) {
      if(_newPassword != _confirmNewPassword) {
        Utils.alertDialog(context, "Mismatch", "Passwords do not match.");
      }
      _changePasswordFormKey.currentState.save();
      Map params = Map();
      params["current_password"] = _currentPassword;
      params["new_password"] = _newPassword;
      _changePasswordAPI(context, params);
      Preferences.deleteAccessToken();
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      Utils.showInSnackBar(
          _scaffoldKey, "Please fix the errors in red before submitting.");
    }
  }

  void _updateMovementMeterSettings() {
    if(_totalDuration < 240) {
      Utils.alertDialog(context, "Invalid", "Total duration value cannot be lesser than 240 minutes per week.");
    } else {
      Map params = Map();
      params["duration_total"] = _totalDuration;
      _updateMovementMeterSettingsAPI(context, params);
    }
  }

  List<DropdownMenuItem<String>> _dropDownMovementMeterOptions() {
    List<DropdownMenuItem<String>> items = new List();    
    items.add(
      new DropdownMenuItem(
        value: "1",
        child: new Container(
          child: new Text(
            "Minimum (4 hours of weekly workout)",
            style: TextStyle(
              fontSize: 24.0
            )
          )
        )        
      )
    );
    items.add(
      new DropdownMenuItem(
        value: "2",
        child: new Container(
          child: new Text(
            "Moderate (6 hours of weekly workout)",
            style: TextStyle(
              fontSize: 24.0
            )
          )
        )
      )
    );
    items.add(
      new DropdownMenuItem(
        value: "3",
        child: new Container(
          child: new Text(
            "Optimal (9 hours of weekly workout)",
            style: TextStyle(
              fontSize: 24.0
            )
          )
        )
      )
    );
    items.add(
      new DropdownMenuItem(
        value: "4",
        child: new Container(
          child: new Text(
            "Custom",
            style: TextStyle(
              fontSize: 24.0
            )
          )
        )        
      )
    );
    return items;
  }



  @override
  void initState() {
      setState(() {
        _displayScreen = "movement_meter_settings";
      });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _changePasswordAPI = stateObject["changePassword"];
        _updateNameAPI = stateObject["updateName"];
        _updateMovementMeterSettingsAPI = stateObject["updateMovementMeterSettings"];
        _dashboardDetailsMovementMeterSuccessActionCreator = stateObject["dashboardDetailsMovementMeterSuccessActionCreator"];
        _homeCleanupActionCreator = stateObject["homeCleanup"];
        _signoutAPI = stateObject["userSignout"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["updateName"] = (BuildContext context, Map params) =>
            store.dispatch(updateName(context, params));
        returnObject["userSignout"] = (BuildContext context, Map params) =>
            store.dispatch(userSignout(context, params));
        returnObject["changePassword"] = (BuildContext context, Map params) =>
            store.dispatch(changePassword(context, params));
        returnObject["updateMovementMeterSettings"] = (BuildContext context, Map params) =>
            store.dispatch(updateMovementMeterSettings(context, params));
        returnObject["getFamilyPlanMembers"] = (BuildContext context, Map params) =>
          store.dispatch(getFamilyPlanMembers(context, params)); 
        returnObject["dashboardDetailsMovementMeterSuccessActionCreator"] = (Map movementMeter) =>
          store.dispatch(DashboardDetailsMovementMeterSuccessActionCreator(movementMeter)
        ); 
        returnObject["homeCleanup"] = () =>
          store.dispatch(HomeCleanup()
        ); 
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["movementMeterConfiguration"] = store.state.homeFitHomeState.movementMeterConfiguration;
        if(returnObject["movementMeterConfiguration"]["duration_total"] == 240) {
          _dropdownSelectedValue = "1";
        } else if(returnObject["movementMeterConfiguration"]["duration_total"] == 360) {
          _dropdownSelectedValue = "2";
        } else if(returnObject["movementMeterConfiguration"]["duration_total"] == 540) {
          _dropdownSelectedValue = "3";
        } else {
          _dropdownSelectedValue = "4";
          customDurationController.text = returnObject["movementMeterConfiguration"]["duration_total"].toString();
        }
        _mobilityMinutes = returnObject["movementMeterConfiguration"]["duration_total"] * .30;
        _strengthMinutes = returnObject["movementMeterConfiguration"]["duration_total"] * .20;
        _metabolicMinutes = returnObject["movementMeterConfiguration"]["duration_total"] * .30;
        _powerMinutes = returnObject["movementMeterConfiguration"]["duration_total"] * .20;
        _totalDuration = _mobilityMinutes + _strengthMinutes + _metabolicMinutes + _powerMinutes;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _user = stateObject["user"];
        _movementMeterConfiguration = stateObject["movementMeterConfiguration"];
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
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: new AssetImage("assets/images/background.png"),
                        fit: BoxFit.cover
                      ),
                    ),
                    child: new Column(                      
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          height: MediaQuery.of(context).size.height*0.15,
                          decoration: new BoxDecoration(
                            color: Colors.black26
                          ),
                          child: Utils.drawMenu(context, "profile")
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.85,
                          padding: EdgeInsets.symmetric(
                            vertical: 50.0, 
                            horizontal: 24.0
                          ),
                          child: new Row(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: MaterialButton(
                                      height: 50.0, 
                                      minWidth: 286.0,
                                      color: _displayScreen == "movement_meter_settings" ? Colors.green : dhfYellow,
                                      child: new Text(
                                        'Movement Meter Settings',
                                        textScaleFactor: 1.5,
                                      ),
                                      textColor: Colors.black87, 
                                      onPressed: () {    
                                        setState(() {
                                          _displayScreen = "movement_meter_settings";
                                        });                                  
                                      },
                                    ),
                                  ),
                                  new Container (
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: MaterialButton(
                                      height: 50.0, 
                                      minWidth: 286.0,
                                      color: _displayScreen == "update_name" ? Colors.green : dhfYellow,
                                      child: new Text(
                                        'Update Name',
                                        textScaleFactor: 1.5,
                                      ),
                                      textColor: Colors.black87, 
                                      onPressed: () {   
                                        setState(() {
                                          _displayScreen = "update_name";
                                        });                                   
                                      },
                                    ),
                                  ),
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: MaterialButton(
                                      height: 50.0, 
                                      minWidth: 286.0,
                                      color: _displayScreen == "change_password" ? Colors.green : dhfYellow,
                                      child: new Text(
                                        'Change Password',
                                        textScaleFactor: 1.5,
                                      ),
                                      textColor: Colors.black87, 
                                      onPressed: () {    
                                        setState(() {
                                          _displayScreen = "change_password";
                                        });                                  
                                      },
                                    ),
                                  ),                                  
                                  new Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: new MaterialButton(
                                      height: 50.0, 
                                      minWidth: 286.0,
                                      color: dhfYellow,
                                      child: new Text(
                                        'Sign Out',
                                        textScaleFactor: 1.5,
                                      ),
                                      textColor: Colors.black87, 
                                      onPressed: () {
                                        _signoutAPI(context, {});
                                      },
                                    ),
                                  ),                                  
                                ],
                              ),
                              _displayScreen == "update_name" ?
                                new Flexible(
                                  child: new Form(
                                    key: _updateNameFormKey,
                                    child: new Column(
                                      children: <Widget>[                                           
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                          child: new TextFormField(
                                            initialValue: _user != null ? _user["first_name"] : "",                                            
                                            autofocus: false,
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(                                              
                                              labelText: 'First Name',
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
                                                return 'Please enter first name';
                                              }
                                            },
                                            onSaved: (value) {
                                              this._firstName = value;
                                            },
                                          ),
                                        ),                                      
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                          child: new TextFormField(
                                            initialValue: _user != null ? _user["last_name"] : "",
                                            autofocus: false,
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(
                                              labelText: 'Last Name',
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
                                                return 'Please enter last name';
                                              }
                                            },
                                            onSaved: (value) {
                                              this._lastName = value;
                                            },
                                          ),
                                        ),
                                        new Container(   
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 32.0),
                                          child: new MaterialButton(
                                            height: 50.0, 
                                            minWidth: 120.0,
                                            color: Colors.green,
                                            child: new Text(
                                              'Update Name',
                                              textScaleFactor: 1.5,
                                            ),
                                            textColor: Colors.black87, 
                                            onPressed: () {
                                              _updateProfileName();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : new Container(),
                              _displayScreen == "change_password" ?
                                new Flexible(
                                  child: new Form(
                                    key: _changePasswordFormKey,
                                    child: new Column(
                                      children: <Widget>[                                           
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                          child: new TextFormField(  
                                            obscureText: true,                                          
                                            keyboardType: TextInputType.emailAddress,
                                            autofocus: false,
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(                                              
                                              labelText: 'Current Password',
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
                                                return 'Please enter your current password';
                                              }
                                            },
                                            onSaved: (value) {
                                              this._currentPassword = value;
                                            },
                                          ),
                                        ),                                      
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                          child: new TextFormField(
                                            obscureText: true,
                                            autofocus: false,
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(
                                              labelText: 'New Password',
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
                                                return 'Please enter your new password';
                                              }
                                            },
                                            onSaved: (value) {
                                              this._newPassword = value;
                                            },
                                          ),
                                        ),
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                          child: new TextFormField(
                                            obscureText: true,
                                            autofocus: false,
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(
                                              labelText: 'Confirm New Password',
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
                                                return 'Please confirm your new password';
                                              }                                              
                                            }, 
                                            onSaved: (value) {
                                              _confirmNewPassword = value;
                                            },                                           
                                          ),
                                        ),
                                        new Container(   
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0, horizontal: 32.0),
                                          child: new MaterialButton(
                                            height: 50.0, 
                                            minWidth: 120.0,
                                            color: Colors.green,
                                            child: new Text(
                                              'Change Password',
                                              textScaleFactor: 1.5,
                                            ),
                                            textColor: Colors.black87, 
                                            onPressed: () {
                                              _changePassword();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : new Container(),
                              _displayScreen == "movement_meter_settings" ?
                                new Container(
                                  // padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 64.0),
                                  padding: EdgeInsets.fromLTRB(32, 0, 0, 8),
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(   
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4),                                     
                                        child: new MaterialButton(
                                          color: Colors.blueGrey,
                                          child: new Text(
                                            'What is Movement Meter?',
                                            textScaleFactor: 1.5,
                                          ),
                                          textColor: Colors.white, 
                                          onPressed: () {
                                            Utils.alertDialog(
                                              context, 
                                              "HomeFit Movement Meter Description", 
                                              "The US Government Physical Activity Guidelines states we need anywhere from 4 hrs up to 8 hours of movement weekly based on the individual, their needs, and goals.\n\nThe confusion lies with what do we do to complete that amount of activity.\nWe believe all activity is good if it is dosed at the right amounts, at the right time, for the goal.\n\nMovement can be defined by 4 pillars:\n\nMobility:  Workouts designed to enhance flexibility, mobility, and recovery\nStrength:  Workouts designed to enhance our ability to push, pull, lift, and get up from the ground to stand position\nMetabolic: Workouts designed to enhance our endurance and sustainability by working the heart at various intensities\nPower: Workouts designed to enhance our speed, reaction, agility, and maximum power output.\n\nYour movement meter is set for quantifying Monday through Sunday of each week. If you modify movement goals it will take place on the following Monday. Movement pillars are set at 30% Mobility / 20% Strength / 30% Metabolic / 20% Power."
                                            );
                                          },
                                        ),
                                      ),
                                      _movementMeterConfiguration != null ?
                                        new Container(                                          
                                          child: new Text(
                                            "Current Total Workout Duration: " + 
                                            _movementMeterConfiguration["duration_total"].toString() + 
                                            " minutes / week " +
                                            "(" + ((_movementMeterConfiguration["duration_total"]/60.0).round()).toString() + " hours)",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600
                                            )
                                          )                                          
                                        )                                        
                                      : new Container(),
                                      new Container(
                                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),                                        
                                        child: new Text(
                                          "Configure your new total movement duration in minutes per week",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black
                                          )
                                        )                                        
                                      ),
                                      new Container(
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        color: Colors.white,
                                        child: new DropdownButtonHideUnderline(
                                          child: new DropdownButton(                                            
                                            value: _dropdownSelectedValue,
                                            items: _dropDownMovementMeterOptions(),
                                            onChanged:(String selectedValue){
                                              setState(() {
                                                _dropdownSelectedValue = selectedValue;
                                              });
                                              double totalDuration = 0.0;
                                              if(selectedValue == "1"){
                                                totalDuration = 240.0;
                                              } else if(selectedValue == "2") {
                                                totalDuration = 360.0;
                                              } else if(selectedValue == "3"){
                                                totalDuration = 540.0;
                                              } else {
                                                totalDuration = 0.0;
                                              }                                              
                                              setState(() {
                                                _totalDuration = totalDuration;
                                                _mobilityMinutes = totalDuration * .30;
                                                _strengthMinutes = totalDuration* .20;
                                                _metabolicMinutes = totalDuration * .30;
                                                _powerMinutes = totalDuration * .20;
                                              });                                                                                              
                                            }
                                          )
                                        )
                                      ),
                                      _dropdownSelectedValue == "4" ?
                                        new Container(
                                          width: 500.0,
                                          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: new TextField(
                                            controller: customDurationController,
                                            autofocus: false,
                                            keyboardType: TextInputType.number,                                            
                                            style: new TextStyle(color: Colors.black87),
                                            decoration: InputDecoration(                                              
                                              labelText: 'Total Duration (Minutes per week)',
                                              labelStyle: new TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24.0,
                                              ),
                                              border: new UnderlineInputBorder(
                                                borderSide: new BorderSide(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            onEditingComplete: () {
                                              double totalDuration = double.parse(customDurationController.text);
                                              setState(() {
                                                _totalDuration = totalDuration;
                                                _mobilityMinutes =  totalDuration * .30;
                                                _strengthMinutes = totalDuration* .20;
                                                _metabolicMinutes = totalDuration * .30;
                                                _powerMinutes = totalDuration * .20;
                                              });                                              
                                            },                                            
                                          ),
                                        )
                                      : new Container(),
                                      new Container(                                        
                                        margin: EdgeInsets.fromLTRB(0, 32, 0, 8),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 24.0,
                                              child: new Image.asset(
                                                'assets/images/mobility.png',
                                                color: Colors.blue,                                                
                                              )
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(4,0,0,0),
                                              width: 225.0,
                                              child: new Text(
                                                "Mobility Duration: ",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              width: 225.0,
                                              child: new Text(
                                                _mobilityMinutes.round().toString() + " minutes/week ",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                            new Container(                                              
                                              child: new Text(
                                                "("+((_mobilityMinutes/5).round()).toString() + " points)",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                          ],
                                        )                                        
                                      ),
                                      new Container(                                        
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 24.0,
                                              child: new Image.asset(
                                                'assets/images/strength.png',
                                                color: Colors.green,                                                
                                              )
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(4,0,0,0),
                                              width: 225.0,
                                              child: new Text(
                                                "Strength Duration: ",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              width: 225.0,
                                              child: new Text(
                                                _strengthMinutes.round().toString() + " minutes/week ",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                            new Container(                                              
                                              child: new Text(
                                                "("+((_strengthMinutes/5).round()).toString() + " points)",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ),
                                          ],
                                        )                                         
                                      ),
                                      new Container(                                        
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 24.0,
                                              child: new Image.asset(
                                                'assets/images/metabolic.png',
                                                color: Colors.red,                                                
                                              )
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(4,0,0,0),
                                              width: 225.0,
                                              child: new Text(
                                                "Metabolic Duration: ",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              width: 225.0,
                                              child: new Text(
                                                _metabolicMinutes.round().toString() + " minutes/week ",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                            new Container(                                              
                                              child: new Text(
                                                "("+((_metabolicMinutes/5).round()).toString() + " points)",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                          ],
                                        ) 
                                      ),
                                      new Container(                                        
                                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 24.0,
                                              child: new Image.asset(
                                                'assets/images/power.png',
                                                color: Colors.yellow,                                                
                                              )
                                            ),
                                            new Container(
                                              width: 225.0,
                                              child: new Text(
                                                "Power Duration: ",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                            ),
                                            new Container(
                                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                              width: 225.0,
                                              child: new Text(
                                                _powerMinutes.round().toString() + " minutes/week ",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                            new Container(
                                              child: new Text(
                                                "("+((_powerMinutes/5).round()).toString() + " points)",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.yellow,
                                                  fontWeight: FontWeight.w100
                                                )
                                              ),
                                            ),
                                          ],
                                        ) 
                                      ),
                                      new Container(   
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 0.0),
                                        child: new MaterialButton(
                                          height: 50.0, 
                                          minWidth: 120.0,
                                          color: Colors.green,
                                          child: new Text(
                                            'Update',
                                            textScaleFactor: 1.5,
                                          ),
                                          textColor: Colors.black87, 
                                          onPressed: () {
                                            _updateMovementMeterSettings();
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                )
                              : new Container(),                              
                            ],
                          )
                        ),                        
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
