import 'package:meta/meta.dart';

@immutable
class HomeFitWorkoutState {

  final List<Map> recommendedWorkouts;
  final List<Map> workouts;
  final Map workout;
  final bool isFavoriteWorkout;
  final Map paginateInfo;
  final bool isValidHomeFitSubscription;
  final List favoriteList;
  final String movementMeterFilter;
  final bool equipmentBodyweight;
  final bool equipmentDumbbell;
  final bool equipmentKettlebell;
  final bool equipmentPowerPlate;
  final bool equipmentFoamRoller;
  final bool equipmentBands;
  final bool equipmentBosu;
  final bool equipmentRockblade;
  final String workoutType;
  final int workoutDuration;
  final String workoutFitnessLevel;
  final int workoutSports;
  final bool favoriteEnabled;
  final List<Map> mobilityWorkouts;
  final Map mobilityWorkoutsPaginateInfo;
  final List<Map> mobilityResilienceWorkouts;
  final Map mobilityResiliencePaginateInfo;
  final List<Map> mobilityFluidityWorkouts;
  final Map mobilityFluidityPaginateInfo;
  final List<Map> mobilityActivationWorkouts;
  final Map mobilityActivationPaginateInfo;
  final List<Map> mobilityKidsFitWorkouts;
  final Map mobilityKidsFitPaginateInfo;
  final List<Map> mobilityWorkFitWorkouts;
  final Map mobilityWorkFitPaginateInfo;
  final List<Map> strengthWorkouts;
  final Map strengthWorkoutsPaginateInfo;
  final List<Map> strengthPushPullWorkouts;
  final Map strengthPushPullPaginateInfo;
  final List<Map> strengthLiftingCarryingWorkouts;
  final Map strengthLiftingCarryingPaginateInfo;
  final List<Map> strengthGrand2StandWorkouts;
  final Map strengthGrand2StandPaginateInfo;
  final List<Map> strengthRotationalStrengthWorkouts;
  final Map strengthRotationalStrengthPaginateInfo;
  final List<Map> strengthKidsFitWorkouts;
  final Map strengthKidsFitPaginateInfo;
  final List<Map> strengthWorkFitWorkouts;
  final Map strengthWorkFitPaginateInfo;
  final List<Map> metabolicWorkouts;
  final Map metabolicWorkoutsPaginateInfo;
  final List<Map> metabolicHIITWorkouts;
  final Map metabolicHIITPaginateInfo;
  final List<Map> metabolicHIISWorkouts;
  final Map metabolicHIISPaginateInfo;
  final List<Map> metabolicSISSWorkouts;
  final Map metabolicSISSPaginateInfo;
  final List<Map> metabolicKidsFitWorkouts;
  final Map metabolicKidsFitPaginateInfo;
  final List<Map> powerWorkouts;
  final Map powerWorkoutsPaginateInfo;
  final List<Map> powerAccelerationDecelerationWorkouts;
  final Map powerAccelerationDecelerationPaginateInfo;
  final List<Map> powerSpeedReactionWorkouts;
  final Map powerSpeedReactionPaginateInfo;
  final List<Map> powerMaxPowerWorkouts;
  final Map powerMaxPowerPaginateInfo;
  final List<Map> powerPlyometricsWorkouts;
  final Map powerPlyometricsPaginateInfo;
  final List<Map> powerKidsFitWorkouts;
  final Map powerKidsFitPaginateInfo;

  const HomeFitWorkoutState({
    this.recommendedWorkouts,
    this.workouts,
    this.workout,
    this.isFavoriteWorkout,
    this.paginateInfo,
    this.isValidHomeFitSubscription,
    this.favoriteList,
    this.movementMeterFilter,
    this.equipmentBodyweight = false,
    this.equipmentDumbbell = false,
    this.equipmentKettlebell = false,
    this.equipmentPowerPlate = false,
    this.equipmentFoamRoller = false,
    this.equipmentBands = false,
    this.equipmentBosu = false,
    this.equipmentRockblade = false,
    this.workoutType,
    this.workoutDuration,
    this.workoutFitnessLevel,
    this.workoutSports,
    this.favoriteEnabled,
    this.mobilityWorkouts,
    this.mobilityWorkoutsPaginateInfo,
    this.mobilityResilienceWorkouts,
    this.mobilityResiliencePaginateInfo,
    this.mobilityFluidityWorkouts,
    this.mobilityFluidityPaginateInfo,
    this.mobilityActivationWorkouts,
    this.mobilityActivationPaginateInfo,
    this.mobilityKidsFitWorkouts,
    this.mobilityKidsFitPaginateInfo,
    this.mobilityWorkFitWorkouts,
    this.mobilityWorkFitPaginateInfo,
    this.strengthWorkouts,
    this.strengthWorkoutsPaginateInfo,
    this.strengthPushPullWorkouts,
    this.strengthPushPullPaginateInfo,
    this.strengthLiftingCarryingWorkouts,
    this.strengthLiftingCarryingPaginateInfo,
    this.strengthGrand2StandWorkouts,
    this.strengthGrand2StandPaginateInfo,
    this.strengthRotationalStrengthWorkouts,
    this.strengthRotationalStrengthPaginateInfo,
    this.strengthKidsFitWorkouts,
    this.strengthKidsFitPaginateInfo,
    this.strengthWorkFitWorkouts,
    this.strengthWorkFitPaginateInfo,
    this.metabolicWorkouts,
    this.metabolicWorkoutsPaginateInfo,
    this.metabolicHIITWorkouts,
    this.metabolicHIITPaginateInfo,
    this.metabolicHIISWorkouts,
    this.metabolicHIISPaginateInfo,
    this.metabolicSISSWorkouts,
    this.metabolicSISSPaginateInfo,
    this.metabolicKidsFitWorkouts,
    this.metabolicKidsFitPaginateInfo,
    this.powerWorkouts,
    this.powerWorkoutsPaginateInfo,
    this.powerAccelerationDecelerationWorkouts,
    this.powerAccelerationDecelerationPaginateInfo,
    this.powerSpeedReactionWorkouts,
    this.powerSpeedReactionPaginateInfo,
    this.powerMaxPowerWorkouts,
    this.powerMaxPowerPaginateInfo,
    this.powerPlyometricsWorkouts,
    this.powerPlyometricsPaginateInfo,
    this.powerKidsFitWorkouts,
    this.powerKidsFitPaginateInfo,

  });

  HomeFitWorkoutState copyWith({
    List<Map> recommendedWorkouts,
    List<Map> workouts,
    Map workout,
    bool isFavoriteWorkout,
    Map paginateInfo,
    bool isValidHomeFitSubscription,
    List favoriteList,
    final String movementMeterFilter,
    final bool equipmentBodyweight,
    final bool equipmentDumbbell,
    final bool equipmentKettlebell,
    final bool equipmentPowerPlate,
    final bool equipmentFoamRoller,
    final bool equipmentBands,
    final bool equipmentBosu,
    final bool equipmentRockblade,
    final String workoutType,
    final int workoutDuration,
    final String workoutFitnessLevel,
    final int workoutSports,
    final bool favoriteEnabled,
    List<Map> mobilityWorkouts,
    Map mobilityWorkoutsPaginateInfo,
    List<Map> mobilityResilienceWorkouts,
    Map mobilityResiliencePaginateInfo,
    List<Map> mobilityFluidityWorkouts,
    Map mobilityFluidityPaginateInfo,
    List<Map> mobilityActivationWorkouts,
    Map mobilityActivationPaginateInfo,
    List<Map> mobilityKidsFitWorkouts,
    Map mobilityKidsFitPaginateInfo,
    List<Map> mobilityWorkFitWorkouts,
    Map mobilityWorkFitPaginateInfo,
    List<Map> strengthWorkouts,
    Map strengthWorkoutsPaginateInfo,
    List<Map> strengthPushPullWorkouts,
    Map strengthPushPullPaginateInfo,
    List<Map> strengthLiftingCarryingWorkouts,
    Map strengthLiftingCarryingPaginateInfo,
    List<Map> strengthGrand2StandWorkouts,
    Map strengthGrand2StandPaginateInfo,
    List<Map> strengthRotationalStrengthWorkouts,
    Map strengthRotationalStrengthPaginateInfo,
    List<Map> strengthKidsFitWorkouts,
    Map strengthKidsFitPaginateInfo,
    List<Map> strengthWorkFitWorkouts,
    Map strengthWorkFitPaginateInfo,
    List<Map> metabolicWorkouts,    
    Map metabolicWorkoutsPaginateInfo,
    List<Map> metabolicHIITWorkouts,
    Map metabolicHIITPaginateInfo,
    List<Map> metabolicHIISWorkouts,
    Map metabolicHIISPaginateInfo,
    List<Map> metabolicSISSWorkouts,
    Map metabolicSISSPaginateInfo,
    List<Map> metabolicKidsFitWorkouts,
    Map metabolicKidsFitPaginateInfo,
    List<Map> powerWorkouts,
    Map powerWorkoutsPaginateInfo,
    List<Map> powerAccelerationDecelerationWorkouts,
    Map powerAccelerationDecelerationPaginateInfo,
    List<Map> powerSpeedReactionWorkouts,
    Map powerSpeedReactionPaginateInfo,
    List<Map> powerMaxPowerWorkouts,
    Map powerMaxPowerPaginateInfo,
    List<Map> powerPlyometricsWorkouts,
    Map powerPlyometricsPaginateInfo,
    List<Map> powerKidsFitWorkouts,
    Map powerKidsFitPaginateInfo,

  }) {
    return new HomeFitWorkoutState(
      recommendedWorkouts: recommendedWorkouts ?? this.recommendedWorkouts,
      workouts: workouts ?? this.workouts,
      workout: workout ?? this.workout,
      isFavoriteWorkout: isFavoriteWorkout ?? this.isFavoriteWorkout,
      paginateInfo: paginateInfo ?? this.paginateInfo,
      isValidHomeFitSubscription: isValidHomeFitSubscription ?? this.isValidHomeFitSubscription,
      favoriteList: favoriteList ?? this.favoriteList,
      movementMeterFilter: movementMeterFilter ?? this.movementMeterFilter,
      equipmentBodyweight: equipmentBodyweight ?? this.equipmentBodyweight,
      equipmentDumbbell: equipmentDumbbell ?? this.equipmentDumbbell,
      equipmentKettlebell: equipmentKettlebell ?? this.equipmentKettlebell,
      equipmentPowerPlate: equipmentPowerPlate ?? this.equipmentPowerPlate,
      equipmentFoamRoller: equipmentFoamRoller ?? this.equipmentFoamRoller,
      equipmentBands: equipmentBands ?? this.equipmentBands,
      equipmentBosu: equipmentBosu ?? this.equipmentBosu,
      equipmentRockblade: equipmentRockblade ?? this.equipmentRockblade,
      workoutType: workoutType ?? this.workoutType,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      workoutFitnessLevel: workoutFitnessLevel ?? this.workoutFitnessLevel,
      workoutSports: workoutSports ?? this.workoutSports,
      favoriteEnabled: favoriteEnabled ?? this.favoriteEnabled,
      mobilityWorkouts: mobilityWorkouts ?? this.mobilityWorkouts,
      mobilityWorkoutsPaginateInfo: mobilityWorkoutsPaginateInfo ?? this.mobilityWorkoutsPaginateInfo,
      mobilityResilienceWorkouts: mobilityResilienceWorkouts ?? this.mobilityResilienceWorkouts,
      mobilityFluidityWorkouts: mobilityFluidityWorkouts ?? this.mobilityFluidityWorkouts,
      mobilityActivationWorkouts: mobilityActivationWorkouts ?? this.mobilityActivationWorkouts,
      mobilityKidsFitWorkouts: mobilityKidsFitWorkouts ?? this.mobilityKidsFitWorkouts,
      mobilityWorkFitWorkouts: mobilityWorkFitWorkouts ?? this.mobilityWorkFitWorkouts,
      strengthWorkouts: strengthWorkouts ?? this.strengthWorkouts,
      strengthWorkoutsPaginateInfo: strengthWorkoutsPaginateInfo ?? this.strengthWorkoutsPaginateInfo,
      strengthPushPullWorkouts: strengthPushPullWorkouts ?? this.strengthPushPullWorkouts,
      strengthPushPullPaginateInfo: strengthPushPullPaginateInfo ?? this.strengthPushPullPaginateInfo,
      strengthLiftingCarryingWorkouts: strengthLiftingCarryingWorkouts ?? this.strengthLiftingCarryingWorkouts,
      strengthLiftingCarryingPaginateInfo: strengthLiftingCarryingPaginateInfo ?? this.strengthLiftingCarryingPaginateInfo,
      
      strengthGrand2StandWorkouts: strengthGrand2StandWorkouts ?? this.strengthGrand2StandWorkouts,
      strengthGrand2StandPaginateInfo: strengthGrand2StandPaginateInfo ?? this.strengthGrand2StandPaginateInfo,

      strengthRotationalStrengthWorkouts: strengthRotationalStrengthWorkouts ?? this.strengthRotationalStrengthWorkouts,
      strengthRotationalStrengthPaginateInfo: strengthRotationalStrengthPaginateInfo ?? this.strengthRotationalStrengthPaginateInfo,

      strengthKidsFitWorkouts: strengthKidsFitWorkouts ?? this.strengthKidsFitWorkouts,
      strengthKidsFitPaginateInfo: strengthKidsFitPaginateInfo ?? this.strengthKidsFitPaginateInfo,

      strengthWorkFitWorkouts: strengthWorkFitWorkouts ?? this.strengthWorkFitWorkouts,
      strengthWorkFitPaginateInfo: strengthWorkFitPaginateInfo ?? this.strengthWorkFitPaginateInfo,

      metabolicWorkouts: metabolicWorkouts ?? this.metabolicWorkouts,
      metabolicWorkoutsPaginateInfo: metabolicWorkoutsPaginateInfo ?? this.metabolicWorkoutsPaginateInfo,

      metabolicHIITWorkouts: metabolicHIITWorkouts ?? this.metabolicHIITWorkouts,
      metabolicHIITPaginateInfo: metabolicHIITPaginateInfo ?? this.metabolicHIITPaginateInfo,

      metabolicHIISWorkouts: metabolicHIISWorkouts ?? this.metabolicHIISWorkouts,
      metabolicHIISPaginateInfo: metabolicHIISPaginateInfo ?? this.metabolicHIISPaginateInfo,

      metabolicSISSWorkouts: metabolicSISSWorkouts ?? this.metabolicSISSWorkouts,
      metabolicSISSPaginateInfo: metabolicSISSPaginateInfo ?? this.metabolicSISSPaginateInfo,

      metabolicKidsFitWorkouts: metabolicKidsFitWorkouts ?? this.metabolicKidsFitWorkouts,
      metabolicKidsFitPaginateInfo: metabolicKidsFitPaginateInfo ?? this.metabolicKidsFitPaginateInfo,

      powerWorkouts: powerWorkouts ?? this.powerWorkouts,
      powerWorkoutsPaginateInfo: powerWorkoutsPaginateInfo ?? this.powerWorkoutsPaginateInfo,

      powerAccelerationDecelerationWorkouts: powerAccelerationDecelerationWorkouts ?? this.powerAccelerationDecelerationWorkouts,
      powerAccelerationDecelerationPaginateInfo: powerAccelerationDecelerationPaginateInfo ?? this.powerAccelerationDecelerationPaginateInfo,

      powerSpeedReactionWorkouts: powerSpeedReactionWorkouts ?? this.powerSpeedReactionWorkouts,
      powerSpeedReactionPaginateInfo: powerSpeedReactionPaginateInfo ?? this.powerSpeedReactionPaginateInfo,

      powerMaxPowerWorkouts: powerMaxPowerWorkouts ?? this.powerMaxPowerWorkouts,
      powerMaxPowerPaginateInfo: powerMaxPowerPaginateInfo ?? this.powerMaxPowerPaginateInfo,

      powerPlyometricsWorkouts: powerPlyometricsWorkouts ?? this.powerPlyometricsWorkouts,
      powerPlyometricsPaginateInfo: powerPlyometricsPaginateInfo ?? this.powerPlyometricsPaginateInfo,
      
      powerKidsFitWorkouts: powerKidsFitWorkouts ?? this.powerKidsFitWorkouts,
      powerKidsFitPaginateInfo: powerKidsFitPaginateInfo ?? this.powerKidsFitPaginateInfo,
    );
  }
}
