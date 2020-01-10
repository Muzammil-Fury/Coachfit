import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/auth/auth_actions.dart';
import 'package:gomotive/utils/preferences.dart';
import 'package:gomotive/core/app_config.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/utils/dialog.dart';

const AUTH_PACKAGE_VERSION = "1";

_switchRouteAfterUserVerification(BuildContext context, List<Map> roles) {  
  if(roles.length > 0) {
    roleList = roles;
    Navigator.of(context).pushReplacementNamed("/home/route");
  }
}

Function getPartnerDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await post(context, "authorize/partner_branding_details", params);
    if (responseData != null) {
      store.dispatch(new BusinessPartnerDetailsSuccessActionCreator(responseData["business_partner"]));
    }
  };
}

Function login(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await post(context, "authorize/login", params);
    if (responseData != null) {
      token = responseData["token"];
      Preferences.setAccessToken(responseData["token"]);
      Map _user = responseData["user"];
      selectedUser = _user;
      List<Map> _roles = Utils.parseList(responseData, "roles");
      store.dispatch(
        new AuthLoginSuccess(
          _user,
          _roles
        )
      );
      _switchRouteAfterUserVerification(context, _roles);
    }
  };
}

Function verifyUser(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await post(context, "authorize/verify_user", params);
    if (responseData != null) {
      Map _user = responseData["user"];
      selectedUser = _user;
      List<Map> _roles = Utils.parseList(responseData, "roles");
      store.dispatch(
        new AuthLoginSuccess(
          _user,
          _roles
        )
      );
      store.dispatch(new BusinessPartnerDetailsSuccessActionCreator(responseData["business_partner"]));      
      _switchRouteAfterUserVerification(context, _roles);
    } else {
      Preferences.deleteAccessToken();
      Navigator.of(context).pushNamed("/auth/signin");
    }
  };
}

Function forgotPassword(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await post(context, "authorize/password_reset", params);
    if (responseData != null) {
      CustomDialog.alertDialog(context, "Forgot Password", "An email has been sent to your address with details to signin").then((int response){
        Navigator.of(context).pop();
      });
    }
  };
}

Function userSignout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = AUTH_PACKAGE_VERSION;
    Map responseData = await post(context, "authorize/user_logout", params);
    if (responseData != null) {
      Utils.userSignout();
      Navigator.of(context).pushReplacementNamed("/auth/signin");
    }
  };
}

