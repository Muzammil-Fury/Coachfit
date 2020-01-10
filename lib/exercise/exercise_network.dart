import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/exercise/exercise_actions.dart';

const EXERCISE_PACKAGE_VERSION = "1";

Function getExerciseList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EXERCISE_PACKAGE_VERSION;
    Map responseData = await post(context, "exercise/exercise_list", params);
    if (responseData != null) {
      store.dispatch(new ExerciseListSuccessActionCreator(
        Utils.parseList(responseData, 'exercises'),
        responseData['paginate_info'],
        responseData['search_params']
      ));
    }
  };
}

Function toggleFavoriteExercise(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EXERCISE_PACKAGE_VERSION;
    Map responseData = await post(context, "exercise/exercise_toggle_favorite", params);
    if (responseData != null) {
      store.dispatch(new ReplaceExerciseObjectActionCreator(
        responseData['exercise'],
        params["selectedIndex"]
      ));
    }
  };
}

Function getExerciseSearchParams(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = EXERCISE_PACKAGE_VERSION;
    Map responseData = await post(context, "exercise/exercise_search_params_get", params);
    if (responseData != null) {
      store.dispatch(new SearchParamsSuccessActionCreator(
        responseData['supporting_data']['search_params'],
        responseData['supporting_data']
      ));
    }
  };
}

