import 'package:meta/meta.dart';
import 'package:homefit/home/home_state.dart';
import 'package:homefit/workout/workout_state.dart';
import 'package:homefit/user/user_state.dart';

@immutable
class AppState {
  final HomeFitHomeState homeFitHomeState;
  final HomeFitWorkoutState homeFitWorkoutState;
  final UserState userState;
  
  AppState(
    {
      HomeFitHomeState homeFitHomeState,
      HomeFitWorkoutState homeFitWorkoutState,
      UserState userState,
    }
  )
    : homeFitHomeState = homeFitHomeState ?? new HomeFitHomeState(),
      homeFitWorkoutState = homeFitWorkoutState ?? new HomeFitWorkoutState(),
      userState = userState ?? new UserState();

  AppState copyWith(
      {
        HomeFitHomeState homeFitHomeState,
        HomeFitWorkoutState homeFitWorkoutState,
        UserState userState,
      }) {
    return AppState(
      homeFitHomeState: homeFitHomeState ?? this.homeFitHomeState,
      homeFitWorkoutState: homeFitWorkoutState ?? this.homeFitWorkoutState,
      userState: userState ?? this.userState,
    );
  }
}
