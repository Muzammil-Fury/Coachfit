import 'package:flutter/material.dart';
import 'dart:core';
import 'package:redux/redux.dart';
import 'package:homefit/utils/network.dart';
import 'package:homefit/core/app_state.dart';
import 'package:homefit/workout/workout_actions.dart';
import 'package:homefit/utils/utils.dart';


const PACKAGE_VERSION = "1";

Function getWorkoutList(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/move_videos_list", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new homeFitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],
          responseData["favorite_list"],
          responseData["is_homefit_subscription_valid"]
        )
      );
    }
  };
}

Function getWorkout(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/client_move_video_get", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new homeFitWorkoutGetSuccessActionCreator(
          responseData["move_video"],
          responseData["is_favorite"]
        )
      );
    }
  };
}

Function toggleWorkoutFavorite(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/move_toggle_favorite", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new WorkoutFavoriteToggleActionCreator(
          !params["is_favorite"]
        )
      );
    }
  };
}


Function getMobilityWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMetabolicWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_metabolic_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MetabolicWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMobilityResilienceWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_resilience_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityResilienceWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMobilityFluidityWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_fluidity_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityFluidityWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMobilityActivationWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_activation_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityActivationWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMobilityKidsfitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_kidsfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityKidsfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMobilityWorkfitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_mobility_workfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MobilityWorkfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthPushPullWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_pushpull_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthPushPullWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthLiftingCarryingWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_liftingcarrying_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthLiftingCarryingWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthGrand2StandWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_grand2stand_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthGrand2StandWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthRotationalStrengthWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_rotationalstrength_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthRotationalStrengthWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}


Function getStrengthKidsfitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_kidsfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthKidsfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getStrengthWorkfitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_strength_workfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new StrengthWorkfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMetabolicHiitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_metabolic_hiit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MetabolicHiitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMetabolicHiisWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_metabolic_hiis_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MetabolicHiisWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMetabolicSissWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_metabolic_siss_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MetabolicSissWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getMetabolicKidsfitWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_metabolic_kidsfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new MetabolicKidsfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerAccelerationDecelerationWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_accelerationdeceleration_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerAccelerationDecelerationWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerSpeedReactionWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_speedreaction_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerSpeedReactionWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerMaxPowerWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_maxpower_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerMaxPowerWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerPlyometricsReactionWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_plyometrics_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerPylometricsWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}

Function getPowerKidsfitReactionWorkouts(BuildContext context, Map params) {
  return (Store<AppState> store) async {
    params["package_version"] = PACKAGE_VERSION;
    Map responseData = await homefitPost(context, "dhfmove/homefit_power_kidsfit_workouts", params);
    if (responseData != null && responseData['status'] == "200") {      
      store.dispatch(
        new PowerKidsfitWorkoutListSuccessActionCreator(
          Utils.parseList(responseData, "move_videos"),
          responseData["paginate_info"],          
        )
      );
    }
  };
}









