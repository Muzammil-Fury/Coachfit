
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/intake/intake_actions.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';

const ENGAGEMENT_PACKAGE_VERSION = "2";
const EFORM_PACKAGE_VERSION = "1";

Function getIntakeList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EFORM_PACKAGE_VERSION;
    Map responseData = await post(context, "eform/eform_list", params);
    if (responseData != null) {            
      store.dispatch(new EFormListSuccessActionCreator(
        Utils.parseList(responseData, "data")
      ));      
    }
  };
}

Function assignIntakeForm(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_intake_assign", params);
    if (responseData != null) {            
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]
      ));
    }
  };
}


