import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:homefit/core/app_state.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:homefit/home/views/subscribe.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/utils/gomotive_icons.dart';
import 'package:homefit/core/app_constants.dart';
import 'package:homefit/home/home_network.dart';
import 'package:homefit/utils/utils.dart';

class Plans extends StatelessWidget {

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
          child: _Plans(),
        )
      ),
    );
  }
}

class _Plans extends StatefulWidget {
  @override
  _PlansState createState() => new _PlansState();
}

class _PlansState extends State<_Plans> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  List<Map> _plans;
  var _user;
  var _signoutAPI;

  var individualPlanProductId = "com.gomotive.dhf.move.subscription";
  var familyPlanProductId = "com.gomotive.dhf.move.family_subscription";
  
  var _iOSIndividualPlan, _iOSFamilyPlan;
  Map _androidIndividualPlan, _androidFamilyPlan;
  
  init() async {
    var _iPlan;
    var _fPlan;
    
    List<String> productIds = [
      individualPlanProductId,
      familyPlanProductId
    ];
    await FlutterInappPurchase.initConnection;
    if (!mounted) return;
    List<IAPItem> _subscriptionProducts = await FlutterInappPurchase.getProducts(productIds);
    for(int i=0; i<_subscriptionProducts.length; i++) {
      if(_subscriptionProducts[i].productId == individualPlanProductId) {
        _iPlan = _subscriptionProducts[i];
      } else if(_subscriptionProducts[i].productId == familyPlanProductId) {
        _fPlan = _subscriptionProducts[i];
      }
    }
    try {
      setState(() {
        this._iOSIndividualPlan = _iPlan;
        this._iOSFamilyPlan = _fPlan;      
      });    
    }catch(except){}

  }

  @override
  initState() {
    super.initState();
    if(Utils.getDeviceType() == "ios") {
      init();
    }
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                     
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 64, 0, 0),
                            child: new Text(
                              "Step 2: Subscribe",
                              style: TextStyle(
                                fontSize: 32.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ), 
                          new Container(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget> [
                                new GestureDetector(
                                  onTap: () {     
                                    if(Utils.getDeviceType() == "ios" && _iOSIndividualPlan != null || 
                                      Utils.getDeviceType() == "android") {   

                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => 
                                          Subscribe(
                                            planType: "individual",
                                            planObject: _androidIndividualPlan,
                                            planDetails: _iOSIndividualPlan,
                                          )
                                        ),
                                      );  
                                    }
                                  },
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(vertical: 64.0,horizontal: 24.0),
                                    child: new Column(
                                      children: <Widget>[
                                        new Container(
                                          width: 300,
                                          height: 200,
                                          child: new Image.asset(
                                            'assets/images/individual_plan.jpg',                                  
                                          ),
                                        ),
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                          child: new Text(
                                            'Individual Subscription Plan',
                                            style: TextStyle(
                                              fontSize: 30
                                            ),
                                          ),                                        
                                        ),
                                        Utils.getDeviceType() == "ios" && _iOSIndividualPlan != null ? 
                                          new Container(
                                            padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                            child: new Text(
                                              _iOSIndividualPlan.localizedPrice + " / month",
                                              style: TextStyle(
                                                fontSize: 24
                                              )
                                            )
                                          )
                                        : new Container(),
                                        Utils.getDeviceType() == "android" ? 
                                          new Container(
                                            padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                            child: new Text(
                                              "USD " + _androidIndividualPlan["amount"].toString() + " / month",
                                              style: TextStyle(
                                                fontSize: 24.0
                                              )
                                            )
                                          )
                                        : new Container(),
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                          child: new Text(
                                            "Free 7 days trial",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                            )
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                new GestureDetector(
                                  onTap: () {  
                                    if(Utils.getDeviceType() == "ios" && _iOSFamilyPlan != null || 
                                      Utils.getDeviceType() == "android") {   
                                        
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => 
                                          Subscribe(
                                            planType: "family",
                                            planObject: _androidFamilyPlan,
                                            planDetails: _iOSFamilyPlan,
                                          )
                                        ),
                                      );  
                                    }
                                  },
                                  child: new Container(
                                    padding: EdgeInsets.symmetric(vertical: 64.0,horizontal: 24.0),
                                    child: new Column(
                                      children: <Widget>[
                                        new Container(
                                          width: 300,
                                          height: 200,
                                          child: new Image.asset(
                                            'assets/images/family_plan.jpg',                                  
                                          ),
                                        ),
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                          child: new Text(
                                            'Family Subscription Plan',
                                            style: TextStyle(
                                              fontSize: 30
                                            ),
                                          ),                                        
                                        ),
                                        _iOSFamilyPlan != null ? 
                                          new Container(
                                            padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                            child: new Text(
                                              _iOSFamilyPlan.localizedPrice + " / month",
                                              style: TextStyle(
                                                fontSize: 24
                                              )
                                            )
                                          )
                                        : new Container(),
                                        Utils.getDeviceType() == "android" ? 
                                          new Container(
                                            padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                            child: new Text(
                                              "USD " + _androidFamilyPlan["amount"].toString() + " / month",
                                              style: TextStyle(
                                                fontSize: 24.0
                                              )
                                            )
                                          )
                                        : new Container(),
                                        new Container(
                                          padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                          child: new Text(
                                            "Free 7 days trial",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red,
                                            )
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                          new Container(
                            width: 120.0,
                            child: MaterialButton(
                              height: 40.0, 
                              minWidth: 120.0,
                              color: dhfYellow,                                
                              child: new Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                )
                              ),
                              onPressed: () { 
                                _signoutAPI(context, {});          
                              },
                            ),                
                          ),                  
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
            color: Colors.transparent,
          ),
          onPressed: () {             
          },
        ),  
        actions: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
            child: GestureDetector(
              onTap:() {
                _signoutAPI(context, {});          
              },
              child: new Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: new Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.black87
                  )
                ),              
              )
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
                child: new Column(
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () {                          
                        if(Utils.getDeviceType() == "ios" && _iOSIndividualPlan != null || 
                          Utils.getDeviceType() == "android") {   
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => 
                              Subscribe(
                                planType: "individual",
                                planObject: _androidIndividualPlan,
                                planDetails: _iOSIndividualPlan,
                              )
                            ),
                          );  
                        }
                      },
                      child: new Container(
                        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 0.0),
                              child: new Text(
                                'Individual Subscription Plan',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),                                        
                            ),
                            new Container(                                
                              child: new Image.asset(
                                'assets/images/individual_plan.jpg',                                  
                              ),
                            ),                              
                            Utils.getDeviceType() == "ios" && _iOSIndividualPlan != null ? 
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 0.0),
                                child: new Text(
                                  _iOSIndividualPlan.localizedPrice + " / month",
                                  style: TextStyle(
                                    fontSize: 20
                                  )
                                )
                              )
                            : new Container(),
                            Utils.getDeviceType() == "android" ? 
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                child: new Text(
                                  "USD " + _androidIndividualPlan["amount"].toString() + " / month",
                                  style: TextStyle(
                                    fontSize: 24
                                  )
                                )
                              )
                            : new Container(),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 0.0),
                              child: new Text(
                                "Free 7 days trial",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.red,
                                )
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                    new GestureDetector(
                      onTap: () {     
                        if(Utils.getDeviceType() == "ios" && _iOSFamilyPlan != null || 
                          Utils.getDeviceType() == "android") {   
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => 
                              Subscribe(
                                planType: "family",
                                planObject: _androidFamilyPlan,
                                planDetails: _iOSFamilyPlan,
                              )
                            ),
                          );  
                        }
                      },
                      child: new Container(
                        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                color: Colors.blueGrey
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 0.0),
                              child: new Text(
                                'Family Subscription Plan',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                              ),                                        
                            ),
                            new Container(                                
                              child: new Image.asset(
                                'assets/images/family_plan.jpg',                                  
                              ),
                            ),                              
                            Utils.getDeviceType() == "ios" && _iOSFamilyPlan != null ? 
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 0.0),
                                child: new Text(
                                  _iOSFamilyPlan.localizedPrice + " / month",
                                  style: TextStyle(
                                    fontSize: 20
                                  )
                                )
                              )
                            : new Container(),
                            Utils.getDeviceType() == "android" ? 
                              new Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                                child: new Text(
                                  "USD " + _androidFamilyPlan["amount"].toString() + " / month",
                                  style: TextStyle(
                                    fontSize: 24
                                  )
                                )
                              )
                            : new Container(),
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 0.0),
                              child: new Text(
                                "Free 7 days trial",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.red,
                                )
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.symmetric(vertical: 64.0, horizontal: 0.0),
                    )
                  ],
                )
              )
            )
          );          
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
         DeviceOrientation.landscapeLeft, 
         DeviceOrientation.landscapeRight,
         DeviceOrientation.portraitDown,
         DeviceOrientation.portraitUp
         ]);
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) { 
        _signoutAPI = stateObject["userSignout"];       
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["userSignout"] = (BuildContext context, Map params) =>
            store.dispatch(userSignout(context, params));
        returnObject["user"] = store.state.homeFitHomeState.user;  
        returnObject["plans"] = store.state.homeFitHomeState.plans;      
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {    
        _user = stateObject["user"];
        _plans = stateObject["plans"];
        if(_user != null) {
          if(_plans != null) {
            for(int i=0; i<_plans.length; i++) {
              if(_plans[i]["tvos_plan_id"] == individualPlanProductId) {
                _androidIndividualPlan = _plans[i];
              } else if(_plans[i]["tvos_plan_id"] == familyPlanProductId) {
                _androidFamilyPlan = _plans[i];
              }
            }
          }
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
