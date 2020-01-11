class RecommendedWorkoutListSuccessActionCreator {
  final List<Map> recommendedWorkouts;
  RecommendedWorkoutListSuccessActionCreator(
    this.recommendedWorkouts
  );
}

class homeFitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;
  final List favoriteList;
  final bool isValidHomeFitSubscription;
  homeFitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
    this.favoriteList,
    this.isValidHomeFitSubscription
  );
}


class homeFitWorkoutGetSuccessActionCreator {
  final Map workout;
  final bool isFavorite;
  homeFitWorkoutGetSuccessActionCreator(
    this.workout,
    this.isFavorite
  );
}

class WorkoutFavoriteToggleActionCreator {
  final bool isFavorite;
  WorkoutFavoriteToggleActionCreator(
    this.isFavorite
  );
}


class FilterFavoriteActionCreator {
  final bool favoriteEnabled;
  FilterFavoriteActionCreator(
    this.favoriteEnabled
  );
}


class FilterMovementMeterActionCreator {
  final String movementMeterFilter;
  FilterMovementMeterActionCreator(
    this.movementMeterFilter
  );
}

class FilterEquipmentActionCreator {
  final String toggleEquipment;
  FilterEquipmentActionCreator(
    this.toggleEquipment
  );
}

class FilterWorkoutTypeActionCreator {
  final String workoutType;
  FilterWorkoutTypeActionCreator(
    this.workoutType
  );
}

class FilterWorkoutDurationActionCreator {
  final int workoutDuration;
  FilterWorkoutDurationActionCreator(
    this.workoutDuration
  );
}

class FilterWorkoutFitnessLevelActionCreator {
  final String workoutFitnessLevel;
  FilterWorkoutFitnessLevelActionCreator(
    this.workoutFitnessLevel
  );
}

class FilterWorkoutSportsActionCreator {
  final int workoutSports;
  FilterWorkoutSportsActionCreator(
    this.workoutSports
  );
}

class MobilityWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class MetabolicWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MetabolicWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MobilityResilienceWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityResilienceWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MobilityFluidityWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityFluidityWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MobilityActivationWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityActivationWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MobilityKidsfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityKidsfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MobilityWorkfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MobilityWorkfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthPushPullWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthPushPullWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthLiftingCarryingWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthLiftingCarryingWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthGrand2StandWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthGrand2StandWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class StrengthRotationalStrengthWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthRotationalStrengthWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthKidsfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthKidsfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class StrengthWorkfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  StrengthWorkfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MetabolicHiitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MetabolicHiitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MetabolicHiisWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MetabolicHiisWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}


class MetabolicSissWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MetabolicSissWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class MetabolicKidsfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  MetabolicKidsfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerAccelerationDecelerationWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerAccelerationDecelerationWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerSpeedReactionWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerSpeedReactionWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerMaxPowerWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerMaxPowerWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerPylometricsWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerPylometricsWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}

class PowerKidsfitWorkoutListSuccessActionCreator {
  final List<Map> workouts;
  final Map paginateInfo;  
  PowerKidsfitWorkoutListSuccessActionCreator(
    this.workouts,
    this.paginateInfo,
  );
}



