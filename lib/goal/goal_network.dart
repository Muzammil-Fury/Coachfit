import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/goal/goal_actions.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/goal/views/engagement_goal.dart';


const ENGAGEMENT_PACKAGE_VERSION = "2";
const GOAL_PACKAGE_VERSION = "1";

Function getGoalTemplateList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GOAL_PACKAGE_VERSION;
    Map responseData = await post(context, "goal/goal_list", params);
    if (responseData != null) {            
      store.dispatch(new GoalTemplateListSuccessActionCreator(
        Utils.parseList(responseData, "goal_list")
      ));
    }
  };
}

Function getGoalTrackingUnitList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GOAL_PACKAGE_VERSION;
    Map responseData = await post(context, "goal/goal_tracking_unit_list", params);
    if (responseData != null) {            
      store.dispatch(new GoalTrackingUnitListSuccessActionCreator(
        Utils.parseList(responseData, "goal_tracking_unit_list")
      ));
    }
  };
}


Function addGoalToEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_goal_add", params);
    if (responseData != null) { 
      Map params2 = new Map();
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      params2["id"] = params["engagement"];
      Map responseData2 = await post(context, "engagement/engagement_get", params2);
      if (responseData2 != null) {
        store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
          responseData2["data"]
        ));
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
            builder: (context) => new EngagementGoal(
              clientId: params["client_id"],
              engagementId: params["engagement"],                  
            ),
          ),
        );
      }                 
    }
  };
}


Function updateEngagementGoal(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_goal_update", params);
    if (responseData != null) {   
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["engagement"]
      ));         
      Navigator.of(context).pop();
      // Map params2 = new Map();
      // params2["package_version"] = GOAL_PACKAGE_VERSION;
      // Map responseData2 = await post(context, "goal/goal_tracking_unit_list", params2);
      // if (responseData2 != null) {            
      //   store.dispatch(new GoalTrackingUnitListSuccessActionCreator(
      //     Utils.parseList(responseData2, "goal_tracking_unit_list")
      //   ));
      // }
    }
  };
}
