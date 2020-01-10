import 'package:redux/redux.dart';
import 'package:gomotive/exercise/exercise_actions.dart';
import 'package:gomotive/exercise/exercise_state.dart';

Reducer<ExerciseState> exerciseReducer = combineReducers([
  new TypedReducer<ExerciseState, ExerciseListSuccessActionCreator>(_exerciseListSuccessActionCreator),    
  new TypedReducer<ExerciseState, ClearExerciseListActionCreator>(_clearExerciseListActionCreator),    
  new TypedReducer<ExerciseState, ReplaceExerciseObjectActionCreator>(_replaceExerciseObjectActionCreator),    
  new TypedReducer<ExerciseState, AddToWorkoutCartActionCreator>(_addToWorkoutCartActionCreator),    
  new TypedReducer<ExerciseState, RemoveFromWorkoutCartActionCreator>(_removeFromWorkoutCartActionCreator),    
  new TypedReducer<ExerciseState, ClearWorkoutCartActionCreator>(_clearWorkoutCartActionCreator),
  new TypedReducer<ExerciseState, SearchParamsSuccessActionCreator>(_searchParamsSuccessActionCreator),        
]);

ExerciseState _getCopy(ExerciseState state) {
  return new ExerciseState().copyWith( 
    exerciseList: state.exerciseList,
    paginateInfo: state.paginateInfo, 
    searchParams: state.searchParams,
    selectedIndex: state.selectedIndex,
    workoutExercises: state.workoutExercises,
    workoutExerciseIdList: state.workoutExerciseIdList,
    searchParamsFilterData: state.searchParamsFilterData,
  );
}


ExerciseState _exerciseListSuccessActionCreator(ExerciseState state,  ExerciseListSuccessActionCreator action) {
  if(action.paginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      exerciseList: action.exerciseList,
      paginateInfo: action.paginateInfo,
      searchParams: action.searchParams
    );  
  } else {
    return _getCopy(state).copyWith(
      exerciseList: []..addAll(state.exerciseList)..addAll(action.exerciseList),
      paginateInfo: action.paginateInfo,    
      searchParams: action.searchParams        
    );  
  }
}

ExerciseState _clearExerciseListActionCreator(ExerciseState state,  ClearExerciseListActionCreator action) {
  return _getCopy(state).copyWith(
    exerciseList: new List<Map>(),
    paginateInfo: new Map(),
    searchParams: new Map(),
    workoutExercises: new List<Map>(),
    workoutExerciseIdList: new List<int>(),
  );    
}

ExerciseState _replaceExerciseObjectActionCreator(ExerciseState state,  ReplaceExerciseObjectActionCreator action) {
  ExerciseState newState = _getCopy(state).copyWith();
  newState.exerciseList[action.selectedIndex] = action.exerciseObj;
  return newState;
}

ExerciseState _addToWorkoutCartActionCreator(ExerciseState state,  AddToWorkoutCartActionCreator action) {
  action.exerciseObj["exercise_id"] = action.exerciseObj["id"];
  action.exerciseObj["id"] = null;
  if(action.exerciseObj["usage_type"] == "to_workout") {
    action.exerciseObj["sets"] = 1;
    action.exerciseObj["reps"] = 10;
    action.exerciseObj["distance"] = 1;
    action.exerciseObj["distance_unit"] = 1;
    action.exerciseObj["duration"] = 1;
    action.exerciseObj["duration_unit"] = 1;
  }
  if(state.workoutExercises == null) {
    action.exerciseObj["order"] = 0;
  } else {
    action.exerciseObj["order"] = state.workoutExercises.length;
  }
  if(state.workoutExercises == null) {
    return _getCopy(state).copyWith(
      workoutExercises: []..add(action.exerciseObj),
      workoutExerciseIdList: []..add(action.exerciseObj["id"]),
    );
  } else {
    return _getCopy(state).copyWith(
      workoutExercises: []..addAll(state.workoutExercises)..add(action.exerciseObj),
      workoutExerciseIdList: []..addAll(state.workoutExerciseIdList)..add(action.exerciseObj["id"]),
    );
  }
}

ExerciseState _removeFromWorkoutCartActionCreator(ExerciseState state,  RemoveFromWorkoutCartActionCreator action) {
  ExerciseState newState = _getCopy(state).copyWith();
  for(int i=0; i<newState.workoutExerciseIdList.length; i++) {
    if(newState.workoutExerciseIdList.elementAt(i) == action.exerciseObj["id"]) {
      newState.workoutExerciseIdList.removeAt(i);
      newState.workoutExercises.removeAt(i);
    }
  }
  return newState;
}


ExerciseState _clearWorkoutCartActionCreator(ExerciseState state,  ClearWorkoutCartActionCreator action) {
  return _getCopy(state).copyWith(
    workoutExercises: new List<Map>(),
    workoutExerciseIdList: new List<int>(),
  );
}


ExerciseState _searchParamsSuccessActionCreator(ExerciseState state,  SearchParamsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    searchParams: action.searchParams,
    searchParamsFilterData: action.searchParamsFilterData,
  );
}


