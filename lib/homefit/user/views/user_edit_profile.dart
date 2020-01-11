import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/utils/utils.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/utils/gomotive_icons.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/user/user_network.dart';


class UserEditProfile extends StatelessWidget {
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
          child: _UserEditProfile(),
        )        
      ),
    );
  }
}

class _UserEditProfile extends StatefulWidget {
  @override
  UserEditProfileState createState() => new UserEditProfileState();
}

class UserEditProfileState extends State<_UserEditProfile> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map _user;
  List<Map> _genderList, _timezoneList;
  var _getUserProfile, _saveUserProfile;
  String  _firstName, 
          _lastName, 
          _gender, 
          _timezone, 
          _mobileNumber, 
          _workPhone, 
          _residencePhone, 
          _emergencyContact,
          _address,
          _city,
          _zipcode,
          _state,
          _country;

  void _handleSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map params = Map();      
      params["first_name"] = _firstName;
      params["last_name"] = _lastName;
      // params["gender"] = _gender;
      // params["mobile_number"] = _mobileNumber;
      // params["work_phone"] = _workPhone;
      // params["residence_phone"] = _residencePhone;
      // params["emergency_contact"] = _emergencyContact;
      // params["address"] = _address;
      // params["city"] = _city;
      // params["zipcode"] = _zipcode;
      // params["state"] = _state;
      // params["country"] = _country;
      // params["timezone"] = _timezone;
      _saveUserProfile(context, params);
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
        _saveUserProfile = stateObject["saveProfile"];
        int userId = stateObject["user_id"];
        _getUserProfile = stateObject["getProfile"];
        Map params = new Map();
        params["id"] = userId;        
        params["is_client"] = true;
        _getUserProfile(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["user_id"] = store.state.homeFitHomeState.user["id"];
        returnObject["user"] = store.state.userState.user;
        returnObject["saveProfile"] = (BuildContext context, Map params) =>
            store.dispatch(updateUserProfileDetails(context, params));
        returnObject["getProfile"] = (BuildContext context, Map params) =>
            store.dispatch(getUserProfileDetails(context, params));
        returnObject["genderList"] = store.state.userState.genderList;
        returnObject["timezoneList"] = store.state.userState.timezoneList;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) { 
        _user = stateObject["user"];
        _genderList = stateObject["genderList"];
        _timezoneList = stateObject["timezoneList"];
        if(_user != null && _genderList != null && _timezoneList != null) {  
          if(_user["gender"] != null) {
            _gender = _user["gender"].toString(); 
          }
          _timezone = _user["timezone"];
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
                'Update Profile',             
                style: TextStyle(
                  color: Colors.black87
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
                                style: new TextStyle(
                                  color: Colors.black87
                                ),
                                initialValue: _user["first_name"],
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: new TextStyle(color: Colors.black87),
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.black12
                                    )
                                  )
                                ),
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                },
                                onSaved: (value) {
                                  _firstName = value;
                                },
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0
                              ),
                              child: new TextFormField(
                                autofocus: false,
                                style: new TextStyle(
                                  color: Colors.black87
                                ),
                                initialValue: _user["last_name"],
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
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
                                    return 'Please enter your last name';
                                  }
                                },
                                onSaved: (value) {
                                  _lastName = value;
                                },
                              ),
                            ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),             
                            //   child: new DropdownFormField(
                            //     decoration: InputDecoration(
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black87,
                            //         ),
                            //       ),
                            //       labelText: 'Select Gender',
                            //       labelStyle: new TextStyle(
                            //         color: Colors.black87,
                            //       ),
                            //     ),
                            //     options: _genderList,
                            //     initialValue: _gender,                                
                            //     autovalidate: true,
                            //     validator: (value) {
                            //       if(value != null && value != "") { 
                            //         _gender = value;
                            //       }
                            //     },
                            //     onSaved: (value) {
                            //       if(value != null && value != "") { 
                            //         _gender = value;                                   
                            //       }
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),             
                            //   child: new DropdownFormField(
                            //     decoration: InputDecoration(
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black87,
                            //         ),
                            //       ),
                            //       labelText: 'Select Timezone',
                            //       labelStyle: new TextStyle(
                            //         color: Colors.black87,
                            //       ),
                            //     ),
                            //     options: _timezoneList,
                            //     initialValue: _timezone,                                
                            //     autovalidate: true,
                            //     validator: (value) {
                            //       if(value != null && value != "") { 
                            //         _timezone = value;
                            //       }
                            //     },
                            //     onSaved: (value) {
                            //       if(value != null && value != "") { 
                            //         _timezone = value;                                   
                            //       }
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["mobile_number"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Mobile Number',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _mobileNumber = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["work_phone"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Work Phone',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _workPhone = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["residence_phone"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Residence Phone',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _residencePhone = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["emergency_contact"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Emergency Contact',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _emergencyContact = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     maxLines: 3,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["address"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Address',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _address = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["city"],
                            //     decoration: InputDecoration(
                            //       labelText: 'City',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _city = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["state"],
                            //     decoration: InputDecoration(
                            //       labelText: 'State',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _state = value;
                            //     },
                            //   ),
                            // ),
                            // new Container(
                            //   padding: EdgeInsets.symmetric(
                            //     vertical: 8.0, horizontal: 8.0
                            //   ),
                            //   child: new TextFormField(
                            //     autofocus: false,
                            //     style: new TextStyle(
                            //       color: Colors.black87
                            //     ),
                            //     initialValue: _user["country"],
                            //     decoration: InputDecoration(
                            //       labelText: 'Country',
                            //       labelStyle: new TextStyle(color: Colors.black87),
                            //       border: new UnderlineInputBorder(
                            //         borderSide: new BorderSide(
                            //           color: Colors.black12
                            //         )
                            //       )
                            //     ),
                            //     validator: (value) {                                  
                            //     },
                            //     onSaved: (value) {
                            //       _country = value;
                            //     },
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
        else {
          return new Container();
        }
      }
    );
  }
}
