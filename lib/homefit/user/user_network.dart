import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/homefit/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/preferences.dart';
import 'package:gomotive/homefit/user/user_actions.dart';
import 'package:gomotive/homefit/utils/utils.dart';
import 'package:gomotive/homefit/home/home_actions.dart';

const PACKAGE_VERSION = "1";

Function changePassword(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_password_update", params);
    if (responseData != null && responseData['status'] == "200") {   
      await Utils.alertDialog(
        context, 
        "Success", 
        "Your password has been updated. Please sign in once again using your new password."
      );
      Preferences.deleteAccessToken();
      Navigator.of(context).pushNamed("/auth/signin");
    }
  };
}

Function getUserProfileDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_profile_get", params);
    if(responseData != null) {
      store.dispatch(
        new FetchUserProfileDetailsActionCreator(
          responseData["profile"],
          Utils.parseList(responseData["supporting_data"], "gender"),
          Utils.parseList(responseData["supporting_data"], "timezone"),
        )
      );
    }    
  };
}


Function updateUserProfileDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_profile_post", params);
    if (responseData != null && responseData['status'] == "200") {      
      Utils.alertDialog(context, "Success", "Your name has been updated successfully");      
    }
  };
}

Function getUserMovementMeterSettings(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_movement_meter_configuration_get", params);
    if (responseData != null && responseData['status'] == "200") {
      store.dispatch(
        new MovementMeterSettingsFetchActionCreator(
          responseData["data"],
        )
      );         
    }
  };
}


Function updateMovementMeterSettings(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
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

Function addActivity(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/update_user_movement_details", params);
    if (responseData != null) {
      store.dispatch(new DashboardDetailsMovementMeterSuccessActionCreator(
        responseData["current_week_movement_points"]
      ));
    }
  };
}

Function getUserMovementMeterWeeklyGraph(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "user/user_movement_meter_weekly_graph", params);
    if (responseData != null && responseData['status'] == "200") {  
      store.dispatch(
        new UserMovementMeterWeeklyGraph(
          Utils.parseList(responseData, "movement_meter_weekly_graph"),
        )
      );      
    }
  };
}
