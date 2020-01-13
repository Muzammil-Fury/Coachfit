import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gomotive/homefit/home/home_network.dart';
import 'package:gomotive/homefit/home/views/verify_user.dart';
import 'package:redux/redux.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/client/client_network.dart';
import 'package:gomotive/auth/auth_network.dart';
import 'package:gomotive/client/client_utils.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/components/text_tap.dart';
import 'package:gomotive/components/thumbnail.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/client/views/client_workouts_today.dart';
import 'package:gomotive/news/views/news_view.dart';
import 'package:gomotive/client/views/client_habits_today.dart';
import 'package:gomotive/client/views/client_programs.dart';
import 'package:gomotive/client/views/client_nutrition.dart';
import 'package:gomotive/core/app_config.dart';

class ClientHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
        top: false,        
        bottom: false,
        child: _ClientHome(),
      ),
    );
  }
}

class _ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => new _ClientHomeState();
}

class _ClientHomeState extends State<_ClientHome> {  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String _pageName = "home";
  List<Map> _menuList;

  String _title, _workoutImageUrl;
  int _programCount;
  String _programType;
  int _programId;
  List<Map> _newsList;
  int _unreadMessgeCount, _unreadChatCount, _intakeFormCount;
  Map _businessPartner;

  var _getClientHomePageDetailsAPI, _getPartnerDetailsApi, _homefitVerifyUser;

  @override
  Widget build(BuildContext context) {
    initialContext = context;
    return new StoreConnector<AppState, Map>(
      onInitialBuild: (Map stateObject) {        
        _getClientHomePageDetailsAPI = stateObject["getClientHomePageDetailsAPI"];
        _getPartnerDetailsApi = stateObject["partnerDetailsAPI"];
        _homefitVerifyUser = stateObject["homefitVerifyUserAPI"];
        _getClientHomePageDetailsAPI(context, {});
        var params = new Map();
        params["subdomain"] = partnerSubdomain;
        _getPartnerDetailsApi(context, params);
      },
      converter: (Store<AppState> store) {
        Map<String, dynamic> returnObject = new Map();
        returnObject["getClientHomePageDetailsAPI"] = (BuildContext context, Map params) =>
            store.dispatch(getHomePageDetails(context, params));
        returnObject["partnerDetailsAPI"] = (BuildContext context, Map params) =>
            store.dispatch(getPartnerDetails(context, params));
        returnObject["homefitVerifyUserAPI"] = (BuildContext context, Map params) =>
            store.dispatch(homefitVerifyUser(context, params));
        returnObject["menuList"] = store.state.clientState.menuItems;
        returnObject["title"] = store.state.clientState.homePageTitle;
        returnObject["workoutImageUrl"] = store.state.clientState.workoutImageUrl;
        returnObject["newsList"] = store.state.clientState.newsList;
        returnObject["programCount"] = store.state.clientState.programCount;
        returnObject["programType"] = store.state.clientState.programType;
        returnObject["programId"] = store.state.clientState.programId;
        returnObject["unreadMessageCount"] = store.state.clientState.unreadMessageCount;
        returnObject["unreadChatCount"] = store.state.clientState.unreadChatCount;
        returnObject["businessPartner"] = store.state.authState.businessPartner;
        returnObject["intakeFormCount"] = store.state.clientState.intakeFormCount;
        return returnObject;
      },
      builder: (BuildContext context, Map stateObject) {
        _menuList = stateObject["menuList"];
        _title = stateObject["title"];
        _workoutImageUrl = stateObject["workoutImageUrl"];
        _newsList = stateObject["newsList"];
        _programCount = stateObject["programCount"];
        _programType = stateObject["programType"];
        _programId = stateObject["programId"];
        _unreadMessgeCount = stateObject["unreadMessageCount"];
        _unreadChatCount = stateObject["unreadChatCount"];
        _businessPartner = stateObject["businessPartner"]; 
        _intakeFormCount = stateObject["intakeFormCount"];
        if(_menuList != null && _businessPartner != null) {
          int _currentIndex = ClientUtils.getCurrentIndex(_menuList, "_pageName");
          return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              leading: IconButton(                  
                icon: Icon(
                  GomotiveIcons.back,
                  size: 40.0,
                  color:primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home/route');
                },
              ),
              backgroundColor: Colors.white,
              title: new Text(
                _title,             
                style: TextStyle(
                  color: Colors.black87
                )   
              ),              
              actions: <Widget>[ 
                new Container(
                  padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                        icon: Icon(
                          GomotiveIcons.chat,
                          size: 36,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed("/client/connect");
                        },
                      ),
                      new Positioned(
                        child: new Stack(
                          children: <Widget>[
                            new Icon(
                              Icons.brightness_1,
                              size: 30.0, 
                              color: Colors.black87                              
                            ),
                            new Positioned(
                              top: 7.0,
                              left: 7.0,
                              child: new Center(                          
                                child: new Text(
                                  (_unreadMessgeCount + _unreadChatCount + _intakeFormCount).toString(),
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  )                  
                ),                
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: ClientUtils.buildNavigationMenuBar(_menuList, _pageName),
              onTap: (int index) {
                ClientUtils.menubarTap(
                  context, _menuList, _pageName, index, _programCount, _programType, _programId
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.white,
              onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>new VerifyUser()));
              }
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
                          _workoutImageUrl != null ? 
                            new GestureDetector(
                              onTap: () {
                                if(_programCount == 0) {
                                  CustomDialog.alertDialog(
                                    context, 
                                    "No Workouts Assigned.", 
                                    "You do not have any habits assinged by your practitioner. Kindly get in touch with your practitioner by clicking on the chat icon in top right hand corner."
                                  );
                                } else if(_programCount == 1) {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new ClientWorkoutsToday(
                                        type: _programType,
                                        id: _programId,
                                        displayProgramTitle: false,
                                      ),
                                    ),
                                  );                                  
                                } else {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new ClientPrograms(
                                        type: "workout",                                        
                                      ),
                                    ),
                                  );                            
                                }
                              },                            
                              child: new Stack(
                                alignment: AlignmentDirectional.bottomCenter,                              
                                children: <Widget>[
                                  new Container(
                                    height: MediaQuery.of(context).size.height/3,
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(_workoutImageUrl),
                                      ),
                                    ),
                                  ),                                  
                                  new Positioned(  
                                    child: new Chip( 
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                   
                                      avatar: Icon(
                                        GomotiveIcons.play,
                                        color: Colors.green,
                                      ),
                                      label: new Text(
                                        'MY WORKOUTS',
                                        style: TextStyle(
                                          fontSize: 16.0
                                        )
                                      ),
                                    ),                                                            
                                  ),
                                ],
                              )
                            )                            
                          : new GestureDetector(
                              onTap: () {
                                if(_programCount == 0) {
                                  CustomDialog.alertDialog(
                                    context, 
                                    "No Habits Assigned.", 
                                    "You do not have any habits assinged by your practitioner. Kindly get in touch with your practitioner by clicking on the chat icon in top right hand corner."
                                  );
                                } else if(_programCount == 1) {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new ClientWorkoutsToday(
                                        type: _programType,
                                        id: _programId,
                                        displayProgramTitle: false,
                                      ),
                                    ),
                                  );                                  
                                } else {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => new ClientPrograms(
                                        type: "workout",                                        
                                      ),
                                    ),
                                  );                                    
                                }                                    
                              },
                              child: new Stack(
                                alignment: AlignmentDirectional.bottomCenter,                              
                                children: <Widget>[
                                  new Container(
                                    height: MediaQuery.of(context).size.height/3,
                                    decoration: const BoxDecoration(
                                      image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: const AssetImage("assets/images/clients.jpeg"),
                                      ),
                                    ),
                                  ),
                                  new Positioned(  
                                    child: new Chip( 
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                   
                                      avatar: Icon(
                                        GomotiveIcons.play,
                                        color: Colors.green,
                                      ),
                                      label: new Text(
                                        'WORKOUTS',
                                        style: TextStyle(
                                          fontSize: 16.0
                                        )
                                      ),
                                    ),                                                            
                                  ),
                                ],
                              )                            
                            ),
                          _businessPartner["client_engagement_type"] == "gameplan"
                          ? new Container(    
                              child: new Column(
                                children: <Widget>[
                                  new GestureDetector(
                                    onTap: () {      
                                      if(_programCount == 0) {
                                        CustomDialog.alertDialog(context, "No Habits Assigned.", "You do not have any habits assinged by your practitioner. Kindly get in touch with your practitioner by clicking on the Connect feature.");
                                      } else if(_programCount == 1) {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new ClientHabitsToday(
                                              type: _programType,
                                              id: _programId,
                                              displayProgramTitle: false,
                                            ),
                                          ),
                                        );                                  
                                      } else {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new ClientPrograms(
                                              type: "habit",                                        
                                            ),
                                          ),
                                        );
                                      }                                
                                    },       
                                    child: new Container(
                                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                      child: new Stack(
                                        alignment: AlignmentDirectional.bottomCenter,                              
                                        children: <Widget>[
                                          new Container(
                                            height: MediaQuery.of(context).size.height/3,
                                            decoration: const BoxDecoration(
                                              image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: const AssetImage("assets/images/habits.jpeg"),
                                              ),
                                            ),
                                          ),                                  
                                          new Positioned(  
                                            child: new Chip( 
                                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                   
                                              avatar: Icon(
                                                GomotiveIcons.habits,
                                                color: Colors.green,
                                              ),
                                              label: new Text(
                                                'MY HABITS',
                                                style: TextStyle(
                                                  fontSize: 16.0
                                                )
                                              ),
                                            ),                                                            
                                          ),
                                        ],
                                      )
                                    )
                                  ),
                                  new GestureDetector(
                                    onTap: () {
                                      if(_programCount == 0) {
                                        CustomDialog.alertDialog(context, "No Nutrition Assigned.", "You do not have any nutrition and guidance documents assinged by your practitioner. Kindly get in touch with your practitioner by clicking on the Connect feature.");
                                      } else if(_programCount == 1) {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new ClientNutrition(
                                              type: _programType,
                                              id: _programId,
                                              displayProgramTitle: false,
                                            ),
                                          ),
                                        );                                  
                                      } else {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new ClientPrograms(
                                              type: "nutrition",                                        
                                            ),
                                          ),
                                        );
                                      }                                                                            
                                    },    
                                    child: new Container(
                                      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),                      
                                      child: new Stack(
                                        alignment: AlignmentDirectional.bottomCenter,                              
                                        children: <Widget>[
                                          new Container(                                          
                                            height: MediaQuery.of(context).size.height/3,
                                            decoration: const BoxDecoration(
                                              image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: const AssetImage("assets/images/nutrition.jpeg"),
                                              ),
                                            ),
                                          ),                                  
                                          new Positioned(  
                                            child: new Chip( 
                                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),                                   
                                              avatar: Icon(
                                                GomotiveIcons.nutrition,
                                                color: Colors.green,
                                              ),
                                              label: new Text(
                                                'MY NUTRITION & GUIDANCE',
                                                style: TextStyle(
                                                  fontSize: 16.0
                                                )
                                              ),
                                            ),                                                            
                                          ),
                                        ],
                                      )
                                    )
                                  )
                                ],
                              )                          
                            )
                          : new GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("/client/connect");
                              },
                              child: new Container(          
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),                  
                                child: new Stack(
                                  alignment: AlignmentDirectional.bottomCenter,                              
                                  children: <Widget>[
                                    new Container(
                                      height: MediaQuery.of(context).size.height/3,
                                      decoration: const BoxDecoration(
                                        image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          image: const AssetImage("assets/images/connect.jpeg"),
                                        ),
                                      ),
                                    ),
                                    new Positioned(  
                                      child: new Chip(
                                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                        avatar: Icon(
                                          GomotiveIcons.connect,
                                          color: primaryColor,
                                        ),                                                                        
                                        label: new Text(
                                          'CONNECT',
                                          style: TextStyle(
                                            fontSize: 16.0
                                          )
                                        ),
                                      ),                                                            
                                    ),
                                  ],
                                )
                              ),
                            ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                  child: new Text(
                                    'Discover Posts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    )
                                  )
                                ),
                                new Container(
                                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                  child: new TextTap(
                                    "View All", 
                                    "route",
                                    "/client/news/list",
                                    textColor: Colors.green
                                  ),
                                )
                              ],                              
                            )
                          ),
                          _newsList.length > 0 ?
                            new Container(
                              height: 200,
                              child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _newsList.length,
                                itemBuilder: (context, i) {
                                  return new GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new NewsView(
                                            newsId: _newsList[i]["id"],                            
                                          ),
                                        ),
                                      );                                      
                                    },
                                    child: new Container(
                                      padding: EdgeInsets.symmetric(vertical:0.0, horizontal: 12.0),                                     
                                      child: new Stack(
                                        overflow: Overflow.clip,
                                        children: <Widget>[
                                          new Thumbnail(
                                            url: _newsList[i]["cover_media"] != null ? _newsList[i]["cover_media"]["thumbnail_url"] : "",
                                            defaultImage: "assets/images/generic_news.jpg",
                                          ),
                                          new Positioned(
                                            top: 1.0,                                                                                         
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black87
                                              ),
                                              child: new Text(
                                                _newsList[i]["title"],
                                                style: TextStyle(
                                                  color: Colors.white
                                                )
                                              )
                                            )                                                       
                                          ),
                                        ],
                                      ),                                      
                                    ),
                                  );
                                }
                              )
                            )
                          : new Container()
                        ]
                      )
                    ),
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
