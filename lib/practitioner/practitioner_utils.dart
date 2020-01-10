import 'package:flutter/material.dart';
import 'package:gomotive/utils/gomotive_icons.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/core/app_constants.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/practitioner/views/practitioner_clients.dart';
import 'package:gomotive/dhf/views/dhf_movement_meter.dart';
import 'package:gomotive/gi/views/engagement_assessments_3dmaps.dart';
import 'package:gomotive/conversation/views/conversation_chat.dart';
import 'package:gomotive/workout/views/engagement_workouts.dart';
import 'package:gomotive/document/views/engagement_documents.dart';
import 'package:gomotive/habit/views/engagement_habits.dart';
import 'package:gomotive/intake/views/engagement_intakes.dart';
import 'package:gomotive/assessment/views/engagement_assessments.dart';
import 'package:gomotive/goal/views/engagement_goal.dart';
import 'package:gomotive/user/views/user_movement_meter_weekly_graph.dart';

class PractitionerUtils {

  static const practitionerMenuRouteOptions = <String, String>  {    
    'home': "/practitioner/home",
    'education': "/practitioner/education",
    'exercises': "/practitioner/exercises",
    'news': "/practitioner/news/list",    
    'profile': "/practitioner/profile"
  };

  static int getCurrentIndex(List<Map> _menuList, String _pageName) {
    for(int i=0; i<_menuList.length; i++) {
      if(_menuList[i]["name"] == _pageName) {
        return i;
      }
    }
    return 0;
  }

  static buildNavigationMenuBar(List<Map> _menuList, String _pageName) {

    final _clientMenuIcons = <String, IconData>  {
      'home': GomotiveIcons.home,
      'education': Icons.bookmark_border,
      'exercises': GomotiveIcons.exercise,
      'news': GomotiveIcons.news, 
      'profile': null     
    };
    List<BottomNavigationBarItem> _navigationItemList = new List<BottomNavigationBarItem>();
    if(_menuList != null) {      
      for(int i=0; i<_menuList.length; i++) {
        if(_menuList[i]["name"] != 'profile') {
          BottomNavigationBarItem widget = new BottomNavigationBarItem(
            icon: new Icon(
              _clientMenuIcons[_menuList[i]["name"]],
              color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
            ),
            title: new Text(
              _menuList[i]["title"],
              style: TextStyle(
                color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              )
            ),
          );
          _navigationItemList.add(widget);
        } else {
          BottomNavigationBarItem widget = new BottomNavigationBarItem(
            icon: new Image.asset(
              "assets/images/user_profile.png",
              color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              width: 32,
            ),            
            title: new Text(
              _menuList[i]["title"],
              style: TextStyle(
                color: _pageName == _menuList[i]["name"] ? primaryColor : Colors.black87,
              )
            ),
          );
          _navigationItemList.add(widget);
        }
      }
    }
    return _navigationItemList;
  }

  static menubarTap(
    BuildContext context, List<Map> menuList, String pageName, int index) {
    if(menuList[index]["name"] != pageName) {
      if(index == 0) {
        Navigator.of(context).pushReplacementNamed(
          "/practitioner/home"
        );
      } else {
        Navigator.of(context).pushNamed(
          PractitionerUtils.practitionerMenuRouteOptions[menuList[index]["name"]]
        );
      }
    }
  }
  
  static Widget drawPractitionerHomePage(String partnerSubdomain, BuildContext context) {
    Container container = new Container(
      child: new Column(
        children: <Widget>[          
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new PractitionerClients(
                    flowType: "client_home",
                  ),
                ),
              );                    
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
                        image: const AssetImage("assets/images/clients.jpeg"),
                      ),
                    ),
                  ),
                  new Positioned(  
                    child: new Chip(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      avatar: Icon(
                        GomotiveIcons.clients,
                      ),                                                                        
                      label: new Text(
                        'CLIENTS',
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
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/practitioner/client/invite");
            },
            child: new Container(          
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),                  
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,                              
                children: <Widget>[
                  partnerAppType == "gi"
                    ? new Container(
                        height: MediaQuery.of(context).size.height/3,
                        decoration: const BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: const AssetImage(
                                "assets/images/connect.jpeg"
                              )                          
                          ),
                        ),
                      )
                    : new Container(),
                  partnerAppType == "dhf"
                    ? new Container(
                        height: MediaQuery.of(context).size.height/3,
                        decoration: const BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: const AssetImage(
                                "assets/images/invite_client.jpeg"
                              )                          
                          ),
                        ),
                      )
                    : new Container(),
                  new Positioned(  
                    child: new Chip(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      avatar: Icon(
                        GomotiveIcons.message,
                        size: 14.0,
                      ),                                                                        
                      label: new Text(
                        'INVITE CLIENT',
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
          partnerAppType == "dhf"
          ? new Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: new Text(
                'Movement Meters',
                style: TextStyle(
                  fontSize: 18.0
                ),
                textAlign: TextAlign.left,
              )
            )
          : new Container(),
          partnerAppType == "dhf"
          ? new Container(
              height: 150,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: new ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: <Widget>[
                  new RawMaterialButton(
                    onPressed: () {
                      if(selectedRole["is_dhf_assessment_enabled"]) { 
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new DHFMovementMeter(
                              movementMeterType: "Mobility",
                            ),
                          ),
                        );                      
                      } else {
                        CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                      }
                    },
                    child: new Column(
                      children: <Widget> [
                        new Image.asset(
                          'assets/images/dhf_mobility.png'
                        ),
                        new Text(
                          'Mobility',
                          style: TextStyle(
                            fontSize: 24.0
                          )
                        )
                      ]
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.lightBlue,
                    padding: const EdgeInsets.all(30.0),
                  ),
                  new RawMaterialButton(
                    onPressed: () {        
                      if(selectedRole["is_dhf_assessment_enabled"]) { 
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new DHFMovementMeter(
                              movementMeterType: "Strength",
                            ),
                          ),
                        );              
                      } else {
                        CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Strength program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                      }
                    },
                    child: new Column(
                      children: <Widget> [
                        new Image.asset(
                          'assets/images/dhf_strength.png'
                        ),
                        new Text(
                          'Strength',
                          style: TextStyle(
                            fontSize: 24.0
                          )
                        )
                      ]
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.lightGreen,
                    padding: const EdgeInsets.all(30.0),
                  ),                  
                  new RawMaterialButton(
                    onPressed: () {    
                      if(selectedRole["is_dhf_assessment_enabled"]) {  
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new DHFMovementMeter(
                              movementMeterType: "Metabolic",
                            ),
                          ),
                        );                 
                      } else {
                        CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                      }
                    },
                    child: new Column(
                      children: <Widget> [
                        new Image.asset(
                          'assets/images/dhf_metabolic.png'
                        ),
                        new Text(
                          'Metabolic',
                          style: TextStyle(
                            fontSize: 24.0
                          )
                        )
                      ]
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.yellow,
                    padding: const EdgeInsets.all(30.0),
                  ),
                  new RawMaterialButton(
                    onPressed: () {  
                      if(selectedRole["is_dhf_assessment_enabled"]) { 
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new DHFMovementMeter(
                              movementMeterType: "Power",
                            ),
                          ),
                        );                    
                      } else {
                        CustomDialog.alertDialog(context, "Access Denied", "You have not subscribed for Mobility program. Kindly contact DHF team by sending an email to info@dynamichealthfitness.com.");
                      }
                    },
                    child: new Column(
                      children: <Widget> [
                        new Image.asset(
                          'assets/images/dhf_power.png'
                        ),
                        new Text(
                          'Power',
                          style: TextStyle(
                            fontSize: 24.0
                          )
                        )
                      ]
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.red,
                    padding: const EdgeInsets.all(30.0),
                  ),
                ],
              )
            )
          : new Container(),
          new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: new Text(
              'GI Specialities',
              style: TextStyle(
                fontSize: 18.0
              ),
              textAlign: TextAlign.left,
            )
          ),          
          new Container(
            height: 150,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                new GestureDetector(
                  onTap:() {
                    if(selectedRole["is_3dmaps_enabled"]) {
                      Navigator.of(context).pushNamed("/gi/3dmaps");                                        
                    } else {
                      CustomDialog.alertDialog(context, "Access Denied", "If you have purchased course already you must complete and pass the online test to gain access into the library. If you have passed the test, kindly logout/login and try again. If you have not purchased the course, please contact GrayInstitute at info@grayinstitute.com.");
                    } 
                  },
                  child: new Container(
                    width: 160,
                    height: 160,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        image: const AssetImage("assets/images/gi_3dmaps.jpg"),
                      ),
                    ),                  
                  ),
                ),
                new GestureDetector(
                  onTap:() {
                    if(selectedRole["is_gi_golf_enabled"]) {
                      Navigator.of(context).pushNamed("/gi/golf");                                        
                    } else {
                      CustomDialog.alertDialog(context, "Access Denied", "If you have purchased course already you must complete and pass the online test to gain access into the library. If you have passed the test, kindly logout/login and try again. If you have not purchased the course, please contact GrayInstitute at info@grayinstitute.com.");
                    }
                  },
                  child: new Container(
                    width: 160,
                    height: 160,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    decoration: const BoxDecoration(
                      image: const DecorationImage(
                        image: const AssetImage("assets/images/gi_golf.jpg"),
                      ),
                    ),                  
                  ),
                ),                
              ],
            )
          ),
        ]
      )
    );
    return container;

  }


  static Widget drawClientHomePage(
    BuildContext context,
    String partnerSubdomain, 
    Map _clientObj,
    bool _isGoalDefined,
    var _closeEngagementAPI,
  ) {
    if(partnerAppType == "gi") {
      return Container(                              
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: new GestureDetector(
                      onTap:() {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementAssessments3DMAPS(                              
                            ),
                          ),
                        );
                      },
                      child: new PhysicalModel(
                        borderRadius: new BorderRadius.circular(75.0),
                        color: Colors.blueGrey,
                        child: new Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(75.0),                                  
                          ),
                          child: new Center(
                            child: new Text(
                              '3DMAPS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white
                              )
                            )
                          ),
                        ),
                      ),                            
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: new GestureDetector(
                      onTap:() {
                        if(_clientObj != null) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new EngagementWorkouts(
                                clientId: _clientObj["client"]["id"],
                                engagementId: _clientObj["active_engagement_id"]                          
                              ),
                            ),
                          );                                      
                        }
                      },
                      child: new PhysicalModel(
                        borderRadius: new BorderRadius.circular(75.0),
                        color: Colors.blueGrey,
                        child: new Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(75.0),                                  
                          ),
                          child: new Center(
                            child: new Text(
                              'Workouts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white
                              )
                            )
                          ),
                        ),
                      ),                            
                    ),
                  ),
                ],
              )
            ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: new GestureDetector(
                      onTap:() {
                        if(selectedUser["id"] != _clientObj["client"]["id"]) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new ConversationChat(
                                conversationId: _clientObj["conversation_id"],
                              ),
                            ),
                          );
                        } else {
                          CustomDialog.alertDialog(context, "Your own account", "This is your own account. Conversation has been disabled.");
                        }
                      },
                      child: new PhysicalModel(
                        borderRadius: new BorderRadius.circular(75.0),
                        color: Colors.blueGrey,
                        child: new Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(75.0),                                  
                          ),
                          child: new Center(
                            child: new Text(
                              'Connect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white
                              )
                            )
                          ),
                        ),
                      ),                            
                    ),
                  ),
                  // new Container(
                  //   padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  //   child: new GestureDetector(
                  //     onTap:() {
                  //       CustomDialog.alertDialog(context, "WIP", "Feature yet to be implemented");
                  //     },
                  //     child: new PhysicalModel(
                  //       borderRadius: new BorderRadius.circular(75.0),
                  //       color: Colors.blueGrey,
                  //       child: new Container(
                  //         width: 150.0,
                  //         height: 150.0,
                  //         decoration: new BoxDecoration(
                  //           borderRadius: new BorderRadius.circular(75.0),                                  
                  //         ),
                  //         child: new Center(
                  //           child: new Text(
                  //             'Send Video',
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //               fontSize: 24.0,
                  //               color: Colors.white
                  //             )
                  //           )
                  //         ),
                  //       ),
                  //     ),                            
                  //   ),
                  // ),                                        
                ],
              )
            ),                                                                    
          ],
        )
      );
    } else if(partnerAppType == "dhf") {
      return Container(  
        child: new Column(
          children: <Widget>[
            new Wrap(
              spacing: 12.0, // gap between adjacent chips
              runSpacing: 12.0,
              alignment: WrapAlignment.center,          
              children: <Widget>[
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(selectedUser["id"] != _clientObj["client"]["id"]) {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new ConversationChat(
                              conversationId: _clientObj["conversation_id"],
                            ),
                          ),
                        );
                      } else {
                        CustomDialog.alertDialog(context, "Your own account", "This is your own account. Conversation has been disabled.");
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: Colors.blueAccent,
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Chat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
                new Container(                                              
                  child: new GestureDetector(
                    onTap:() {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new EngagementGoal(
                            clientId: _clientObj["client"]["id"],
                            engagementId: _clientObj["active_engagement_id"],
                          ),
                        ),
                      );                        
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: Colors.blueAccent,
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Goal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementIntakes(
                              client: _clientObj["client"],
                              engagementId: _clientObj["active_engagement_id"],
                            ),
                          ),
                        );
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.orangeAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Intake',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.white : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),                  
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementAssessments(
                              clientId: _clientObj["client"]["id"],
                              engagementId: _clientObj["active_engagement_id"],
                            ),
                          ),
                        );
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.orangeAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Assessment',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.white : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),                              
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        if(_clientObj != null) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new EngagementWorkouts(
                                clientId: _clientObj["client"]["id"],
                                engagementId: _clientObj["active_engagement_id"]                          
                              ),
                            ),
                          );                                      
                        }
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.redAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Workout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.white : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementHabits(
                              clientId: _clientObj["client"]["id"],
                              engagementId: _clientObj["active_engagement_id"],
                            ),
                          ),
                        );
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.redAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Habit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.white : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementDocuments(
                              engagementId: _clientObj["active_engagement_id"],
                              documentType: 1,                          
                            ),
                          ),
                        );
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.greenAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Nutrition',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.black : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
                new Container(
                  child: new GestureDetector(
                    onTap:() {
                      if(!_isGoalDefined) {
                        CustomDialog.alertDialog(context, "Goal not defined", "Kindly define the goal first before starting the program");
                      } else {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new EngagementDocuments(
                              engagementId: _clientObj["active_engagement_id"],
                              documentType: 2,                          
                            ),
                          ),
                        );
                      }
                    },
                    child: new PhysicalModel(
                      borderRadius: new BorderRadius.circular(65.0),
                      color: _isGoalDefined ? Colors.greenAccent : Colors.blueGrey[50],
                      child: new Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(65.0),                                  
                        ),
                        child: new Center(
                          child: new Text(
                            'Guidance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: _isGoalDefined ? Colors.black : Colors.black,
                            )
                          )
                        ),
                      ),
                    ),                            
                  ),
                ),
              ],
            ),            
            new Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: new FlatButton(
                color: primaryColor,                                
                child: new Text(
                  'View Movement Meter Weekly Progress',
                  style: TextStyle(
                    color: primaryTextColor
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new UserMovementMeterWeeklyGraph(
                        userId: _clientObj["client"]["id"]
                      ),
                    ),
                  );
                },
              ),
            ),
            new Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: new FlatButton(
                color: primaryColor,                                
                child: new Text(
                  'Close Game Plan',
                  style: TextStyle(
                    color: primaryTextColor
                  )
                ),
                onPressed: () {
                  CustomDialog.confirmDialog(
                    context,
                    "Close Game Plan?",
                    "Are you sure to close this current game plan?",
                    "Yes, I am",
                    "No"
                  ).then((int response){
                    if(response == 1) {
                      Map _params = new Map();
                      _params["client_id"] = _clientObj["client"]["id"];
                      _params["engagement_id"] = _clientObj["active_engagement_id"];
                      _params["is_active"] = false;
                      _params["closure_reason"] = "";
                      _closeEngagementAPI(context, _params);
                    }
                  });                                                      
                },
              ),
            ),
            new Container(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 0.0)
            )
          ],
        )                                    
      );
    }
  }

}