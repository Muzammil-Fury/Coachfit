import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/utils/dialog.dart';

const GI_PACKAGE_VERSION = "1";

Function generateDraftWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = GI_PACKAGE_VERSION;
    Map responseData = await post(context, "gi/generate_draft_workout", params);
    if (responseData != null) {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new PractitionerClientHome(
            clientId: params["client_id"],                           
          ),
        ),
      );
      CustomDialog.alertDialog(context, "Draft Workout", "Draft workout for your client has been created. Click on Workouts, review the auto created workout and publish the same for your client.");      
    }
  };
}