import 'package:redux/redux.dart';
import 'package:gomotive/homefit/home/home_state.dart';
import 'package:gomotive/homefit/home/home_actions.dart';

Reducer<HomeFitHomeState> homeFitHomeReducer = combineReducers([      // Done
  new TypedReducer<HomeFitHomeState, VerifyEmailSuccessActionCreator>(_verifyEmailSuccessActionCreator),
  new TypedReducer<HomeFitHomeState, ClearVerifyEmailActionCreator>(_clearVerifyEmailActionCreator),
  new TypedReducer<HomeFitHomeState, DashboardDetailsSuccessActionCreator>(_dashboardDetailsSuccessActionCreator),
  new TypedReducer<HomeFitHomeState, DashboardDetailsMovementMeterSuccessActionCreator>(_dashboardDetailsMovementMeterSuccessActionCreator),
  new TypedReducer<HomeFitHomeState, VerifyUserActionCreator>(_verifyUserActionCreator),
  new TypedReducer<HomeFitHomeState, FamilyPlanMemberListSuccessActionCreator>(_familyPlanMemberListActionCreator),
  new TypedReducer<HomeFitHomeState, UpdateUserMovementMeterSettingsActionCreator>(_updateUserMovementMeterSettingsActionCreator),
  new TypedReducer<HomeFitHomeState, DashboardNewWorkoutsSuccess>(_dashboardNewWorkoutsSuccess),
  new TypedReducer<HomeFitHomeState, DashboardFavoriteWorkoutsSuccess>(_dashboardFavoriteWorkoutsSuccess),
  new TypedReducer<HomeFitHomeState, HomeCleanup>(_homeCleanup),
]);

HomeFitHomeState _getCopy(HomeFitHomeState state) {
  return new HomeFitHomeState().copyWith(
    welcomeVideoId: state.welcomeVideoId,
    welcomeVideoURL: state.welcomeVideoURL,
    welcomeVideoThumbnailURL: state.welcomeVideoThumbnailURL,
    user: state.user,
    currentWeekMovementPoints: state.currentWeekMovementPoints,
    familyPlanMemberList: state.familyPlanMemberList,
    movementMeterConfiguration: state.movementMeterConfiguration,
    availableSports: state.availableSports,
    userEmailExists: state.userEmailExists,
    plans: state.plans,
    newWorkouts: state.newWorkouts,
    favoriteWorkouts: state.favoriteWorkouts,
    favoriteWorkoutsPaginateInfo: state.favoriteWorkoutsPaginateInfo,
  );
}



HomeFitHomeState _clearVerifyEmailActionCreator(HomeFitHomeState state, ClearVerifyEmailActionCreator action) {
  return _getCopy(state).copyWith(
    userEmailExists: -1
  );
}

HomeFitHomeState _verifyEmailSuccessActionCreator(HomeFitHomeState state, VerifyEmailSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    userEmailExists: action.emailExists
  );
}


HomeFitHomeState _dashboardDetailsSuccessActionCreator(HomeFitHomeState state, DashboardDetailsSuccessActionCreator action) {
  List<Map> _availableSports = action.availableSports;
  Map<String, dynamic> emptySports = new Map<String, dynamic>();
  emptySports["id"] = "0";
  emptySports["name"] = "";   
  _availableSports.insert(0, emptySports);
  return _getCopy(state).copyWith(
    welcomeVideoId: action.welcomeVideoId,
    welcomeVideoURL: action.welcomeVideoURL,
    welcomeVideoThumbnailURL: action.welcomeVideoThumbnailURL,
    availableSports: _availableSports,
  );
}

HomeFitHomeState _dashboardDetailsMovementMeterSuccessActionCreator(HomeFitHomeState state, DashboardDetailsMovementMeterSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    currentWeekMovementPoints: action.currentWeekMovementMeter
  );
}

HomeFitHomeState _verifyUserActionCreator(HomeFitHomeState state, VerifyUserActionCreator action) {
  return _getCopy(state).copyWith(
    user: action.user,
    movementMeterConfiguration: action.user["movement_meter_configuration"],
    plans: action.plans,
  );
}

HomeFitHomeState _familyPlanMemberListActionCreator(HomeFitHomeState state, FamilyPlanMemberListSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    familyPlanMemberList: action.familyPlanMemberList
  );
}

HomeFitHomeState _updateUserMovementMeterSettingsActionCreator(HomeFitHomeState state, UpdateUserMovementMeterSettingsActionCreator action) {
  return _getCopy(state).copyWith(
    movementMeterConfiguration: action.movementMeterConfiguration
  );
}

HomeFitHomeState _dashboardNewWorkoutsSuccess(HomeFitHomeState state, DashboardNewWorkoutsSuccess action) {
  return _getCopy(state).copyWith(
    newWorkouts: action.newWorkouts
  );
}

HomeFitHomeState _dashboardFavoriteWorkoutsSuccess(HomeFitHomeState state, DashboardFavoriteWorkoutsSuccess action) {
  return _getCopy(state).copyWith(
    favoriteWorkouts: action.favoriteWorkouts,
    favoriteWorkoutsPaginateInfo: action.favoriteWorkoutsPaginateInfo,
  );
}


HomeFitHomeState _homeCleanup(HomeFitHomeState state, HomeCleanup action) {
  return _getCopy(state).copyWith(
    welcomeVideoId: null,
    welcomeVideoURL: null,
    welcomeVideoThumbnailURL: null,
    user: null,
    currentWeekMovementPoints: null,
    familyPlanMemberList: null,
    movementMeterConfiguration: null
  );
}