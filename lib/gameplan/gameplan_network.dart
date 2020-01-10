import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/gameplan/gameplan_actions.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/practitioner/views/practitioner_client_home.dart';
import 'package:gomotive/utils/dialog.dart';

const TREATMENT_TEMPLATE_PACKAGE_VERSION = "1";

Function getGameplanTemplateList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/treatment_template_list", params);
    if (responseData != null) {
      store.dispatch(new GamePlanTemplateListSuccessActionCreator(
        Utils.parseList(responseData, "treatment_template_list"),
        responseData["paginate_info"],
      ));      
    }
  };
}

Function getGameplanTemplateWorkoutList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/treatment_template_workout_list", params);
    if (responseData != null) {
      store.dispatch(new GamePlanTemplateWorkoutListSuccessActionCreator(
        Utils.parseList(responseData, "workouts"),
      ));      
    }
  };
}

Function getGameplanTemplateHabitList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/treatment_template_habit_list", params);
    if (responseData != null) {
      store.dispatch(new GamePlanTemplateHabitListSuccessActionCreator(
        Utils.parseList(responseData, "habits"),
      ));      
    }
  };
}

Function getGameplanTemplateNutritionList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/treatment_template_health_document_list", params);
    if (responseData != null) {
      store.dispatch(new GamePlanTemplateNutritionListSuccessActionCreator(
        Utils.parseList(responseData, "documents"),
      ));      
    }
  };
}

Function getGameplanTemplateGuidanceList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/treatment_template_health_document_list", params);
    if (responseData != null) {
      store.dispatch(new GamePlanTemplateGuidanceListSuccessActionCreator(
        Utils.parseList(responseData, "documents"),
      ));      
    }
  };
}

Function createEngagementFromTemplate(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = TREATMENT_TEMPLATE_PACKAGE_VERSION;
    Map responseData = await post(context, "treatment_template/create_engagement_from_treatment_template", params);
    if (responseData != null) {
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["engagement"]
      ));
      CustomDialog.alertDialog(context, "Publish Content", "Workouts, Habits, Nutrition & Guidance document have been created for this gameplan. Kindly publish all of them for your client").then((int response) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new PractitionerClientHome(
              clientId: params["client_id"],                          
            ),
          ),
        );
      });      
    }
  };
}
