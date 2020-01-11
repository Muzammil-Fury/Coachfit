import 'package:redux/redux.dart';
import 'package:gomotive/homefit/user/user_actions.dart';
import 'package:gomotive/homefit/user/user_state.dart';

Reducer<UserState> userReducer = combineReducers([  
  new TypedReducer<UserState, FetchUserProfileDetailsActionCreator>(_fetchUserProfileDetailsActionCreator),  
  new TypedReducer<UserState, MovementMeterSettingsFetchActionCreator>(_movementMeterSettingsFetchActionCreator),  
  new TypedReducer<UserState, UserMovementMeterWeeklyGraph>(_userMovementMeterWeeklyGraph),  
]);

UserState _getCopy(UserState state) {
  return new UserState().copyWith(    
    user: state.user,
    genderList: state.genderList,
    timezoneList: state.timezoneList,
    movementMeterSettings: state.movementMeterSettings
  );
}

UserState _fetchUserProfileDetailsActionCreator(UserState state, FetchUserProfileDetailsActionCreator action) {
  return _getCopy(state).copyWith(    
    user: action.user,
    genderList: action.genderList,
    timezoneList: action.timezoneList,
  );  
}



UserState _movementMeterSettingsFetchActionCreator(UserState state, MovementMeterSettingsFetchActionCreator action) {
  return _getCopy(state).copyWith(    
    movementMeterSettings: action.movementMeterSettings
  );  
}

UserState _userMovementMeterWeeklyGraph(UserState state, UserMovementMeterWeeklyGraph action) {
  return _getCopy(state).copyWith(    
    movementMeterWeeklyGraph: action.movementMeterWeeklyGraph
  );  
}

