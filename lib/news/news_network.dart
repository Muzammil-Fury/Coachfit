import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/news/news_actions.dart';

const NEWS_PACKAGE_VERSION = "1";

Function getNewsList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = NEWS_PACKAGE_VERSION;
    Map responseData = await post(context, "news/news_for_me", params);
    if (responseData != null) {
      store.dispatch(new NewsListSuccessActionCreator(
        Utils.parseList(responseData, 'news_list'),
        responseData['paginate_info']
      ));
    }
  };
}

Function getNewsDetails(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = NEWS_PACKAGE_VERSION;
    Map responseData = await post(context, "news/news_get", params);
    if (responseData != null) {
      store.dispatch(new NewsGetSuccessActionCreator(
        responseData["news"]
      ));
    }
  };
}