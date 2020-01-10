import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/document/document_actions.dart';


const ENGAGEMENT_PACKAGE_VERSION = "2";

Function getDocumentList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_health_document_list", params);
    if (responseData != null) {
      store.dispatch(new EngagementDocumentListSuccess(
        Utils.parseList(responseData, "documents")
      ));
    }
  };
}

Function getAllDocumentList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_document_list", params);
    if (responseData != null) {
      store.dispatch(new HealthDocumentListSuccess(
        Utils.parseList(responseData, "data")
      ));
    }
  };
}

Function addDocumentToEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_health_document_post", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["engagement_id"] = params["engagement_id"];
      params2["document_type"] = params["document_type"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/client_engagement_health_document_list", params2);
      if (responseData2 != null) {
        store.dispatch(new EngagementDocumentListSuccess(
          Utils.parseList(responseData2, "documents")
        ));
      }
    }
  };
}

Function removeDocumentFromEngagement(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/client_engagement_health_document_delete", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["engagement_id"] = params["engagement_id"];
      params2["document_type"] = params["document_type"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/client_engagement_health_document_list", params2);
      if (responseData2 != null) {
        store.dispatch(new EngagementDocumentListSuccess(
          Utils.parseList(responseData2, "documents")
        ));
      }
    }
  };
}

Function togglePublishEngagementDocument(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
    Map responseData = await post(context, "engagement/engagement_document_publish_status_toggle", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["engagement_id"] = params["engagement_id"];
      params2["document_type"] = params["document_type"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/client_engagement_health_document_list", params2);
      if (responseData2 != null) {
        store.dispatch(new EngagementDocumentListSuccess(
          Utils.parseList(responseData2, "documents")
        ));
      }
    }
  };
}
