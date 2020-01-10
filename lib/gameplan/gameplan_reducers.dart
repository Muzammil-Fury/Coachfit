import 'package:redux/redux.dart';
import 'package:gomotive/gameplan/gameplan_actions.dart';
import 'package:gomotive/gameplan/gameplan_state.dart';

Reducer<GameplanState> gameplanReducer = combineReducers([  
  new TypedReducer<GameplanState, GamePlanTemplateListSuccessActionCreator>(
    _gameplanTemplateListSuccessActionCreator
  ),
  new TypedReducer<GameplanState, GamePlanTemplateListClearActionCreator>(
    _gameplanTemplateListClearActionCreator
  ),
  new TypedReducer<GameplanState, GamePlanTemplateWorkoutListSuccessActionCreator>(
    _gamePlanTemplateWorkoutListSuccessActionCreator
  ),
  new TypedReducer<GameplanState, GamePlanTemplateHabitListSuccessActionCreator>(
    _gamePlanTemplateHabitListSuccessActionCreator
  ),  
  new TypedReducer<GameplanState, GamePlanTemplateNutritionListSuccessActionCreator>(
    _gamePlanTemplateNutritionListSuccessActionCreator
  ),  
  new TypedReducer<GameplanState, GamePlanTemplateGuidanceListSuccessActionCreator>(
    _gamePlanTemplateGuidanceListSuccessActionCreator
  ),  
]);

GameplanState _getCopy(GameplanState state) {
  return new GameplanState().copyWith( 
    gameplanTemplateList: state.gameplanTemplateList,
    gameplanPaginateInfo: state.gameplanPaginateInfo,
    gameplanTemplateWorkoutList: state.gameplanTemplateWorkoutList,
    gameplanTemplateHabitList: state.gameplanTemplateHabitList,
    gameplanTemplateNutritionDocumentList: state.gameplanTemplateNutritionDocumentList,
    gameplanTemplateGuidanceDocumentList: state.gameplanTemplateGuidanceDocumentList,
  );
}

GameplanState _gameplanTemplateListSuccessActionCreator(GameplanState state,  GamePlanTemplateListSuccessActionCreator action) {
  if(action.gameplanTemplatePaginateInfo["page"] == 0) {
    return _getCopy(state).copyWith(
      gameplanTemplateList: action.gameplanTemplateList,
      gameplanPaginateInfo: action.gameplanTemplatePaginateInfo,      
    );  
  } else {
    return _getCopy(state).copyWith(
      gameplanTemplateList: []..addAll(state.gameplanTemplateList)..addAll(action.gameplanTemplateList),
      gameplanPaginateInfo: action.gameplanTemplatePaginateInfo,
    );  
  }
}

GameplanState _gameplanTemplateListClearActionCreator(GameplanState state,  GamePlanTemplateListClearActionCreator action) {
  return _getCopy(state).copyWith(    
    gameplanTemplateList: new List<Map>(),
    gameplanPaginateInfo: new Map(),
  );  
}

GameplanState _gamePlanTemplateWorkoutListSuccessActionCreator(
  GameplanState state,  GamePlanTemplateWorkoutListSuccessActionCreator action
) {
  for(int i=0;i<action.workoutList.length; i++) {
    action.workoutList[i]["selected_value"] = true;
  }
  return _getCopy(state).copyWith(    
    gameplanTemplateWorkoutList: action.workoutList
  );  
}


GameplanState _gamePlanTemplateHabitListSuccessActionCreator(
  GameplanState state,  GamePlanTemplateHabitListSuccessActionCreator action
) {
  for(int i=0;i<action.habitList.length; i++) {
    action.habitList[i]["selected_value"] = true;
  }
  return _getCopy(state).copyWith(    
    gameplanTemplateHabitList: action.habitList
  );  
}

GameplanState _gamePlanTemplateNutritionListSuccessActionCreator(
  GameplanState state,  GamePlanTemplateNutritionListSuccessActionCreator action
) {
  for(int i=0;i<action.nutritionList.length; i++) {
    action.nutritionList[i]["selected_value"] = true;
  }
  return _getCopy(state).copyWith(    
    gameplanTemplateNutritionDocumentList: action.nutritionList
  );  
}

GameplanState _gamePlanTemplateGuidanceListSuccessActionCreator(
  GameplanState state,  GamePlanTemplateGuidanceListSuccessActionCreator action
) {
  for(int i=0;i<action.guidanceList.length; i++) {
    action.guidanceList[i]["selected_value"] = true;
  }
  return _getCopy(state).copyWith(    
    gameplanTemplateGuidanceDocumentList: action.guidanceList
  );  
}
