import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/utils/preferences.dart';
import 'package:gomotive/user/user_actions.dart';
import 'package:gomotive/auth/auth_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/client/client_actions.dart';

const PACKAGE_VERSION = "1";

Function changePassword(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "user/user_password_update", params);
    if (responseData != null && responseData['status'] == "200") {   
      await CustomDialog.alertDialog(
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
    Map responseData = await post(context, "user/user_profile_get", params);
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
    Map responseData = await post(context, "user/user_profile_post", params);
    if (responseData != null && responseData['status'] == "200") {
      store.dispatch(
        new SaveUserProfileActionCreator(
          responseData["user"],
        )
      );   
      CustomDialog.alertDialog(context, "Success", "Your name has been updated successfully");      
    }
  };
}

Function getUserMovementMeterSettings(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "user/user_movement_meter_configuration_get", params);
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
    Map responseData = await post(context, "user/user_movement_meter_configuration_post", params);
    if (responseData != null && responseData['status'] == "200") {  
      store.dispatch(
        new MovementMeterSettingsFetchActionCreator(
          responseData["data"],
        )
      );
      params["is_client"] = true;
      Map responseData2 = await post(context, "user/user_profile_get", params);
      if(responseData2 != null) {
        store.dispatch(new UpdateWeeklyMovementMeterActionCreator(
          responseData2["profile"]["current_week_movement_points"]
        ));
      }      
      CustomDialog.alertDialog(context, "Success", "Your movement meter settings have been successfully updated");      
    }
  };
}

Function getUserMovementMeterWeeklyGraph(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "user/user_movement_meter_weekly_graph", params);
    if (responseData != null && responseData['status'] == "200") {  
      store.dispatch(
        new UserMovementMeterWeeklyGraph(
          Utils.parseList(responseData, "movement_meter_weekly_graph"),
        )
      );      
    }
  };
}