import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/scheduler/scheduler_actions.dart';
import 'package:gomotive/utils/utils.dart';

const PACKAGE_VERSION = "1";

Function getStudioFacilityList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_facility_list", params);
    if (responseData != null) {            
      store.dispatch(new StudioFacilityListSuccessActionCreator(
        Utils.parseList(responseData, "data"),        
      ));
    }
  };
}

Function getStudioFacilityBookingList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_facility_booking_list", params);
    if (responseData != null) {            
      store.dispatch(new StudioFacilityBookingListSuccessActionCreator(
        responseData["facility"],
        Utils.parseList(responseData["booking_slots"], params["selected_date"])
      ));
    }
  };
}

Function bookStudioFacility(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_facility_book_slot", params);
    if (responseData != null) {            
      store.dispatch(new StudioFacilityActionGetSuccessActionCreator(
        responseData["facility"],
        responseData["booking_slot"]        
      ));
    }
  };
}

Function cancelBookingStudioFacility(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_facility_bookings_cancel", params);
    if (responseData != null) {            
      store.dispatch(new StudioFacilityActionGetSuccessActionCreator(
        responseData["facility"],
        responseData["booking_slot"]
      ));
    }
  };
}


Function getGroupClassesList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_group_class_scheduler_list", params);
    if (responseData != null) {            
      store.dispatch(new StudioFacilityListSuccessActionCreator(
        Utils.parseList(responseData, "group_class_list"),        
      ));
    }
  };
}


Function getGroupClassesBookingList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_group_class_scheduler_get", params);
    if (responseData != null) {            
      store.dispatch(new GroupClassBookingListSuccessActionCreator(
        responseData["group_class"],
        Utils.parseList(responseData["group_class"]["booking_slots"], params["selected_date"])
      ));
    }
  };
}


Function bookGroupClass(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_group_class_scheduler_booking_post", params);
    if (responseData != null) {        
      Map params2 = new Map();
      params2["package_version"] = PACKAGE_VERSION;
      params2["selected_date"] = params["selected_date"];
      params2["group_class_id"] = params["group_class_id"];
      Map responseData2 = await post(context, "calendar/client_group_class_scheduler_get", params2);
      if (responseData2 != null) {            
        store.dispatch(new GroupClassBookingListSuccessActionCreator(
          responseData2["group_class"],
          Utils.parseList(responseData2["group_class"]["booking_slots"], params2["selected_date"])
        ));
      }
    }
  };
}

Function cancelGroupClassBooking(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await post(context, "calendar/client_group_class_bookings_cancel", params);
    if (responseData != null) {            
      Map params2 = new Map();
      params2["package_version"] = PACKAGE_VERSION;
      params2["selected_date"] = params["selected_date"];
      params2["group_class_id"] = params["group_class_id"];
      Map responseData2 = await post(context, "calendar/client_group_class_scheduler_get", params2);
      if (responseData2 != null) {            
        store.dispatch(new GroupClassBookingListSuccessActionCreator(
          responseData2["group_class"],
          Utils.parseList(responseData2["group_class"]["booking_slots"], params2["selected_date"])
        ));
      }
    }
  };
}
