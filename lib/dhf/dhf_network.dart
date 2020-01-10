import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/dhf/dhf_actions.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/utils/dialog.dart';

const DHFASSESS_PACKAGE_VERSION = "1";

Function getAssessment(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = DHFASSESS_PACKAGE_VERSION;
    Map responseData = await post(context, "dhfassess/dhf_assess_form_get", params);
    if (responseData != null) {            
      store.dispatch(new DHFAssessmentSuccessActionCreator(
        Utils.parseList(responseData, "data")
      ));      
    }
  };
}

Function saveAssessment(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = DHFASSESS_PACKAGE_VERSION;
    Map responseData = await post(context, "dhfassess/dhf_assess_form_post", params);
    if (responseData != null) {            
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new PractitionerClientHome(
            clientId: params["client"],                           
          ),
        ),
      );
      CustomDialog.alertDialog(context, "Draft Workouts & habits", "Draft workouts & habits for your client has been created. Review the auto created workout & habit and publish the same for your client.");      
    }
  };
}
