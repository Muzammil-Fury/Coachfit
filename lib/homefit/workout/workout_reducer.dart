import 'package:redux/redux.dart';
import 'package:gomotive/homefit/workout/workout_state.dart';
import 'package:gomotive/homefit/workout/workout_actions.dart';

Reducer<HomeFitWorkoutState> homeFitWorkoutReducer = combineReducers([
  new TypedReducer<HomeFitWorkoutState, RecommendedWorkoutListSuccessActionCreator>(_recommendedWorkoutListSuccessActionCreator),
  new TypedReducer<HomeFitWorkoutState, homeFitWorkoutGetSuccessActionCreator>(_workoutGetSuccessActionCreator), //change Action name
  new TypedReducer<HomeFitWorkoutState, homeFitWorkoutListSuccessActionCreator>(_workoutListSuccessActionCreator), //change
  new TypedReducer<HomeFitWorkoutState, WorkoutFavoriteToggleActionCreator>(_workoutFavoriteToggleActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterMovementMeterActionCreator>(_filterMovementMeterActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterEquipmentActionCreator>(_filterEquipmentActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterWorkoutTypeActionCreator>(_filterWorkoutTypeActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterWorkoutDurationActionCreator>(_filterWorkoutDurationActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterWorkoutFitnessLevelActionCreator>(_filterWorkoutFitnessLevelActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterWorkoutSportsActionCreator>(_filterWorkoutSportsActionCreator),
  new TypedReducer<HomeFitWorkoutState, FilterFavoriteActionCreator>(_filterFavoriteActionCreator),
  new TypedReducer<HomeFitWorkoutState, MobilityWorkoutListSuccessActionCreator>(_mobilityWorkoutListSuccessActionCreator),
  new TypedReducer<HomeFitWorkoutState, StrengthWorkoutListSuccessActionCreator>(_strengthWorkoutListSuccessActionCreator),
  new TypedReducer<HomeFitWorkoutState, MetabolicWorkoutListSuccessActionCreator>(_metabolicWorkoutListSuccessActionCreator),
  new TypedReducer<HomeFitWorkoutState, PowerWorkoutListSuccessActionCreator>(_powerWorkoutListSuccessActionCreator),
  new TypedReducer<HomeFitWorkoutState, MobilityResilienceWorkoutListSuccessActionCreator>(
    _mobilityResilienceWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MobilityFluidityWorkoutListSuccessActionCreator>(
    _mobilityFluidityWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MobilityActivationWorkoutListSuccessActionCreator>(
    _mobilityActivationWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MobilityKidsfitWorkoutListSuccessActionCreator>(
    _mobilityKidsfitWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MobilityWorkfitWorkoutListSuccessActionCreator>(
    _mobilityWorkfitWorkoutListSuccessActionCreator
  ),

  new TypedReducer<HomeFitWorkoutState, StrengthPushPullWorkoutListSuccessActionCreator>(
    _strengthPushPullWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, StrengthLiftingCarryingWorkoutListSuccessActionCreator>(
    _strengthLiftingCarryingWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, StrengthGrand2StandWorkoutListSuccessActionCreator>(
    _strengthGrand2StandWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, StrengthRotationalStrengthWorkoutListSuccessActionCreator>(
    _strengthRotationalStrengthWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, StrengthKidsfitWorkoutListSuccessActionCreator>(
    _strengthKidsfitWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, StrengthWorkfitWorkoutListSuccessActionCreator>(
    _strengthWorkfitWorkoutListSuccessActionCreator
  ),

  new TypedReducer<HomeFitWorkoutState, MetabolicHiitWorkoutListSuccessActionCreator>(
    _metabolicHiitWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MetabolicHiisWorkoutListSuccessActionCreator>(
    _metabolicHiisWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MetabolicSissWorkoutListSuccessActionCreator>(
    _metabolicSissWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, MetabolicKidsfitWorkoutListSuccessActionCreator>(
    _metabolicKidsfitWorkoutListSuccessActionCreator
  ),

  new TypedReducer<HomeFitWorkoutState, PowerAccelerationDecelerationWorkoutListSuccessActionCreator>(
    _powerAccelerationDecelerationWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, PowerSpeedReactionWorkoutListSuccessActionCreator>(
    _powerSpeedReactionWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, PowerMaxPowerWorkoutListSuccessActionCreator>(
    _powerMaxPowerWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, PowerPylometricsWorkoutListSuccessActionCreator>(
    _powerPylometricsWorkoutListSuccessActionCreator
  ),
  new TypedReducer<HomeFitWorkoutState, PowerKidsfitWorkoutListSuccessActionCreator>(
    _powerKidsfitWorkoutListSuccessActionCreator
  ),
]);

HomeFitWorkoutState _getCopy(HomeFitWorkoutState state) {
  return new HomeFitWorkoutState().copyWith(
    recommendedWorkouts: state.recommendedWorkouts,    
    workouts: state.workouts,
    workout: state.workout,
    isFavoriteWorkout: state.isFavoriteWorkout,
    paginateInfo: state.paginateInfo,
    favoriteList: state.favoriteList,
    isValidHomeFitSubscription: state.isValidHomeFitSubscription,
    movementMeterFilter: state.movementMeterFilter,
    equipmentBodyweight: state.equipmentBodyweight,
    equipmentDumbbell: state.equipmentDumbbell,
    equipmentKettlebell: state.equipmentKettlebell,
    equipmentPowerPlate: state.equipmentPowerPlate,
    equipmentFoamRoller: state.equipmentFoamRoller,
    equipmentBands: state.equipmentBands,
    equipmentBosu: state.equipmentBosu,
    equipmentRockblade: state.equipmentRockblade,
    workoutType: state.workoutType,
    workoutDuration: state.workoutDuration,
    workoutFitnessLevel: state.workoutFitnessLevel,
    workoutSports: state.workoutSports,
    favoriteEnabled: state.favoriteEnabled,
    mobilityWorkouts: state.mobilityWorkouts,
    mobilityWorkoutsPaginateInfo: state.mobilityWorkoutsPaginateInfo,
    strengthWorkouts: state.strengthWorkouts,
    strengthWorkoutsPaginateInfo: state.strengthWorkoutsPaginateInfo,
    metabolicWorkouts: state.metabolicWorkouts,
    metabolicWorkoutsPaginateInfo: state.metabolicWorkoutsPaginateInfo,
    powerWorkouts: state.powerWorkouts,
    powerWorkoutsPaginateInfo: state.powerWorkoutsPaginateInfo,
    mobilityResilienceWorkouts: state.mobilityResilienceWorkouts,
    mobilityResiliencePaginateInfo: state.mobilityResiliencePaginateInfo,
    mobilityFluidityWorkouts: state.mobilityFluidityWorkouts,
    mobilityFluidityPaginateInfo: state.mobilityFluidityPaginateInfo,
    mobilityActivationWorkouts: state.mobilityActivationWorkouts,
    mobilityActivationPaginateInfo: state.mobilityActivationPaginateInfo,
    mobilityKidsFitWorkouts: state.mobilityKidsFitWorkouts,
    mobilityKidsFitPaginateInfo: state.mobilityKidsFitPaginateInfo,
    mobilityWorkFitWorkouts: state.mobilityWorkFitWorkouts,
    mobilityWorkFitPaginateInfo: state.mobilityWorkFitPaginateInfo,
    strengthPushPullWorkouts: state.strengthPushPullWorkouts,
    strengthPushPullPaginateInfo: state.strengthPushPullPaginateInfo,

    strengthLiftingCarryingWorkouts: state.strengthLiftingCarryingWorkouts,
    strengthLiftingCarryingPaginateInfo: state.strengthLiftingCarryingPaginateInfo,

    strengthGrand2StandWorkouts: state.strengthGrand2StandWorkouts,
    strengthGrand2StandPaginateInfo: state.strengthGrand2StandPaginateInfo,

    strengthRotationalStrengthWorkouts: state.strengthRotationalStrengthWorkouts,
    strengthRotationalStrengthPaginateInfo: state.strengthRotationalStrengthPaginateInfo,

    strengthKidsFitWorkouts: state.strengthKidsFitWorkouts,
    strengthKidsFitPaginateInfo: state.strengthKidsFitPaginateInfo,

    strengthWorkFitWorkouts: state.strengthWorkFitWorkouts,
    strengthWorkFitPaginateInfo: state.strengthWorkFitPaginateInfo,

    metabolicHIITWorkouts: state.metabolicHIITWorkouts,
    metabolicHIITPaginateInfo: state.metabolicHIITPaginateInfo,

    metabolicHIISWorkouts: state.metabolicHIISWorkouts,
    metabolicHIISPaginateInfo: state.metabolicHIISPaginateInfo,

    metabolicSISSWorkouts: state.metabolicSISSWorkouts,
    metabolicSISSPaginateInfo: state.metabolicSISSPaginateInfo,

    metabolicKidsFitWorkouts: state.metabolicKidsFitWorkouts,
    metabolicKidsFitPaginateInfo: state.metabolicKidsFitPaginateInfo,

    powerAccelerationDecelerationWorkouts: state.powerAccelerationDecelerationWorkouts,
    powerAccelerationDecelerationPaginateInfo: state.powerAccelerationDecelerationPaginateInfo,

    powerSpeedReactionWorkouts: state.powerSpeedReactionWorkouts,
    powerSpeedReactionPaginateInfo: state.powerSpeedReactionPaginateInfo,

    powerMaxPowerWorkouts: state.powerMaxPowerWorkouts,
    powerMaxPowerPaginateInfo: state.powerMaxPowerPaginateInfo,

    powerPlyometricsWorkouts: state.powerPlyometricsWorkouts,
    powerPlyometricsPaginateInfo: state.powerPlyometricsPaginateInfo,

    powerKidsFitWorkouts: state.powerKidsFitWorkouts,
    powerKidsFitPaginateInfo: state.powerKidsFitPaginateInfo,    
  );
}

HomeFitWorkoutState _workoutListSuccessActionCreator(HomeFitWorkoutState state, homeFitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      workouts: action.workouts,
      paginateInfo: action.paginateInfo,      
      favoriteList: action.favoriteList,
      isValidHomeFitSubscription: action.isValidHomeFitSubscription
    );  
  } else {
    return _getCopy(state).copyWith(
      workouts: []..addAll(state.workouts)..addAll(action.workouts),
      paginateInfo: action.paginateInfo,      
      favoriteList: action.favoriteList,
      isValidHomeFitSubscription: action.isValidHomeFitSubscription
    );  
  }
}

HomeFitWorkoutState _recommendedWorkoutListSuccessActionCreator(HomeFitWorkoutState state, RecommendedWorkoutListSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    recommendedWorkouts: action.recommendedWorkouts
  );
}

HomeFitWorkoutState _workoutGetSuccessActionCreator(HomeFitWorkoutState state, homeFitWorkoutGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    workout: action.workout,
    isFavoriteWorkout: action.isFavorite
  );
}

HomeFitWorkoutState _workoutFavoriteToggleActionCreator(HomeFitWorkoutState state, WorkoutFavoriteToggleActionCreator action) {
  return _getCopy(state).copyWith(
    isFavoriteWorkout: action.isFavorite
  );
}

HomeFitWorkoutState _filterMovementMeterActionCreator(HomeFitWorkoutState state, FilterMovementMeterActionCreator action) {
  return _getCopy(state).copyWith(
    movementMeterFilter: action.movementMeterFilter
  );
}

HomeFitWorkoutState _filterEquipmentActionCreator(HomeFitWorkoutState state, FilterEquipmentActionCreator action) {
  
  if(action.toggleEquipment == "bodyweight") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentBodyweight: !state.equipmentBodyweight
    );
    return newState;
  } else if(action.toggleEquipment == "dumbbell") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentDumbbell: !state.equipmentDumbbell
    );
    return newState;
  } else if(action.toggleEquipment == "kettlebell") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentKettlebell: !state.equipmentKettlebell
    );
    return newState;
  } else if(action.toggleEquipment == "powerplate") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentPowerPlate: !state.equipmentPowerPlate
    );
    return newState;
  } else if(action.toggleEquipment == "foamroller") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentFoamRoller: !state.equipmentFoamRoller
    );
    return newState;
  } else if(action.toggleEquipment == "band") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentBands: !state.equipmentBands
    );
    return newState;    
  } else if(action.toggleEquipment == "bosu") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentBosu: !state.equipmentBosu
    );
    return newState;    
  } else if(action.toggleEquipment == "rockblade") {
    HomeFitWorkoutState newState = _getCopy(state).copyWith(
      equipmentRockblade: !state.equipmentRockblade
    );
    return newState;    
  }
}

HomeFitWorkoutState _filterWorkoutTypeActionCreator(HomeFitWorkoutState state, FilterWorkoutTypeActionCreator action) {
  return _getCopy(state).copyWith(
    workoutType: action.workoutType
  );
}

HomeFitWorkoutState _filterWorkoutDurationActionCreator(HomeFitWorkoutState state, FilterWorkoutDurationActionCreator action) {
  return _getCopy(state).copyWith(
    workoutDuration: action.workoutDuration
  );
}

HomeFitWorkoutState _filterWorkoutFitnessLevelActionCreator(HomeFitWorkoutState state, FilterWorkoutFitnessLevelActionCreator action) {
  HomeFitWorkoutState newState =  _getCopy(state).copyWith(
    workoutFitnessLevel: action.workoutFitnessLevel
  );
  return newState;
}


HomeFitWorkoutState _filterWorkoutSportsActionCreator(HomeFitWorkoutState state, FilterWorkoutSportsActionCreator action) {
  HomeFitWorkoutState newState =  _getCopy(state).copyWith(
    workoutSports: action.workoutSports
  );
  return newState;
}


HomeFitWorkoutState _filterFavoriteActionCreator(HomeFitWorkoutState state, FilterFavoriteActionCreator action) {
  HomeFitWorkoutState newState =  _getCopy(state).copyWith(
    favoriteEnabled: action.favoriteEnabled
  );
  return newState;
}



HomeFitWorkoutState _mobilityWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityWorkouts: action.workouts,
      mobilityWorkoutsPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityWorkouts: []..addAll(state.mobilityWorkouts)..addAll(action.workouts),
      mobilityWorkoutsPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _strengthWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthWorkouts: action.workouts,
      strengthWorkoutsPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthWorkouts: []..addAll(state.strengthWorkouts)..addAll(action.workouts),
      strengthWorkoutsPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _metabolicWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MetabolicWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      metabolicWorkouts: action.workouts,
      metabolicWorkoutsPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      metabolicWorkouts: []..addAll(state.metabolicWorkouts)..addAll(action.workouts),
      metabolicWorkoutsPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _powerWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerWorkouts: action.workouts,
      powerWorkoutsPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerWorkouts: []..addAll(state.powerWorkouts)..addAll(action.workouts),
      powerWorkoutsPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _mobilityResilienceWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityResilienceWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityResilienceWorkouts: action.workouts,
      mobilityResiliencePaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityResilienceWorkouts: []..addAll(state.mobilityResilienceWorkouts)..addAll(action.workouts),
      mobilityResiliencePaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _mobilityFluidityWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityFluidityWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityFluidityWorkouts: action.workouts,
      mobilityFluidityPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityFluidityWorkouts: []..addAll(state.mobilityFluidityWorkouts)..addAll(action.workouts),
      mobilityFluidityPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _mobilityActivationWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityActivationWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityActivationWorkouts: action.workouts,
      mobilityActivationPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityActivationWorkouts: []..addAll(state.mobilityActivationWorkouts)..addAll(action.workouts),
      mobilityActivationPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _mobilityKidsfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityKidsfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityKidsFitWorkouts: action.workouts,
      mobilityKidsFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityKidsFitWorkouts: []..addAll(state.mobilityKidsFitWorkouts)..addAll(action.workouts),
      mobilityKidsFitPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _mobilityWorkfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MobilityWorkfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      mobilityWorkFitWorkouts: action.workouts,
      mobilityWorkFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      mobilityWorkFitWorkouts: []..addAll(state.mobilityWorkFitWorkouts)..addAll(action.workouts),
      mobilityWorkFitPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _strengthPushPullWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthPushPullWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthPushPullWorkouts: action.workouts,
      strengthPushPullPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthPushPullWorkouts: []..addAll(state.strengthPushPullWorkouts)..addAll(action.workouts),
      strengthPushPullPaginateInfo: action.paginateInfo,            
    );  
  }
}

HomeFitWorkoutState _strengthLiftingCarryingWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthLiftingCarryingWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthLiftingCarryingWorkouts: action.workouts,
      strengthLiftingCarryingPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthLiftingCarryingWorkouts: []..addAll(state.strengthLiftingCarryingWorkouts)..addAll(action.workouts),
      strengthLiftingCarryingPaginateInfo: action.paginateInfo,            
    );  
  }  
}

HomeFitWorkoutState _strengthGrand2StandWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthGrand2StandWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthGrand2StandWorkouts: action.workouts,
      strengthGrand2StandPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthGrand2StandWorkouts: []..addAll(state.strengthGrand2StandWorkouts)..addAll(action.workouts),
      strengthGrand2StandPaginateInfo: action.paginateInfo,            
    );  
  }  
}
  
HomeFitWorkoutState _strengthRotationalStrengthWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthRotationalStrengthWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthRotationalStrengthWorkouts: action.workouts,
      strengthRotationalStrengthPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthRotationalStrengthWorkouts: []..addAll(state.strengthRotationalStrengthWorkouts)..addAll(action.workouts),
      strengthRotationalStrengthPaginateInfo: action.paginateInfo,            
    );  
  }  
}

HomeFitWorkoutState _strengthKidsfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthKidsfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthKidsFitWorkouts: action.workouts,
      strengthKidsFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthKidsFitWorkouts: []..addAll(state.strengthKidsFitWorkouts)..addAll(action.workouts),
      strengthKidsFitPaginateInfo: action.paginateInfo,            
    );  
  }    
}

HomeFitWorkoutState _strengthWorkfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, StrengthWorkfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      strengthWorkFitWorkouts: action.workouts,
      strengthWorkFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      strengthWorkFitWorkouts: []..addAll(state.strengthWorkFitWorkouts)..addAll(action.workouts),
      strengthWorkFitPaginateInfo: action.paginateInfo,            
    );  
  }    
}


HomeFitWorkoutState _metabolicHiitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MetabolicHiitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      metabolicHIITWorkouts: action.workouts,
      metabolicHIITPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      metabolicHIITWorkouts: []..addAll(state.metabolicHIITWorkouts)..addAll(action.workouts),
      metabolicHIITPaginateInfo: action.paginateInfo,            
    );  
  }    
}

HomeFitWorkoutState _metabolicHiisWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MetabolicHiisWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      metabolicHIISWorkouts: action.workouts,
      metabolicHIISPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      metabolicHIISWorkouts: []..addAll(state.metabolicHIISWorkouts)..addAll(action.workouts),
      metabolicHIISPaginateInfo: action.paginateInfo,            
    );  
  }    
}

HomeFitWorkoutState _metabolicSissWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MetabolicSissWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      metabolicSISSWorkouts: action.workouts,
      metabolicSISSPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      metabolicSISSWorkouts: []..addAll(state.metabolicSISSWorkouts)..addAll(action.workouts),
      metabolicSISSPaginateInfo: action.paginateInfo,            
    );  
  }    
}

HomeFitWorkoutState _metabolicKidsfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, MetabolicKidsfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      metabolicKidsFitWorkouts: action.workouts,
      metabolicKidsFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      metabolicKidsFitWorkouts: []..addAll(state.metabolicKidsFitWorkouts)..addAll(action.workouts),
      metabolicKidsFitPaginateInfo: action.paginateInfo,            
    );  
  }      
}

HomeFitWorkoutState _powerAccelerationDecelerationWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerAccelerationDecelerationWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerAccelerationDecelerationWorkouts: action.workouts,
      powerAccelerationDecelerationPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerAccelerationDecelerationWorkouts: []..addAll(state.powerAccelerationDecelerationWorkouts)..addAll(action.workouts),
      powerAccelerationDecelerationPaginateInfo: action.paginateInfo,            
    );  
  }        
}

HomeFitWorkoutState _powerSpeedReactionWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerSpeedReactionWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerSpeedReactionWorkouts: action.workouts,
      powerSpeedReactionPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerSpeedReactionWorkouts: []..addAll(state.powerSpeedReactionWorkouts)..addAll(action.workouts),
      powerSpeedReactionPaginateInfo: action.paginateInfo,            
    );  
  }        
}

HomeFitWorkoutState _powerMaxPowerWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerMaxPowerWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerMaxPowerWorkouts: action.workouts,
      powerMaxPowerPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerMaxPowerWorkouts: []..addAll(state.powerMaxPowerWorkouts)..addAll(action.workouts),
      powerMaxPowerPaginateInfo: action.paginateInfo,            
    );  
  }        
}

HomeFitWorkoutState _powerPylometricsWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerPylometricsWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerPlyometricsWorkouts: action.workouts,
      powerPlyometricsPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerPlyometricsWorkouts: []..addAll(state.powerPlyometricsWorkouts)..addAll(action.workouts),
      powerPlyometricsPaginateInfo: action.paginateInfo,            
    );  
  }        
}

HomeFitWorkoutState _powerKidsfitWorkoutListSuccessActionCreator(HomeFitWorkoutState state, PowerKidsfitWorkoutListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      powerKidsFitWorkouts: action.workouts,
      powerKidsFitPaginateInfo: action.paginateInfo,
    );  
  } else {
    return _getCopy(state).copyWith(
      powerKidsFitWorkouts: []..addAll(state.powerKidsFitWorkouts)..addAll(action.workouts),
      powerKidsFitPaginateInfo: action.paginateInfo,            
    );  
  }          
}
