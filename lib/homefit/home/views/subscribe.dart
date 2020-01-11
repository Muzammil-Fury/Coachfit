import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:gomotive/homefit/core/app_constants.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/components/text_tap.dart';
import 'package:gomotive/homefit/core/app_config.dart';
import 'package:gomotive/homefit/utils/gomotive_icons.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Subscribe extends StatelessWidget {
  final String planType;
  final Map planObject;
  final IAPItem planDetails;
  Subscribe({
    this.planType,
    this.planObject,
    this.planDetails
  });

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
          child: _Subscribe(
            planType: this.planType,
            planObject: this.planObject,
            planDetails: this.planDetails
          ),
        )        
      ),
    );
  }
}

class _Subscribe extends StatefulWidget {
  final String planType;
  final Map planObject;
  final IAPItem planDetails;

  _Subscribe({
    this.planType,
    this.planObject,
    this.planDetails
  });
  @override
  _SubscribeState createState() => new _SubscribeState();
}

class _SubscribeState extends State<_Subscribe> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _savePlanAndTransactionReceiptAPI, _subscribeStripePaymentAPI;

  Map _user;

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
                  children: <Widget>[                    
                    new Container(            
                      padding: EdgeInsets.symmetric(vertical: 64.0,horizontal: 0.0),              
                      height: MediaQuery.of(context).size.height,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          widget.planType == "family" ?
                            new Container(
                              width: 300,
                              height: 200,
                              child: new Image.asset(
                                'assets/images/family_plan.jpg',                                  
                              ),
                            )
                          :  new Container(),
                          widget.planType == "family" ?
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                              child: new Text(
                                'Family Subscription Plan',
                                style: TextStyle(
                                  fontSize: 30
                                ),
                              ),                                        
                            )
                          :  new Container(),
                          widget.planType == "individual" ?
                            new Container(                                  
                              width: 300,
                              height: 200,
                              child: new Image.asset(
                                'assets/images/individual_plan.jpg',                                  
                              ),
                            )
                          :  new Container(),
                          widget.planType == "individual" ?
                            new Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                              child: new Text(
                                'Individual Subscription Plan',
                                style: TextStyle(
                                  fontSize: 30
                                ),
                              ),                                        
                            )
                          :  new Container(),
                          Utils.getDeviceType() == "ios"
                          ? new Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                              child: new Text(
                                "Price " + widget.planDetails.localizedPrice + " / month",
                                style: TextStyle(
                                  fontSize: 20
                                )
                              )
                            )
                          : new Container(),
                          Utils.getDeviceType() == "android"
                          ? new Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                              child: new Text(
                                "Price " + widget.planObject["amount"].toString() + " / month",
                                style: TextStyle(
                                  fontSize: 20
                                )
                              )
                            )
                          : new Container(),   
                          Utils.getDeviceType() == "ios"
                          ? new Column(
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                                  child: new Text(
                                    "Free 7 days trial",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.red,
                                    )
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                  child: new Text(
                                    "Access to all paid workouts.Payment will be charged to iTunes Account at confirmation of purchase",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                  child: new Text(
                                    "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period",
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                  child: new Text(
                                    "Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal",
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                  child: new Text(
                                    "Subscriptions can be managed by you from Account Settings and auto-renewal may be turned off by going to the your Account Settings after purchase",
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                  child: new Text(
                                    "Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable",
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.fromLTRB(0, 6, 0, 3),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        "Terms of Use - ",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        )
                                      ),
                                      new TextTap(
                                        "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/", 
                                        "web",
                                        "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
                                        textColor: Colors.green, 
                                        fontSize: 15.0,                                     
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3.0, horizontal: 0.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        "Privacy Policy - ",
                                        style: TextStyle(
                                          fontSize: 15.0,                                        
                                        )
                                      ),
                                      new TextTap(
                                        "https://dhf.gomotive.com/privacy_policy", 
                                        "web",
                                        "https://dhf.gomotive.com/privacy_policy",
                                        textColor: Colors.green, 
                                        fontSize: 15.0,                                     
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ) 
                          : new Container(),                                                
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                  child: MaterialButton(
                                    height: 50.0, 
                                    minWidth: 120.0,
                                    color: dhfYellow,
                                    child: new Text(
                                      'Subscribe',
                                      textScaleFactor: 1.5,
                                    ),
                                    textColor: Colors.black87, 
                                    onPressed: () async { 
                                      if(Utils.getDeviceType() == "ios") {
                                        try {
                                          PurchasedItem purchased = await FlutterInappPurchase.buyProduct(widget.planDetails.productId);
                                          if(purchased != null && purchased.transactionReceipt != null) {
                                            var params = new Map();
                                            params["plan_id"] = widget.planDetails.productId;
                                            params["receipt"] = purchased.transactionReceipt;
                                            _savePlanAndTransactionReceiptAPI(context, params);
                                          }
                                        } catch(except) {                                
                                        }
                                      } else if(Utils.getDeviceType() == "android") {
                                        StripeSource.addSource().then((String token) {
                                          Map params = new Map();
                                          params["plan_id"] = widget.planObject["id"];
                                          params["stripe_token"] = token;
                                          this._subscribeStripePaymentAPI(context, params);
                                        });
                                      }                                                        
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                  child: MaterialButton(
                                    height: 50.0, 
                                    minWidth: 120.0,
                                    color: Colors.grey,
                                    child: new Text(
                                      'Back',
                                      textScaleFactor: 1.5,
                                    ),
                                    textColor: Colors.black87, 
                                    onPressed: () {                                        
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            )
                          )
                        ],
                      ),
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
            'Step 2: Subscribe'
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
                child: new Column(
                  children: <Widget>[
                    widget.planType == "family" ?
                      new Container(
                        child: new Image.asset(
                          'assets/images/family_plan.jpg',                                  
                        ),
                      )
                    :  new Container(),
                    widget.planType == "family" ?
                      new Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                        child: new Text(
                          'Family Subscription Plan',
                          style: TextStyle(
                            fontSize: 24
                          ),
                          textAlign: TextAlign.center,
                        ),                                        
                      )
                    :  new Container(),
                    widget.planType == "individual" ?
                      new Container(                                                          
                        child: new Image.asset(
                          'assets/images/individual_plan.jpg',                                  
                        ),
                      )
                    :  new Container(),
                    widget.planType == "individual" ?
                      new Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
                        child: new Text(
                          'Individual Subscription Plan',
                          style: TextStyle(
                            fontSize: 24
                          ),
                          textAlign: TextAlign.center,
                        ),                                        
                      )
                    :  new Container(),
                    Utils.getDeviceType() == "ios"
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4.0),
                        child: new Text(
                          "Price " + widget.planDetails.localizedPrice + " / month",
                          style: TextStyle(
                            fontSize: 20
                          )
                        )
                      )
                    : new Container(),
                    Utils.getDeviceType() == "android"
                    ? new Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4.0),
                        child: new Text(
                          "Price " + widget.planObject["amount"].toString() + " / month",
                          style: TextStyle(
                            fontSize: 20
                          )
                        )
                      )
                    : new Container(),
                    Utils.getDeviceType() == "ios"
                    ? new Column(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 0.0),
                            child: new Text(
                              "Free 7 days trial",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                              )
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "Access to all paid workouts.Payment will be charged to iTunes Account at confirmation of purchase",
                              style: TextStyle(
                                fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period",
                              style: TextStyle(
                                fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal",
                              style: TextStyle(
                                fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "Subscriptions can be managed by you from Account Settings and auto-renewal may be turned off by going to the your Account Settings after purchase",
                              style: TextStyle(
                                fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new Text(
                              "Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable",
                              style: TextStyle(
                                fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new TextTap(
                              "Terms of Use", 
                              "web",
                              "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/",
                              textColor: Colors.green, 
                              fontSize: 15.0,                                     
                            ),                      
                          ),
                          new Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            child: new TextTap(
                              "Privacy Policy", 
                              "web",
                              "https://dhf.gomotive.com/privacy_policy",
                              textColor: Colors.green, 
                              fontSize: 15.0,                                     
                            ),
                          ),
                        ],
                      )
                    : new Container(),                    
                    new Container(
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 64),
                      child: new Container(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                        child: MaterialButton(
                          height: 50.0, 
                          minWidth: 120.0,
                          color: dhfYellow,
                          child: new Text(
                            'Subscribe',
                            textScaleFactor: 1.5,
                          ),
                          textColor: Colors.black87, 
                          onPressed: () async { 
                            if(Utils.getDeviceType() == "ios") {
                              try {
                                PurchasedItem purchased = await FlutterInappPurchase.buyProduct(widget.planDetails.productId);
                                if(purchased != null && purchased.transactionReceipt != null) {
                                  var params = new Map();
                                  params["plan_id"] = widget.planDetails.productId;
                                  params["receipt"] = purchased.transactionReceipt;
                                  _savePlanAndTransactionReceiptAPI(context, params);
                                }
                              } catch(except) {                                
                              }
                            } else if(Utils.getDeviceType() == "android") {
                              StripeSource.addSource().then((String token) {
                                Map params = new Map();
                                params["plan_id"] = widget.planObject["id"];
                                params["stripe_token"] = token;
                                this._subscribeStripePaymentAPI(context, params);
                              });
                            }                                                        
                          },
                        ),
                      ),                      
                    )
                  ],
                ),
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
        _savePlanAndTransactionReceiptAPI = stateObject["savePlanAndTransactionReceipt"];
        _subscribeStripePaymentAPI = stateObject["subscribeStripePayment"];
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["user"] = store.state.homeFitHomeState.user;
        returnObject["savePlanAndTransactionReceipt"] = (BuildContext context, Map params) =>
          store.dispatch(savePlanAndTransactionReceipt(context, params));  
        returnObject["subscribeStripePayment"] = (BuildContext context, Map params) =>
          store.dispatch(subscribeStripePayment(context, params));  
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _user  = stateObject["user"];
        if(_user != null) {
          StripeSource.setPublishableKey(_user["stripe_publishable_key"]);
        }
        if(mobileLayout) {
          return this._drawSmallerDeviceWidget();
        } else {
          return this._drawLargerDeviceWidget();
        }        
      } 
    );
  }
}
