import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/client/client_actions.dart';

const CLIENT_PACKAGE_VERSION = "2";
const PROGRAM_PACKAGE_VERSION = "2";
const ENGAGEMENT_PACKAGE_VERSION = "2";
const GROUP_PACKAGE_VERSION = "2";
const USER_PACKAGE_VERSION = "1";

Function getHomePageDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_home", params);
    if (responseData != null) {
      store.dispatch(new HomePageDetailsSuccessActionCreator(responseData));
    }
  };
}

Function getProgramList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_programs", params);
    if (responseData != null) {
      store.dispatch(new ProgramListSuccessActionCreator(responseData));      
    }
  };
}

Function getWorkoutList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_workouts", params);
    if (responseData != null) {
      store.dispatch(new ProgramObjectSuccessActionCreator(responseData));
    }
  };
}

Function getAllWorkoutList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_workouts_all", params);
    if (responseData != null) {
      store.dispatch(new AllWorkoutListSuccessActionCreator(responseData));
    }
  };
}

Function trackWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_progression_progress_post", params);
    if(responseData != null) {
      Map params2 = new Map();
      params2["fetch_type"] = params["fetch_type"];
      params2["id"] = params["program_id"];
      params2["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
      params2["package_version"] = CLIENT_PACKAGE_VERSION;    
      Map responseData2 = await post(context, "client/client_workouts", params2);
      if (responseData2 != null) {
        store.dispatch(new ProgramObjectSuccessActionCreator(responseData2));   
        if(params["back"]) {
          Navigator.of(context).pop();     
        }
      }   
    }
  };
}


Function getWorkoutProgressions(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_get", params);
    if(responseData != null) {
      store.dispatch(new WorkoutProgressionListSuccessActionCreator(
        Utils.parseList(responseData["workout"], "progressions")
      ));
    }
  };
}

Function getClientActiveEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_active_engagement", params);
    if(responseData != null) {
      store.dispatch(new ClientActiveEngagementGetSuccessActionCreator(
        Utils.parseList(responseData, "engagements")
      ));
    }
  };
}


Function getHabitList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_habits", params);
    if (responseData != null) {
      store.dispatch(new ProgramObjectSuccessActionCreator(responseData));
    }
  };
}


Function trackEngagementHabit(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_track_habit", params);
    if(responseData != null) {
      Map params2 = new Map();
      params2["fetch_type"] = params["fetch_type"];
      params2["id"] = params["engagement_id"];
      params2["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
      params2["package_version"] = CLIENT_PACKAGE_VERSION;    
      Map responseData2 = await post(context, "client/client_habits", params2);
      if (responseData2 != null) {
        store.dispatch(new ProgramObjectSuccessActionCreator(responseData2));           
      }   
    }
  };
}


Function trackGroupHabit(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GROUP_PACKAGE_VERSION;
    Map responseData = await post(context, "group/client_group_track_habit", params);
    if(responseData != null) {
      Map params2 = new Map();
      params2["fetch_type"] = params["fetch_type"];
      if(params["fetch_type"] == "engagement") {
        params2["id"] = params["engagement_id"];
      } else {
        params2["id"] = params["group_id"];
      }
      params2["selected_date"] = Utils.convertDateToValueString(new DateTime.now()).toString();
      params2["package_version"] = CLIENT_PACKAGE_VERSION;    
      Map responseData2 = await post(context, "client/client_habits", params2);
      if (responseData2 != null) {
        store.dispatch(new ProgramObjectSuccessActionCreator(responseData2));           
      }   
    }
  };
}


Function getNutritionAndGuidanceList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_nutrition", params);
    if (responseData != null) {
      store.dispatch(new ProgramObjectSuccessActionCreator(responseData));
    }
  };
}

Function getIntakeFormList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = CLIENT_PACKAGE_VERSION;
    Map responseData = await post(context, "client/client_intake_forms", params);
    if (responseData != null) {
      store.dispatch(new IntakeFormListSuccessActionCreator(
        Utils.parseList(responseData, "intake_forms")
      ));
    }
  };
}

Function submitIntakeForm(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_intake_submit", params);
    if (responseData != null) {        
      Map params2 = new Map();
      params2["package_version"] = CLIENT_PACKAGE_VERSION;          
      Map responseData2 = await post(context, "client/client_intake_forms", params2);
      if (responseData2 != null) {
        store.dispatch(new IntakeFormListSuccessActionCreator(
          Utils.parseList(responseData2, "intake_forms")
        ));
      }
    }
  };
}

Function addActivity(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = USER_PACKAGE_VERSION;
    Map responseData = await post(context, "user/update_user_movement_details", params);
    if (responseData != null) {
      store.dispatch(new UpdateWeeklyMovementMeterActionCreator(
        responseData["current_week_movement_points"]
      ));
    }
  };
}

Function getEngagementDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_get", params);
    if (responseData != null) {
      store.dispatch(new ProgramSuccessActionCreator(responseData["data"]));
      if(responseData["data"]["client_untracked_goal_dates"].length > 0) {            
        Map _params = new Map();
        _params["engagement"] = params["id"];
        _params["tracking_date"] = responseData["data"]["client_untracked_goal_dates"][0].toString();
        _params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
        Map responseData2 = await post(context, "engagement/client_engagement_goal_tracking_get", _params);
        if (responseData2 != null) {
          store.dispatch(new GoalTrackingDetailsSuccessActionCreator(
            Utils.parseList(responseData2, "data")
          ));
        }
      }
    }
  };
}

Function getGroupDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GROUP_PACKAGE_VERSION;
    Map responseData = await post(context, "group/client_group_get", params);
    if (responseData != null) {
      store.dispatch(new ProgramSuccessActionCreator(responseData["group"]));
      if(responseData["group"]["client_untracked_goal_dates"].length > 0) {            
        Map _params = new Map();
        _params["group_id"] = params["id"];
        _params["tracking_date"] = responseData["group"]["client_untracked_goal_dates"][0].toString();
        _params["package_version"] = GROUP_PACKAGE_VERSION;
        Map responseData2 = await post(context, "group/client_group_goal_tracking_get", _params);
        if (responseData2 != null) {
          store.dispatch(new GoalTrackingDetailsSuccessActionCreator(
            Utils.parseList(responseData2, "data")
          ));
        }
      }
    }
  };
}


Function updateEngagementGoalTracking(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_goal_tracking_post", params);
    if (responseData != null) {
      store.dispatch(new ProgramSuccessActionCreator(responseData["data"]));
    }
  };
}


Function getEngagementGoalTrackingChart(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_goal_tracking_chart", params);
    if (responseData != null) {
      store.dispatch(new GoalTrackingChartDetailsSuccessActionCreator(
        Utils.parseList(responseData, "data")
      ));
    }
  };
}

Function updateGroupGoalTracking(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GROUP_PACKAGE_VERSION;
    Map responseData = await post(context, "group/client_group_goal_tracking_post", params);
    if (responseData != null) {
      store.dispatch(new ProgramSuccessActionCreator(responseData["group"]));
    }
  };
}

Function getGroupGoalTrackingChart(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GROUP_PACKAGE_VERSION;
    Map responseData = await post(context, "group/client_goal_tracking_history_get", params);
    if (responseData != null) {      
      store.dispatch(new GoalTrackingChartDetailsSuccessActionCreator(
        Utils.parseList(responseData, "client_group_goal_tracking_history")
      ));
    }
  };
}
