import 'package:redux/redux.dart';
import 'package:gomotive/workout/workout_actions.dart';
import 'package:gomotive/workout/workout_state.dart';

Reducer<WorkoutState> workoutReducer = combineReducers([
  new TypedReducer<WorkoutState, WorkoutGetSuccessActionCreator>(_workoutGetSuccessActionCreator),
  new TypedReducer<WorkoutState, WorkoutClearActionCreator>(_workoutClearActionCreator),
  new TypedReducer<WorkoutState, WorkoutProgressionGetSuccessActionCreator>(_workoutProgressionGetSuccessActionCreator),
  new TypedReducer<WorkoutState, AddExercisesToWorkoutProgressionActionCreator>(_addExercisesToWorkoutProgressionActionCreator),
  new TypedReducer<WorkoutState, WorkoutProgressionClearActionCreator>(_workoutProgressionClearActionCreator),
  new TypedReducer<WorkoutState, DeleteExerciseFromWorkoutProgressionActionCreator>(_deleteExerciseFromWorkoutProgressionActionCreator),
  new TypedReducer<WorkoutState, WorkoutTemplateListSuccessActionCreator>(_workoutTemplateListSuccessActionCreator),
  new TypedReducer<WorkoutState, WorkoutTemplateListClearActionCreator>(_workoutTemplateListClearActionCreator),
  new TypedReducer<WorkoutState, ReplaceWorkoutTemplateObjectActionCreator>(_replaceWorkoutTemplateObjectActionCreator),
  new TypedReducer<WorkoutState, WorkoutTemplateGetSuccessActionCreator>(_workoutTemplateGetSuccessActionCreator),
  new TypedReducer<WorkoutState, WorkoutTemplateClearActionCreator>(_workoutTemplateClearActionCreator),
  new TypedReducer<WorkoutState, WorkoutScheduleUpdateActionCreator>(_workoutScheduleUpdateActionCreator),
  new TypedReducer<WorkoutState, EngagementWorkoutsSuccessActionCreator>(_engagementWorkoutsSuccessActionCreator),
  new TypedReducer<WorkoutState, SearchParamsSuccessActionCreator>(_searchParamsSuccessActionCreator),        
]);

WorkoutState _getCopy(WorkoutState state) {
  return new WorkoutState().copyWith( 
    workoutObj: state.workoutObj,
    supportingData: state.supportingData,
    workoutProgressionObj: state.workoutProgressionObj,
    progressionSupportingData: state.progressionSupportingData,
    workoutTemplateList: state.workoutTemplateList,
    workoutTemplatePaginateInfo: state.workoutTemplatePaginateInfo,
    workoutTemplateSearchParams: state.workoutTemplateSearchParams,
    workoutTemplateObj: state.workoutTemplateObj,
    workoutTemplateObjSupportingData: state.workoutTemplateObjSupportingData,
    engagementWorkouts: state.engagementWorkouts,
    workoutTemplateSearchParamsSupportingData: state.workoutTemplateSearchParamsSupportingData,
  );
}


WorkoutState _workoutGetSuccessActionCreator(WorkoutState state,  WorkoutGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutObj: action.workoutObj,
    supportingData: action.supportingData
  );  
}


WorkoutState _workoutClearActionCreator(WorkoutState state,  WorkoutClearActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutObj: new Map(),
    supportingData: new Map(),
    workoutProgressionObj: new Map(),
    progressionSupportingData: new Map()
  );  
}

WorkoutState _workoutProgressionGetSuccessActionCreator(WorkoutState state,  WorkoutProgressionGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutProgressionObj: action.workoutProgressionObj,
    progressionSupportingData: action.progressionSupportingData
  );  
}

WorkoutState _addExercisesToWorkoutProgressionActionCreator(WorkoutState state,  AddExercisesToWorkoutProgressionActionCreator action) {
  WorkoutState newState = _getCopy(state).copyWith();
  if(newState.workoutProgressionObj["exercises"] == null) {
    newState.workoutProgressionObj["exercises"] = action.exercises;
  } else {
    newState.workoutProgressionObj["exercises"] = []..addAll(newState.workoutProgressionObj["exercises"])..addAll(action.exercises);
  }
  return newState;
}

WorkoutState _workoutProgressionClearActionCreator(WorkoutState state,  WorkoutProgressionClearActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutProgressionObj: new Map(),
    progressionSupportingData: new Map()
  );  
}

WorkoutState _deleteExerciseFromWorkoutProgressionActionCreator(WorkoutState state,  DeleteExerciseFromWorkoutProgressionActionCreator action) {
  WorkoutState newState = _getCopy(state).copyWith();  
  newState.workoutProgressionObj["exercises"].removeAt(action.exerciseIndex);
  return newState;
}

WorkoutState _workoutTemplateListSuccessActionCreator(WorkoutState state,  WorkoutTemplateListSuccessActionCreator action) {
  if(action.workoutTemplatePaginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      workoutTemplateList: action.workoutTemplateList,
      workoutTemplatePaginateInfo: action.workoutTemplatePaginateInfo,
      workoutTemplateSearchParams: action.workoutTemplateSearchParams,
    );  
  } else {
    return _getCopy(state).copyWith(
      workoutTemplateList: []..addAll(state.workoutTemplateList)..addAll(action.workoutTemplateList),
      workoutTemplatePaginateInfo: action.workoutTemplatePaginateInfo,
      workoutTemplateSearchParams: action.workoutTemplateSearchParams,
    );  
  }
}

WorkoutState _workoutTemplateListClearActionCreator(WorkoutState state,  WorkoutTemplateListClearActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutTemplateList: new List<Map>()
  );  
}



WorkoutState _replaceWorkoutTemplateObjectActionCreator(WorkoutState state,  ReplaceWorkoutTemplateObjectActionCreator action) {
  WorkoutState newState = _getCopy(state).copyWith();
  newState.workoutTemplateList[action.selectedIndex] = action.workoutTemplateObj;
  return newState;
}

WorkoutState _workoutTemplateGetSuccessActionCreator(WorkoutState state,  WorkoutTemplateGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutTemplateObj: action.workoutTemplateObj,
    workoutTemplateObjSupportingData: action.workoutTemplateSupportingData,    
  );  
}


WorkoutState _workoutTemplateClearActionCreator(WorkoutState state,  WorkoutTemplateClearActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutTemplateObj: new Map(),
    workoutTemplateObjSupportingData: new Map(),    
  );  
}

WorkoutState _workoutScheduleUpdateActionCreator(WorkoutState state,  WorkoutScheduleUpdateActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutObj: action.workout,
    workoutProgressionObj: action.workoutProgression,
  );  
}

WorkoutState _engagementWorkoutsSuccessActionCreator(WorkoutState state,  EngagementWorkoutsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    engagementWorkouts: action.engagementWorkouts
  );  
}

WorkoutState _searchParamsSuccessActionCreator(WorkoutState state,  SearchParamsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    workoutTemplateSearchParams: action.workoutTemplateSearchParams,
    workoutTemplateSearchParamsSupportingData: action.workoutTemplateSearchParamsSupportingData,
  );
}

