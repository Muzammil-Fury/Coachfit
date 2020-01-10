import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/workout/workout_actions.dart';

const PRACTITIONER_PACKAGE_VERSION = "2";
const ENGAGEMENT_PACKAGE_VERSION = "2";
const EFORM_PACKAGE_VERSION = "1";

Function getHomePageDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PRACTITIONER_PACKAGE_VERSION;
    Map responseData = await post(context, "practitioner/practitioner_home", params);
    if (responseData != null) {
      store.dispatch(new HomePageDetailsSuccessActionCreator(responseData));
    }
  };
}

Function getClients(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_list", params);
    if (responseData != null) {
      store.dispatch(new PractitionerClientsSuccessActionCreator(responseData));
    }
  };
}

Function getClientHomePageDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_home", params);
    if (responseData != null) {
      store.dispatch(new PractitionerClientHomePageSuccessActionCreator(responseData["data"]));
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]["active_engagement"]
      ));
    }
  };
}

Function getClientEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_get", params);
    if (responseData != null) {
      store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
        responseData["data"]
      ));
    }
  };
}


Function getClientEngagementWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_workout_list", params);
    if (responseData != null) {
      store.dispatch(new EngagementWorkoutsSuccessActionCreator(
        Utils.parseList(responseData, "workouts")
      ));
    }
  };
}

Function inviteClient(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_invite", params);
    if (responseData != null) {
      Navigator.of(context).pushReplacementNamed("/practitioner/clients");      
    }
  };
}

Function getClientFilters(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_filter_list", params);
    if (responseData != null) {
      store.dispatch(new PractitionerClientFilterSuccessActionCreator(
        Utils.parseList(responseData, "client_selection_list"),
        Utils.parseList(responseData, "practitioner_list"),
        Utils.parseList(responseData, "consultant_list"),
        responseData["search_preference"],
      ));
    }
  };
}

Function toggleClientVisibility(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_toggle_visibility", params);
    if (responseData != null) {
      store.dispatch(new PractitionerClientToggleVisibilitySuccessActionCreator(
        params["client_index"]
      ));
    }
  };
}

Function createEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_create", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["id"] = params["client_id"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/client_home", params2);
      if (responseData2 != null) {
        store.dispatch(new PractitionerClientHomePageSuccessActionCreator(responseData2["data"]));
        store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
          responseData2["data"]["active_engagement"]
        ));
      }
    }
  };
}


Function closeEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_update_status", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["id"] = params["client_id"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/client_home", params2);
      if (responseData2 != null) {
        store.dispatch(new PractitionerClientHomePageSuccessActionCreator(responseData2["data"]));
        store.dispatch(new PractitionerGetEngagementSuccessActionCreator(
          responseData2["data"]["active_engagement"]
        ));
      }
    }
  };
}
