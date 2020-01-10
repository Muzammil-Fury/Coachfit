class GamePlanTemplateListSuccessActionCreator {
  final List<Map> gameplanTemplateList;
  final Map gameplanTemplatePaginateInfo;
  GamePlanTemplateListSuccessActionCreator(
    this.gameplanTemplateList,
    this.gameplanTemplatePaginateInfo,
  );
}

class GamePlanTemplateListClearActionCreator {  
  GamePlanTemplateListClearActionCreator(    
  );
}

class GamePlanTemplateWorkoutListSuccessActionCreator { 
  final List<Map> workoutList; 
  GamePlanTemplateWorkoutListSuccessActionCreator(
    this.workoutList
  );
}

class GamePlanTemplateHabitListSuccessActionCreator { 
  final List<Map> habitList; 
  GamePlanTemplateHabitListSuccessActionCreator(
    this.habitList
  );
}

class GamePlanTemplateNutritionListSuccessActionCreator { 
  final List<Map> nutritionList; 
  GamePlanTemplateNutritionListSuccessActionCreator(
    this.nutritionList
  );
}

class GamePlanTemplateGuidanceListSuccessActionCreator { 
  final List<Map> guidanceList; 
  GamePlanTemplateGuidanceListSuccessActionCreator(
    this.guidanceList
  );
}
