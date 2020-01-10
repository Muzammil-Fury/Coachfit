import 'package:redux/redux.dart';
import 'package:gomotive/habit/habit_actions.dart';
import 'package:gomotive/habit/habit_state.dart';

Reducer<HabitState> habitReducer = combineReducers([
  new TypedReducer<HabitState, HabitTemplateListSuccess>(_habitTemplateListSuccess),  
  new TypedReducer<HabitState, EngagementHabitGetSuccess>(_engagementHabitGetSuccess),    
  new TypedReducer<HabitState, ClearEngagementHabitActionCreator>(_clearEngagementHabitActionCreator),          
]);

HabitState _getCopy(HabitState state) {
  return new HabitState().copyWith( 
    habitTemplateList: state.habitTemplateList,
    habitObj: state.habitObj,
    habitFrequencySchedules: state.habitFrequencySchedules,
  );
}

HabitState _habitTemplateListSuccess(HabitState state,  HabitTemplateListSuccess action) {
  return _getCopy(state).copyWith(
    habitTemplateList: action.habitTemplateList,    
  );  
}


HabitState _engagementHabitGetSuccess(HabitState state,  EngagementHabitGetSuccess action) {
  return _getCopy(state).copyWith(
    habitObj: action.habitObj,    
    habitFrequencySchedules: action.habitFrequencySchedules,
    habitFrequencyDurationType: action.habitFrequencyDurationType,
  );  
}

HabitState _clearEngagementHabitActionCreator(HabitState state,  ClearEngagementHabitActionCreator action) {
  return _getCopy(state).copyWith(
    habitObj: new Map(),    
  );  
}


