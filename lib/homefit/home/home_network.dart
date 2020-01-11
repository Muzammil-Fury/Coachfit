import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:homefit/utils/network.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/utils/preferences.dart';
import 'package:homefit/utils/utils.dart';
import 'package:homefit/core/app_config.dart';
import 'package:homefit/home/home_actions.dart';
import 'package:homefit/workout/workout_actions.dart';

const PACKAGE_VERSION = "1";
const AUTH_PACKAGE_VERSION = "1";
const USER_PACKAGE_VERSION = "1";

Function verifyEmail(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_verify_email", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new VerifyEmailSuccessActionCreator(
          responseData["user_exists"]
        )
      );
    }
  };
}


Function login(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_login", params);
    if (responseData != null && responseData['status'] == "200") {      
      token = responseData["token"];
      Preferences.setAccessToken(responseData["token"]);
      store.dispatch(
        new VerifyUserActionCreator(
          responseData["user"],
          Utils.parseList(responseData, "plans"),
        )
      );
      Navigator.of(context).pushReplacementNamed("/dashboard");       
    }
  };
}

Function homefitVerifyUser(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_verify_user", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new VerifyUserActionCreator(
          responseData["user"],
          Utils.parseList(responseData, "plans"),
        )
      );
      Navigator.of(context).pushReplacementNamed("/dashboard");       
    } else {
      Preferences.deleteAccessToken();
      Navigator.of(context).pushReplacementNamed("/splash"); 
    }
  };
}

Function getDashboardDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_get_home_details", params);
    if (responseData != null && responseData['status'] == "200") {      
      if(token == "" || token == null) {
        store.dispatch(
          new DashboardDetailsSuccessActionCreator(
            responseData['welcome_video_id'],
            responseData['welcome_video_url'],           
            responseData['welcome_video_thumbnail_url'],
            Utils.parseList(responseData, "available_sports")
          )
        );
        store.dispatch(
          new DashboardDetailsMovementMeterSuccessActionCreator(
            responseData["current_week_movement_points"],
          )
        );        
      } else {
        store.dispatch(
          new DashboardDetailsSuccessActionCreator(
            "",
            "",           
            "",
            Utils.parseList(responseData, "available_sports")
          )
        );
        store.dispatch(
          new DashboardDetailsMovementMeterSuccessActionCreator(
            responseData["current_week_movement_points"],
          )
        );
        store.dispatch(
          new RecommendedWorkoutListSuccessActionCreator(
            Utils.parseList(responseData, "move_videos")
          )
        );
      }
    }
  };
}

Function trackActivities(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_activity_done", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new DashboardDetailsMovementMeterSuccessActionCreator(
          responseData["activity_obj"]
        )
      );
      Navigator.of(context).pushReplacementNamed("/dashboard"); 
    }
  };
}

Function savePlanAndTransactionReceipt(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_save_user_plan_id", params);
    if (responseData != null && responseData['status'] == "200") {            
      Navigator.of(context).pushReplacementNamed("/dashboard"); 
    }
  };
}

Function getFamilyPlanMembers(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/move_get_family_members", params);
    if (responseData != null && responseData['status'] == "200") {   
      store.dispatch(
        new FamilyPlanMemberListSuccessActionCreator(
          Utils.parseList(responseData, "family_member_list")
        )
      );         
    }
  };
}

Function inviteFamilyMember(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/move_add_family_member", params);
    if (responseData != null && responseData['status'] == "200") {

    }
  };
}

Function deleteFamilyMember(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/move_remove_family_members", params);
    if (responseData != null && responseData['status'] == "200") {
      getFamilyPlanMembers(context, {});         
    }
  };
}

Function changePassword(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = USER_PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_password_update", params);
    if (responseData != null && responseData['status'] == "200") {   
      Utils.alertDialog(context, "Success", "Your password has been updated. Please login once again.");      
    }
  };
}

Function updateName(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = USER_PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_profile_post", params);
    if (responseData != null && responseData['status'] == "200") {   
      Utils.alertDialog(context, "Success", "Your name has been updated successfully");      
    }
  };
}

Function updateMovementMeterSettings(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = USER_PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_movement_meter_configuration_post", params);
    if (responseData != null && responseData['status'] == "200") {  
      store.dispatch(
        new UpdateUserMovementMeterSettingsActionCreator(
          responseData["data"]
        )
      );
      Utils.alertDialog(context, "Success", "Your movement meter settings have been successfully updated");      
    }
  };
}

Function userSignout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "authorize/user_logout", params);
    if (responseData != null) {
      Utils.userSignout();
      Navigator.of(context).pushReplacementNamed("/splash");
    }
  };
}

Function subscribeStripePayment(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_stripe_subscribe", params);
    if (responseData != null) {
      Navigator.of(context).pushReplacementNamed("/dashboard"); 
    }
  };
}

Function unSubscribeStripePayment(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/dhf_move_stripe_unsubscribe", params);
    if (responseData != null) {
      Navigator.of(context).pushReplacementNamed("/dashboard"); 
    }
  };
}

Function getDashboardNewWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_workouts_new", params);
    if (responseData != null) {
      store.dispatch(
        new DashboardNewWorkoutsSuccess(
          Utils.parseList(responseData, "move_videos")
        )
      );
    }
  };
}

Function getDashboardFavoriteWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_workouts_favorite", params);
    if (responseData != null) {
      store.dispatch(
        new DashboardFavoriteWorkoutsSuccess(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"]
        )
      );
    }
  };
}

