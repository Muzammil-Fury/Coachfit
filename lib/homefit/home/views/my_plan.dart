import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/utils/menu_utils.dart';

class MyPlan extends StatelessWidget {

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
          child: _MyPlan(),
        )        
      ),
    );
  }
}

class _MyPlan extends StatefulWidget {
  @override
  _MyPlanState createState() => new _MyPlanState();
}

class _MyPlanState extends State<_MyPlan> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _getFamilyPlanMembers, _inviteFamilyMember, _deleteFamilyMember, _unSubscribeStripePaymentAPI;
  var _user;
  List<Map> _familyMembers;
  TextEditingController _c;

  _listFamilyMembers() {
    List<TableRow> members = new List();
    TableRow headingWidget = new TableRow(
      children: [
        new TableCell(
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
            child: Center(
              child: Text(
                "Name",
                style: TextStyle(fontSize: 24)
              ),
            ),
          ),
        ),
        new TableCell(
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
            child: Center(
              child: Text(
                "Action",
                style: TextStyle(fontSize: 24)
              ),
            ),
          ),          
        )
      ],
    );
    members.add(headingWidget);
    if(_familyMembers != null) {
      for(int i=0; i<_familyMembers.length; i++) {
        TableRow memberWidget = new TableRow(
          children: [
            new TableCell(
              child: new Container(
                padding: EdgeInsets.fromLTRB(10, 6, 0, 6),
                child: Text(
                  _familyMembers[i]["name"],
                  style: TextStyle(
                    fontSize: mobileLayout ? 16.0 : 24.0 
                  )
                ),
              ),
            ),
            !_familyMembers[i].containsKey("is_primary_user") ?
              new TableCell(
                child: new GestureDetector(
                  onTap: () async {
                    int confirm = await Utils.confirmDialog(context, "Delete", "Would you like to delete this family member?", "Yes, I do", "No");
                    if(confirm == 1) {
                      var params = new Map();
                      params['remove_user_id'] = _familyMembers[i]["id"];
                      _deleteFamilyMember(context, params);
                      _getFamilyPlanMembers(context, {});
                    }
                  },
                  child: new Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                    child: new Center(
                      child: new Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    )
                  )
                )
              )
            : new TableCell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 0.0),
                  child: new Center(
                    child: Text(
                      "Your account cannot be deleted",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    )
                  )
                )
              )
          ],
        );        
        members.add(memberWidget);                         
      }
    }
    return members;
  }
  
  @override
  initState() {
    _c = new TextEditingController();
    super.initState();
  }

  
  Widget _drawLargerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration: new BoxDecoration(
                        color: Colors.black26
                      ),
                      child: Utils.drawMenu(context, "subscribe")
                    ),                        
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
                      child: new Text(
                        "You have subscribed for ${_user['homefit_user']['plan']['name']}",
                        style: new TextStyle(
                          fontSize: 32,
                        )
                      ),
                    ),
                    _user["homefit_user"]["plan"]["membership_type"] == 2 ?
                      new Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),                                
                        child: new Text(
                          "You can invite upto 3 additional family members to use the App.",
                          style: TextStyle(fontSize: 20.0)
                        )                                                                      
                      )
                    : new Container(
                    ),
                    _familyMembers != null ?
                      new Container(     
                        padding: EdgeInsets.symmetric(
                          vertical: mobileLayout ? 16.0 : 32.0, 
                          horizontal: mobileLayout ? 16.0 : 64.0
                        ),                       
                        child: new Table(
                          border: TableBorder.all(width: 0.3, color: Colors.black38),
                          children: _listFamilyMembers()
                        )
                      )
                    : new Container(),
                    _familyMembers != null && _familyMembers.length < 4 ?
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 24.0),
                        child: new MaterialButton(
                          height: 50.0, 
                          minWidth: 120.0,
                          color: dhfYellow,
                          child: new Text(
                            'Invite User',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black87, 
                          onPressed: () {
                            showDialog(
                              context: context,
                              child: new AlertDialog(
                                contentPadding: const EdgeInsets.all(16.0),
                                content: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        autofocus: true,
                                        decoration: new InputDecoration(
                                          labelText: 'Email Address', 
                                        ),
                                        controller: _c,
                                      ),
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: const Text('Invite'),
                                    onPressed: () {
                                      var params = new Map();
                                      params['request_type'] = 'submit';
                                      params['email'] = _c.text;
                                      _inviteFamilyMember(context, params);
                                      _getFamilyPlanMembers(context, {});
                                      Navigator.pop(context);
                                    }
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : new Container(),
                    _user["homefit_user"]["payment_type"] == 2
                    ? new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 24.0),
                        child: new MaterialButton(
                          height: 50.0, 
                          minWidth: 120.0,
                          color: dhfYellow,
                          child: new Text(
                            'Unsubscribe',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black87, 
                          onPressed: () async {
                            int responseValue = await Utils.confirmDialog(
                              context, 
                              "Are you sure?", 
                              "Would you like to Unsubscribe?", 
                              "Yes, I am", 
                              "No"
                            );
                            if(responseValue == 1) {
                              Map _params = new Map();
                              _params["plan_id"] = _user["homefit_user"]["plan"]["id"];
                              this._unSubscribeStripePaymentAPI(context, _params);
                            }
                          },
                        ),
                      ) 
                    : new Container(),                                                          
                  ],
                )
              ),
            ),
          );
        }
      ),
    );            
  }

  Widget _drawSmallerDeviceWidget() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return new Scaffold(      
      key: _scaffoldKey,
      appBar: new AppBar(              
        backgroundColor: Colors.white,
        title: new Container(
          child: new Text(
            'Subscribe'
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        items: MenuUtils.buildNavigationMenuBar("subscribe"),
        onTap: (int index) {
          if(index != 2) {
            MenuUtils.menubarTap(
              context, "subscribe", index
            );
          }
        },
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
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[                      
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                      child: new Text(
                        "You have subscribed for ${_user['homefit_user']['plan']['name']}",
                        style: new TextStyle(
                          fontSize: 20,
                        ),              
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _user["homefit_user"]["plan"]["membership_type"] == 2 ?
                      new Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),                                
                        child: new Text(
                          "You can invite upto 3 additional family members to use the App.",
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
                        )                                                                      
                      )
                    : new Container(
                    ),
                    _familyMembers != null ?
                      new Container(     
                        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),                       
                        child: new Table(
                          border: TableBorder.all(width: 0.3, color: Colors.black38),
                          children: _listFamilyMembers()
                        )
                      )
                    : new Container(),
                    _familyMembers != null && _familyMembers.length < 4 ?
                      new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 24.0),
                        child: new MaterialButton(
                          height: 50.0, 
                          minWidth: 120.0,
                          color: dhfYellow,
                          child: new Text(
                            'Invite User',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black87, 
                          onPressed: () {
                            showDialog(
                              context: context,
                              child: new AlertDialog(
                                contentPadding: const EdgeInsets.all(16.0),
                                content: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        autofocus: true,
                                        decoration: new InputDecoration(
                                          labelText: 'Email Address', 
                                        ),
                                        controller: _c,
                                      ),
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: const Text('Invite'),
                                    onPressed: () {
                                      var params = new Map();
                                      params['request_type'] = 'submit';
                                      params['email'] = _c.text;
                                      _inviteFamilyMember(context, params);
                                      _getFamilyPlanMembers(context, {});
                                      Navigator.pop(context);
                                    }
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : new Container(),
                    _user["homefit_user"]["payment_type"] == 2
                    ? new Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 24.0),
                        child: new MaterialButton(
                          height: 50.0, 
                          minWidth: 120.0,
                          color: dhfYellow,
                          child: new Text(
                            'Unsubscribe',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black87, 
                          onPressed: () async {
                            int responseValue = await Utils.confirmDialog(
                              context, 
                              "Are you sure?", 
                              "Would you like to Unsubscribe?", 
                              "Yes, I am", 
                              "No"
                            );
                            if(responseValue == 1) {
                              Map _params = new Map();
                              _params["plan_id"] = _user["homefit_user"]["plan"]["id"];
                              this._unSubscribeStripePaymentAPI(context, _params);
                            }
                          },
                        ),
                      ) 
                    : new Container(),                                                         
                  ],
                )
              ),
            )
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft,
         DeviceOrientation.landscapeRight,
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {
        _getFamilyPlanMembers = stateObject["getFamilyPlanMembers"];
        _inviteFamilyMember = stateObject["inviteFamilyMember"]; 
        _deleteFamilyMember = stateObject["deleteFamilyMember"]; 
        _unSubscribeStripePaymentAPI = stateObject["unSubscribeStripePayment"];       
        if(stateObject["user"] != null && stateObject["user"]["homefit_user"]["plan"] != null && stateObject["user"]["homefit_user"]["plan"]["membership_type"] == 2) {
          var params = new Map();
          _getFamilyPlanMembers(context, params);
        }
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["getFamilyPlanMembers"] = (BuildContext context, Map params) =>
          store.dispatch(getFamilyPlanMembers(context, params));  
        returnObject["inviteFamilyMember"] = (BuildContext context, Map params) =>
          store.dispatch(inviteFamilyMember(context, params));  
        returnObject["deleteFamilyMember"] = (BuildContext context, Map params) =>
          store.dispatch(deleteFamilyMember(context, params));            
        returnObject["familyMembers"] = store.state.homeFitHomeState.familyPlanMemberList;
        returnObject["unSubscribeStripePayment"] = (BuildContext context, Map params) =>
          store.dispatch(unSubscribeStripePayment(context, params));  
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _user = stateObject["user"];
        _familyMembers = stateObject["familyMembers"];        
        if(_user != null) {
          if(mobileLayout) {
            return this._drawSmallerDeviceWidget();
          } else {
            return this._drawLargerDeviceWidget();
          }          
        } else {
          return new Container();
        }
      }          
    );
  }
}
