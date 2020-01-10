
class ExerciseListSuccessActionCreator {
  final List<Map> exerciseList;
  final Map paginateInfo;
  final Map searchParams;
  ExerciseListSuccessActionCreator(
    this.exerciseList,
    this.paginateInfo,
    this.searchParams
  );
}

class ClearExerciseListActionCreator{
  ClearExerciseListActionCreator();
}

class ReplaceExerciseObjectActionCreator {  
  final Map exerciseObj;
  final int selectedIndex;
  ReplaceExerciseObjectActionCreator(
    this.exerciseObj,
    this.selectedIndex
  );
}

class AddToWorkoutCartActionCreator {  
  final Map exerciseObj;
  AddToWorkoutCartActionCreator(
    this.exerciseObj,
  );
}

class RemoveFromWorkoutCartActionCreator {  
  final Map exerciseObj;
  RemoveFromWorkoutCartActionCreator(
    this.exerciseObj,
  );
}

class ClearWorkoutCartActionCreator {
  ClearWorkoutCartActionCreator(
  );
}

class SearchParamsSuccessActionCreator {  
  final Map searchParams;
  final Map searchParamsFilterData;
  SearchParamsSuccessActionCreator(
    this.searchParams,
    this.searchParamsFilterData,
  );
}

