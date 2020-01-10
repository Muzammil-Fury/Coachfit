import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/education/education_actions.dart';

const EDUCATION_PACKAGE_VERSION = "1";


Function getEducationPartners(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EDUCATION_PACKAGE_VERSION;
    Map responseData = await post(context, "education/practice_education_partners", params);
    if (responseData != null) {            
      store.dispatch(new EducationPartnersSuccessActionCreator(
        Utils.parseList(responseData, "partner_list")
      ));      
    }
  };
}

Function getEducationCategories(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EDUCATION_PACKAGE_VERSION;
    Map responseData = await post(context, "education/practice_education_categories", params);
    if (responseData != null) {            
      store.dispatch(new EducationPartnerCategoriesSuccessActionCreator(
        Utils.parseList(responseData, "education_categories")
      ));      
    }
  };
}

Function getEducationContent(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EDUCATION_PACKAGE_VERSION;
    Map responseData = await post(context, "education/practice_education_content", params);
    if (responseData != null) {            
      store.dispatch(new EducationPartnerContentSuccessActionCreator(
        Utils.parseList(responseData, "education_content")
      ));      
    }
  };
}

