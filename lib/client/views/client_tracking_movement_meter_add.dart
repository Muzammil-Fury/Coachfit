import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/core/app_config.dart';

class ClientTrackingMovementMeterAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientTrackingMovementMeterAdd(),
      ),
    );
  }
}

class _ClientTrackingMovementMeterAdd extends StatefulWidget {
  @override
  _ClientTrackingMovementMeterAddState createState() => new _ClientTrackingMovementMeterAddState();
}

class _ClientTrackingMovementMeterAddState extends State<_ClientTrackingMovementMeterAdd> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _addActivityAPI;

  int _dla, _sports, _mobility, _strength, _metabolic, _power;

  _addActivity() {
    _formKey.currentState.save();
    Map _params = new Map();
    _params["dla_duration"] = _dla;
    _params["sports_duration"] = _sports;
    _params["mobility_duration"] = _mobility;
    _params["strength_duration"] = _strength;
    _params["metabolic_duration"] = _metabolic;
    _params["power_duration"] = _power;
    this._addActivityAPI(context, _params);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {   
        _addActivityAPI = stateObject["addActivity"];     
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();    
        returnObject["addActivity"] = (BuildContext context, Map params) =>
            store.dispatch(addActivity(context, params));    
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
              'Other Activities',             
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
                    _addActivity();
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
                        crossAxisAlignment: CrossAxisAlignment.start,                   
                        children: <Widget>[
                          new Container(
                            width: MediaQuery.of(context).size.width,   
                            decoration: BoxDecoration(
                              color: Colors.blueGrey
                            ),                       
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: new Text(
                              "Other than workouts you already log on this App, enter the time spent on other activites for the current week",
                              textAlign: TextAlign.center,
                              style: TextStyle(  
                                color: Colors.white,                                  
                              ),
                            )
                          ),
                          new Container(
                            child: new Column(  
                              crossAxisAlignment: CrossAxisAlignment.start,                          
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Daily Life Activites",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Gardening, Housework, Recreational hobbies, Outdoor Activites",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _dla = int.parse(value);
                                      } else {
                                        _dla = 0;
                                      }                                     
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Sports",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Swimming, Throwing, Agility, Combat, Endurance, Olympic",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _sports = int.parse(value);
                                      } else {
                                        _sports = 0;
                                      }                                   
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Mobility",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Yoga, Taichi, Pilates, Massage, Meditation, Stretching",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _mobility = int.parse(value);
                                      } else {
                                        _mobility = 0;
                                      }                                     
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Strength",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Bodybuilding, Powerlifting, Functional training",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _strength = int.parse(value);
                                      } else {
                                        _strength = 0;
                                      }                                   
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Metabolic",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Cardio equipment, Aerobic & HIIT classes, CrossFit, Running, Walking, Shopping",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _metabolic = int.parse(value);
                                      } else {
                                        _metabolic = 0;
                                      }                                     
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Power",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  child: new Text(
                                    "Acceleration, Deceleration, Agility, Quickness, Max power",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  )
                                ),
                                new Container(       
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),                     
                                  child: new TextFormField(
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    style: new TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(                                      
                                      hintText: 'Enter in minutes', 
                                      hintStyle: TextStyle(
                                        fontSize: 12.0,
                                      ),                                     
                                      border: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),                                    
                                    onSaved: (value) {
                                      if(value != null && value != "") {
                                        _power = int.parse(value);
                                      } else {
                                        _power = 0;
                                      }                                    
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 64)
                                )
                              ]
                            )
                          )    
                        ],
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
