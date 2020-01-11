import 'package:homefit/core/app_state.dart';
import 'package:homefit/home/home_reducer.dart';
import 'package:homefit/workout/workout_reducer.dart';
import 'package:homefit/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    homeFitWorkoutState: homeFitWorkoutReducer(state.homeFitWorkoutState, action),
    homeFitHomeState: homeFitHomeReducer(state.homeFitHomeState, action),
    userState: userReducer(state.userState, action),
  );
}
