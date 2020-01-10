import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:gomotive/utils/network.dart';
import 'package:gomotive/core/app_state.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/practitioner/practitioner_network.dart';
import 'package:gomotive/utils/dialog.dart';
import 'package:gomotive/workout/views/engagement_workouts.dart';
import 'package:gomotive/workout/views/workout_setup.dart';
import 'package:gomotive/utils/utils.dart';
import 'package:gomotive/workout/views/workout_progressions.dart';
import 'package:gomotive/workout/views/workout_progression_build.dart';

const PROGRAM_PACKAGE_VERSION = "2";


Function getWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_get", params);
    if (responseData != null) {
      store.dispatch(new WorkoutGetSuccessActionCreator(
        responseData["workout"],
        responseData["supporting_data"]
      ));      
    }
  };
}

Function saveWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_post", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["package_version"] = PROGRAM_PACKAGE_VERSION;
      params2["engagement_id"] = params["engagement_id"];
      params2["id"] = responseData["id"];      
      Map responseData2 = await post(context, "program/workout_get", params2);
      if (responseData2 != null) {
        store.dispatch(new WorkoutGetSuccessActionCreator(
          responseData2["workout"],
          responseData2["supporting_data"]
        )); 
        if(params["partner_progression_count"] == "m") {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new WorkoutProgressions(
                clientId: params["client_id"],
                engagementId: params["engagement_id"],                              
                workoutId: responseData["id"]       
              ),
            ),
          );
        } else {
          int _progressionId;
          if(responseData2["workout"]["progressions"].length > 0) {
            _progressionId = responseData2["workout"]["progressions"][0]["id"];
          } else {
            _progressionId = null;
          }
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new WorkoutProgressionBuild(
                clientId: params["client_id"],
                engagementId: params["engagement_id"],                              
                workoutId: responseData["id"],
                progressionId: _progressionId,
              ),
            ),
          );
        }
      }
    }
  };
}

Function deleteWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_delete", params);
    if (responseData != null) {
      Map params2 = new Map();
      params2["engagement_id"] = params["engagement_id"];
      params2["package_version"] = ENGAGEMENT_PACKAGE_VERSION;
      Map responseData2 = await post(context, "engagement/engagement_workout_list", params2);
      if (responseData2 != null) {
        store.dispatch(new EngagementWorkoutsSuccessActionCreator(
          Utils.parseList(responseData2, "workouts")
        ));
      }
    }
  };
}

Function getWorkoutProgression(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/progression_get", params);
    if (responseData != null) { 
      store.dispatch(new WorkoutProgressionGetSuccessActionCreator(
        responseData["progression"],
        responseData["supporting_data"]
      ));     
    }
  };
}

Function saveWorkoutProgression(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/progression_post", params);
    if (responseData != null) {    
      store.dispatch(new WorkoutProgressionClearActionCreator());        
      Map params2 = new Map();
      params2["package_version"] = PROGRAM_PACKAGE_VERSION;
      if(params["workout_type"] == "engagement") {
        params2["engagement_id"] = params["engagement_id"];
      } 
      params2["id"] = params["workout_id"];
      Map responseData2 = await post(context, "program/workout_get", params2);
      if (responseData2 != null) {
        store.dispatch(new WorkoutGetSuccessActionCreator(
          responseData2["workout"],
          responseData2["supporting_data"]
        )); 
        if(params["partner_progression_count"] == "m") {     
          Navigator.of(context).pop();
        } else {
          Map params3 = new Map();
          params3["package_version"] = PROGRAM_PACKAGE_VERSION;
          if(params["workout_type"] == "engagement") {
            params3["engagement_id"] = params["engagement_id"];
          } 
          params3["id"] = params["workout_id"];
          params3["is_publish"] = true;
          params3["client_id"] = params["client_id"];
          Map responseData3 = await post(context, "program/workout_publish_toggle", params3);
          if (responseData3 != null) {    
            store.dispatch(new WorkoutProgressionClearActionCreator());    
            store.dispatch(new WorkoutClearActionCreator());
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new EngagementWorkouts(
                  clientId: params["client_id"],     
                  engagementId: params["engagement_id"],                      
                ),
              ),
            );
            if(responseData3["published"]) {
              CustomDialog.alertDialog(context, "Published", "Your client workout has been published.");
            } else {
              CustomDialog.alertDialog(context, "Published", "Your client workout has been set to draft state.");
            }           
          }
        }
      }      
    }
  };
}

Function deleteWorkoutProgression(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/progression_delete", params);
    if (responseData != null) { 
      Map params2 = new Map();
      params2["package_version"] = PROGRAM_PACKAGE_VERSION;
      if(params["workout_type"] == "engagement") {
        params2["engagement_id"] = params["workout_type_id"];
      } else {
        params2["group_id"] = params["workout_type_id"];
      }
      params2["id"] = params["workout_id"];
      Map responseData2 = await post(context, "program/workout_get", params2);
      if (responseData2 != null) {
        store.dispatch(new WorkoutGetSuccessActionCreator(
          responseData2["workout"],
          responseData2["supporting_data"]
        ));      
      }
    }
  };
}

Function workoutPublishToggle(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_publish_toggle", params);
    if (responseData != null) {    
      store.dispatch(new WorkoutProgressionClearActionCreator());    
      store.dispatch(new WorkoutClearActionCreator());
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new EngagementWorkouts(
            clientId: params["client_id"],     
            engagementId: params["engagement_id"],                      
          ),
        ),
      );
      if(responseData["published"]) {
        CustomDialog.alertDialog(context, "Published", "Your client workout has been published.");
      } else {
        CustomDialog.alertDialog(context, "Published", "Your client workout has been set to draft state.");
      }           
    }
  };
}

Function toggleFavoriteWorkoutTemplate(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/program_favorite_toggle", params);
    if (responseData != null) {
      store.dispatch(new ReplaceWorkoutTemplateObjectActionCreator(
        responseData['program'],
        params["selectedIndex"]
      ));
    }
  };
}

Function createWorkoutFromWorkoutTemplate(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_create_from_program", params);
    if (responseData != null) {
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new WorkoutSetup(
            clientId: params["client_id"],
            engagementId: params["engagement_id"],
            workoutId: responseData["id"],           
          ),
        ),
      );      
    }
  };
}



Function createWorkoutFromExercises(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/workout_post", params);
    if (responseData != null) { 
      int workoutId = responseData["id"];      
      Map params2 = new Map();
      params2["package_version"] = PROGRAM_PACKAGE_VERSION;
      params2["workout_id"] = workoutId;
      params2["name"] = params["progression_name"];
      params2["description"] = params["progression_description"];
      params2["duration"] = params["progression_duration"];      
      params2["exercises"] = params["progression_exercises"];     
      Map responseData2 = await post(context, "program/progression_post", params2);
      if(responseData2 != null) {
        Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new WorkoutSetup(
            clientId: params["client_id"],
            engagementId: params["engagement_id"],
            workoutId: workoutId,           
          ),
        ),
      );
      } 
    }
  };
}

Function getWorkoutTemplateList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/program_list", params);
    if (responseData != null) {
      store.dispatch(new WorkoutTemplateListSuccessActionCreator(
        Utils.parseList(responseData, "programs"),
        responseData["paginate_info"],
        responseData["search_params"]
      ));      
    }
  };
}

Function getWorkoutTemplate(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/program_get", params);
    if (responseData != null) {
      store.dispatch(new WorkoutTemplateGetSuccessActionCreator(
        responseData["program"],
        responseData["supporting_data"],
      ));      
    }
  };
}

Function getWorkoutTemplateSearchParams(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PROGRAM_PACKAGE_VERSION;
    Map responseData = await post(context, "program/program_search_params_get", params);
    if (responseData != null) {
      store.dispatch(new SearchParamsSuccessActionCreator(
        responseData['supporting_data']['search_params'],
        responseData['supporting_data']
      ));      
    }
  };
}
