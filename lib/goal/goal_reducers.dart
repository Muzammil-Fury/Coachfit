import 'package:redux/redux.dart';
import 'package:gomotive/goal/goal_actions.dart';
import 'package:gomotive/goal/goal_state.dart';

Reducer<GoalState> goalReducer = combineReducers([  
  new TypedReducer<GoalState, GoalTemplateListSuccessActionCreator>(_goalTemplateListSuccessActionCreator),        
  new TypedReducer<GoalState, GoalTrackingUnitListSuccessActionCreator>(_goalTrackingUnitListSuccessActionCreator),        
]);

GoalState _getCopy(GoalState state) {
  return new GoalState().copyWith(     
    goalTemplateList: state.goalTemplateList,
    goalTrackingUnitList: state.goalTrackingUnitList
  );
}

GoalState _goalTemplateListSuccessActionCreator(GoalState state,  GoalTemplateListSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    goalTemplateList: action.goalTemplateList,
  );  
}

GoalState _goalTrackingUnitListSuccessActionCreator(GoalState state,  GoalTrackingUnitListSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    goalTrackingUnitList: action.goalTrackingUnitList,
  );  
}

