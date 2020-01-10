import 'package:flutter/material.dart';
import 'package:gomotive/client/views/client_habits_today.dart';
import 'package:gomotive/client/views/client_nutrition.dart';
import 'package:gomotive/conversation/views/conversation_chat.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/news/views/news_view.dart';
import 'package:gomotive/client/views/client_intake_list.dart';
import 'package:gomotive/client/views/client_workouts_today.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';

class External {

  static String clientURL = "client/";
  static String practitionerURL = "practice/";
  static String newsURL = "news/view/"; 
  static String clientIntakeURL = "intakes";
  static String clientWorkoutURL = "workouts/engagement/";
  static String clientHabitURL = "habits/engagement/";
  static String clientDocumentURL = "documents/engagement/";
  static String clientGroupWorkoutURL = "workouts/group/";
  static String practitionerEngagementURL1 = "client/";  
  static String practitionerEngagementURL2 = "engagement/";  


  static parseNotifictionMessage(Map message) {
    if(message["gcm.notification.type"] == "chat") {
      String conversationId = message["gcm.notification.conversation_id"];
      String switchRole = message["gcm.notification.switch_role"];
      if(switchRole == "client") {
        _loadClientRole();    
      } else {
        _loadPracticeRole(switchRole); 
      }
      Navigator.pushReplacement(
        initialContext,
        new MaterialPageRoute(
          builder: (initialContext) => new ConversationChat( 
            conversationId: int.parse(conversationId),
            fromExternal: true,
          ),
        ),
      );
    }
  }

  static parseURL(String url) { 

    url = url.replaceAll("godhf:///", "");
    url = url.replaceAll("gogi:///", "");
    url = url.replaceAll("goafc:///", "");
    url = url.replaceAll("gocc:///", "");
    url = url.replaceAll("https://dhf.gomotive.com/", "");
    url = url.replaceAll("https://gi.gomotive.com/", "");
    url = url.replaceAll("https://afc.gomotive.com/", "");
    url = url.replaceAll("https://cc.gomotive.com/", "");

    int posi = -1;
    
    posi = url.indexOf(clientURL, 0);
    if(posi == 0) {
      url = url.replaceAll(External.clientURL, "");
      _loadClientRole();      
      int posi2 = -1;
      posi2 = url.indexOf(newsURL, 0);
      if(posi2 == 0) {
        String newsId = url.substring(newsURL.length, url.length);   
        _loadNewsView(int.parse(newsId));   
      }
      posi2 = url.indexOf(clientIntakeURL, 0);
      if(posi2 == 0) {
        _loadClientIntakes();
      }
      posi2 = url.indexOf(clientWorkoutURL, 0);
      if(posi2 == 0) {
        String engagementId = url.substring(clientWorkoutURL.length, url.length);   
        _loadClientWorkouts(int.parse(engagementId));
      }
      posi2 = url.indexOf(clientHabitURL, 0);
      if(posi2 == 0) {
        String engagementId = url.substring(clientHabitURL.length, url.length);   
        _loadClientHabits(int.parse(engagementId));
      }
      posi2 = url.indexOf(clientDocumentURL, 0);
      if(posi2 == 0) {
        String engagementId = url.substring(clientDocumentURL.length, url.length);   
        _loadClientDocuments(int.parse(engagementId));
      }
      posi2 = url.indexOf(clientGroupWorkoutURL, 0);
      if(posi2 == 0) {
        String groupId = url.substring(clientGroupWorkoutURL.length, url.length);   
        _loadClientGroupWorkouts(int.parse(groupId));
      }
    }    

    posi = url.indexOf(practitionerURL, 0);
    if(posi == 0) {
      url = url.replaceAll(External.practitionerURL, "");
      String practiceId = url.substring(0, url.indexOf("/"));
      _loadPracticeRole(practiceId);      
      url = url.substring(url.indexOf("/")+1, url.length);

      int posi2 = -1;
      posi2 = url.indexOf(newsURL, 0);
      if(posi2 == 0) {
        String newsId = url.substring(External.newsURL.length, url.length);   
        _loadNewsView(int.parse(newsId));   
      }
      posi2 = url.indexOf(practitionerEngagementURL1, 0);
      if(posi2 == 0) {
        String clientId = url.substring(
          External.practitionerEngagementURL1.length, 
          url.indexOf(practitionerEngagementURL2, posi2)
          );   
        clientId = clientId.replaceAll("\/", "");
        String engagementId = url.substring(url.indexOf(practitionerEngagementURL2, posi2)+practitionerEngagementURL2.length, url.length);
        _loadEngagementView(int.parse(clientId), int.parse(engagementId));
      }
    }
  }

  static _loadClientRole() {    
    for(int i=0; i<roleList.length;i++) {
      if(roleList[i]["role"]["id"] == 4) {
        selectedRole = roleList[i];
        selectedRoleId = roleList[i]["role"]["id"].toString();
        selectedRoleName = roleList[i]["role"]["name"];
      } 
    }
  }

  static _loadPracticeRole(String practiceId) {
    for(int i=0; i<roleList.length;i++) {
      if(roleList[i]["role"]["id"] != 4) {
        if(roleList[i]["practice"]["id"].toString() == practiceId) {
          selectedRole = roleList[i];
          selectedRoleId = roleList[i]["practice"]["id"].toString();
          selectedRoleName = roleList[i]["role"]["name"];
        }
      } 
    }
  }

  static _loadNewsView(int newsId) {    
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new NewsView(
          newsId: newsId,  
          fromExternal: true,                          
        ),
      ),
    );    
  }

  static _loadClientIntakes() {
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new ClientIntakeList(          
          fromExternal: true,                          
        ),
      ),
    );    
  }

  static _loadEngagementView(int clientId, int engagementId) {   
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new PractitionerClientHome( 
          clientId: clientId,
          fromExternal: true,
        ),
      ),
    ); 
  }

  static _loadClientWorkouts(int engagementId) {
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new ClientWorkoutsToday( 
          id: engagementId,
          type: "engagement",
          displayProgramTitle: true,         
          fromExternal: true,                          
        ),
      ),
    );
  }

  static _loadClientGroupWorkouts(int groupId) {
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new ClientWorkoutsToday( 
          id: groupId,
          type: "group",
          displayProgramTitle: true,         
          fromExternal: true,                          
        ),
      ),
    );
  }


  static _loadClientHabits(int engagementId) {
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new ClientHabitsToday( 
          id: engagementId,
          type: "engagement",
          displayProgramTitle: true,         
          fromExternal: true,                          
        ),
      ),
    );
  }

  static _loadClientDocuments(int engagementId) {
    Navigator.pushReplacement(
      initialContext,
      new MaterialPageRoute(
        builder: (initialContext) => new ClientNutrition( 
          id: engagementId,
          type: "engagement",
          displayProgramTitle: true,         
          fromExternal: true,                          
        ),
      ),
    );
  }


}