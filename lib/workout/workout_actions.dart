
class WorkoutGetSuccessActionCreator {
  final Map workoutObj;
  final Map supportingData;
  WorkoutGetSuccessActionCreator(
    this.workoutObj,
    this.supportingData
  );
}

class WorkoutClearActionCreator {
  WorkoutClearActionCreator();
}

class WorkoutProgressionGetSuccessActionCreator {
  final Map workoutProgressionObj;
  final Map progressionSupportingData;
  WorkoutProgressionGetSuccessActionCreator(
    this.workoutProgressionObj,
    this.progressionSupportingData
  );
}

class WorkoutProgressionClearActionCreator {
  WorkoutProgressionClearActionCreator();
}


class AddExercisesToWorkoutProgressionActionCreator {
  final List<Map> exercises;
  AddExercisesToWorkoutProgressionActionCreator(
    this.exercises
  );
}

class DeleteExerciseFromWorkoutProgressionActionCreator {
  final int exerciseIndex;
  DeleteExerciseFromWorkoutProgressionActionCreator(
    this.exerciseIndex,
  );
}

class WorkoutTemplateListSuccessActionCreator {
  final List<Map> workoutTemplateList;
  final Map workoutTemplatePaginateInfo;
  final Map workoutTemplateSearchParams;
  WorkoutTemplateListSuccessActionCreator(
    this.workoutTemplateList,
    this.workoutTemplatePaginateInfo,
    this.workoutTemplateSearchParams,
  );
}

class WorkoutTemplateListClearActionCreator {
  WorkoutTemplateListClearActionCreator();
}



class ReplaceWorkoutTemplateObjectActionCreator {  
  final Map workoutTemplateObj;
  final int selectedIndex;
  ReplaceWorkoutTemplateObjectActionCreator(
    this.workoutTemplateObj,
    this.selectedIndex
  );
}


class WorkoutTemplateGetSuccessActionCreator {
  final Map workoutTemplateObj;  
  final Map workoutTemplateSupportingData;
  WorkoutTemplateGetSuccessActionCreator(
    this.workoutTemplateObj,
    this.workoutTemplateSupportingData,
  );
}

class WorkoutTemplateClearActionCreator {
  WorkoutTemplateClearActionCreator();
}

class WorkoutScheduleUpdateActionCreator{
  final Map workout;
  final Map workoutProgression;
  WorkoutScheduleUpdateActionCreator(
    this.workout,
    this.workoutProgression
  );
}

class EngagementWorkoutsSuccessActionCreator {
  final List<Map> engagementWorkouts;
  EngagementWorkoutsSuccessActionCreator(
    this.engagementWorkouts
  );
}

class SearchParamsSuccessActionCreator {  
  final Map workoutTemplateSearchParams;
  final Map workoutTemplateSearchParamsSupportingData;
  SearchParamsSuccessActionCreator(
    this.workoutTemplateSearchParams,
    this.workoutTemplateSearchParamsSupportingData,
  );
}
