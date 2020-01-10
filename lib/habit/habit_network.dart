import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/habit/habit_actions.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/habit/views/engagement_habits.dart';
import 'package:gomotive/habit/views/habit_edit.dart';

const ENGAGEMENT_PACKAGE_VERSION = "2";
const HABIT_PACKAGE_VERSION = "1";


Function getHabitTemplateList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = HABIT_PACKAGE_VERSION;
    Map responseData = await post(context, "habit/habit_template_list", params);
    if (responseData != null) {
      store.dispatch(new HabitTemplateListSuccess(
        Utils.parseList(responseData, "habit_templates")
      ));
    }
  };
}

Function createHabitFromHabitTemplate(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/create_engagement_habit_from_template", params);
    if (responseData != null) {
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]
      ));
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new HabitEdit(
            clientId: params["client_id"],
            engagementId: params["engagement_id"],  
            habitId: responseData["habit_id"],
          ),
        ),
      );      
    }
  };
}


Function getEngagementHabit(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_habit_get", params);
    if (responseData != null) {
      store.dispatch(new EngagementHabitGetSuccess(
        responseData["habit"],
        Utils.parseList(responseData["supporting_data"], "frequency_schedule"),
        Utils.parseList(responseData["supporting_data"], "duration_type")
      ));
    }
  };
}

Function saveEngagementHabit(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_habit_edit", params);
    if (responseData != null) {            
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]
      ));
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new EngagementHabits(
            clientId: params["client_id"],
            engagementId: params["engagement_id"],
          ),
        ),
      );   
    }
  };
}

Function deleteEngagementHabit(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_habit_delete", params);
    if (responseData != null) {            
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]
      ));      
    }
  };
}
