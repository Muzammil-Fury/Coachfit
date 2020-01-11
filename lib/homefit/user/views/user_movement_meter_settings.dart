import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/user/user_network.dart';
import 'package:gomotive/homefit/utils/utils.dart';


class UserMovementMeterSettings extends StatelessWidget {
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
          child: _UserMovementMeterSettings(),
        )        
      ),
    );
  }
}

class _UserMovementMeterSettings extends StatefulWidget {
  @override
  UserMovementMeterSettingsState createState() => new UserMovementMeterSettingsState();
}

class UserMovementMeterSettingsState extends State<_UserMovementMeterSettings> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  TextEditingController customDurationController = TextEditingController();

  var _getUserMovementMeterSettingsAPI, _updateMovementMeterSettingsAPI;
  Map _movementMeterConfiguration;
  String _dropdownSelectedValue;
  double _mobilityMinutes, _strengthMinutes, _metabolicMinutes, _powerMinutes, _totalDuration;

  List<DropdownMenuItem<String>> _dropDownMovementMeterOptions() {
    List<DropdownMenuItem<String>> items = new List();    
    items.add(
      new DropdownMenuItem(
        value: "1",
        child: new Container(
          child: new Text(
            "Minimum (4 hours of weekly workout)",
            style: TextStyle(
              fontSize: 14.0
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
              fontSize: 14.0
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
              fontSize: 14.0
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
              fontSize: 14.0
            )
          )
        )        
      )
    );
    return items;
  }

  void _updateMovementMeterSettings() {
    if(_totalDuration < 240) {
      Utils.alertDialog(context, "Invalid", "Total duration value cannot be lesser than 240 minutes per week.");
    } else {
      Map params = Map();
      params["duration_total"] = _totalDuration;
      _updateMovementMeterSettingsAPI(context, params);
      Navigator.of(context).pop();
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getUserMovementMeterSettingsAPI = stateObject["getUserMovementMeterSettings"];
        _updateMovementMeterSettingsAPI = stateObject["updateMovementMeterSettings"];
        _getUserMovementMeterSettingsAPI(context, {});
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getUserMovementMeterSettings"] = (BuildContext context, Map params) =>
            store.dispatch(getUserMovementMeterSettings(context, params));
        returnObject["updateMovementMeterSettings"] = (BuildContext context, Map params) =>
            store.dispatch(updateMovementMeterSettings(context, params));
        returnObject["movementMeterSettings"] = store.state.userState.movementMeterSettings;        
        if(returnObject["movementMeterSettings"] != null) {
          if(returnObject["movementMeterSettings"]["duration_total"] == 240) {
            _dropdownSelectedValue = "1";
          } else if(returnObject["movementMeterSettings"]["duration_total"] == 360) {
            _dropdownSelectedValue = "2";
          } else if(returnObject["movementMeterSettings"]["duration_total"] == 540) {
            _dropdownSelectedValue = "3";
          } else {
            _dropdownSelectedValue = "4";
            customDurationController.text = returnObject["movementMeterSettings"]["duration_total"].toString();
          }
          _mobilityMinutes = returnObject["movementMeterSettings"]["duration_total"] * .30;
          _strengthMinutes = returnObject["movementMeterSettings"]["duration_total"] * .20;
          _metabolicMinutes = returnObject["movementMeterSettings"]["duration_total"] * .30;
          _powerMinutes = returnObject["movementMeterSettings"]["duration_total"] * .20;
          _totalDuration = _mobilityMinutes + _strengthMinutes + _metabolicMinutes + _powerMinutes;
        }
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {  
        _movementMeterConfiguration = stateObject["movementMeterSettings"];
        if(_movementMeterConfiguration != null) {          
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
                "Movement Meter",                
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
                      _updateMovementMeterSettings();
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
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(   
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: new Center(
                              child: new MaterialButton(
                                color: Colors.blueGrey,
                                child: new Text(
                                  'What is Movement Meter?',
                                  textScaleFactor: 1.0,
                                ),
                                textColor: Colors.white, 
                                onPressed: () {
                                  Utils.alertDialog(
                                    context, 
                                    "CoachFit Movement Meter Description", 
                                    "The US Government Physical Activity Guidelines states we need anywhere from 4 hrs up to 8 hours of movement weekly based on the individual, their needs, and goals.\n\nThe confusion lies with what do we do to complete that amount of activity.\nWe believe all activity is good if it is dosed at the right amounts, at the right time, for the goal.\n\nMovement can be defined by 4 pillars:\n\nMobility:  Workouts designed to enhance flexibility, mobility, and recovery\nStrength:  Workouts designed to enhance our ability to push, pull, lift, and get up from the ground to stand position\nMetabolic: Workouts designed to enhance our endurance and sustainability by working the heart at various intensities\nPower: Workouts designed to enhance our speed, reaction, agility, and maximum power output.\n\nYour movement meter is set for quantifying Monday through Sunday of each week. If you modify movement goals it will take place on the following Monday. Movement pillars are set at 30% Mobility / 20% Strength / 30% Metabolic / 20% Power."
                                  );
                                },
                              ),
                            ),
                          ),
                          new Container(                                          
                            child: new Text(
                              "Current Total Workout Duration: " + 
                              _movementMeterConfiguration["duration_total"].toString() + 
                              " minutes / week " +
                              "(" + ((_movementMeterConfiguration["duration_total"]/60.0).round()).toString() + " hours)",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            )                                          
                          ),                                                                  
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Text(
                              "Configure your new total movement duration in minutes per week",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                            )                                        
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            color: Colors.white,
                            child: new Center(
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
                            )
                          ),
                          _dropdownSelectedValue == "4" ?
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                              child: new TextField(
                                controller: customDurationController,
                                autofocus: false,
                                keyboardType: TextInputType.number,     
                                textInputAction: TextInputAction.done,                                       
                                style: new TextStyle(color: Colors.black87),
                                decoration: InputDecoration(                                              
                                  labelText: 'Total Duration (Minutes per week)',
                                  labelStyle: new TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14.0,
                                  ),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
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
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                  child: new Text(
                                    "Mobility Duration: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    )
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: new Text(
                                    _mobilityMinutes.round().toString() + " minutes/week ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )
                                  ),
                                ),
                                new Container(                                              
                                  child: new Text(
                                    "("+((_mobilityMinutes/5).round()).toString() + " points)",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.blue,
                                    )
                                  ),
                                ),
                              ],
                            )                                        
                          ),
                          new Container(                                        
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                  child: new Text(
                                    "Strength Duration: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    )
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    _strengthMinutes.round().toString() + " minutes/week ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )
                                  ),
                                ),
                                new Container(                                              
                                  child: new Text(
                                    "("+((_strengthMinutes/5).round()).toString() + " points)",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.green,
                                    )
                                  ),
                                ),
                              ],
                            )                                         
                          ),
                          new Container(                                        
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                  child: new Text(
                                    "Metabolic Duration: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    )
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    _metabolicMinutes.round().toString() + " minutes/week ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )
                                  ),
                                ),
                                new Container(                                              
                                  child: new Text(
                                    "("+((_metabolicMinutes/5).round()).toString() + " points)",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.red,
                                    )
                                  ),
                                ),
                              ],
                            ) 
                          ),
                          new Container(                                        
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
                                  child: new Text(
                                    "Power Duration: ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    )
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    _powerMinutes.round().toString() + " minutes/week ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    "("+((_powerMinutes/5).round()).toString() + " points)",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.yellow,
                                    )
                                  ),
                                ),
                              ],
                            ) 
                          ),                          
                        ],
                      )
                    )
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
