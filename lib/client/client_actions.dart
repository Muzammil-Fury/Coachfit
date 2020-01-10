class HomePageDetailsSuccessActionCreator {
  final Map responseData;
  HomePageDetailsSuccessActionCreator(
    this.responseData
  );
}

class ProgramListSuccessActionCreator {
  final Map responseData;
  ProgramListSuccessActionCreator(
    this.responseData
  );
}

class ProgramObjectSuccessActionCreator {
  final Map responseData;
  ProgramObjectSuccessActionCreator(
    this.responseData
  );
}

class ProgramObjectClearActionCreator {
  ProgramObjectClearActionCreator();
}

class AllWorkoutListSuccessActionCreator {
  final Map responseData;
  AllWorkoutListSuccessActionCreator(
    this.responseData
  );
}

class WorkoutProgressionListSuccessActionCreator {
  final List<Map> workoutProgressionList;
  WorkoutProgressionListSuccessActionCreator(
    this.workoutProgressionList
  );
}

class AllWorkoutListClearActionCreator {
  AllWorkoutListClearActionCreator();
}

class SetSelectedWorkoutProgressionActionCreator {
  final Map selectedWorkoutProgression;
  SetSelectedWorkoutProgressionActionCreator(
    this.selectedWorkoutProgression
  );
}

class WorkoutProgressionClearActionCreator {
  WorkoutProgressionClearActionCreator(
  );
}

class ClientActiveEngagementGetSuccessActionCreator {
  final List<Map> engagements;
  ClientActiveEngagementGetSuccessActionCreator(
    this.engagements
  );
}

class IntakeFormListSuccessActionCreator {
  final List<Map> intakeForms;
  IntakeFormListSuccessActionCreator(
    this.intakeForms
  );
}

class UpdateWeeklyMovementMeterActionCreator {
  final Map weeklyMovementMeter;
  UpdateWeeklyMovementMeterActionCreator(
    this.weeklyMovementMeter
  );
}

class ProgramSuccessActionCreator {
  final Map programObj;
  ProgramSuccessActionCreator(
    this.programObj
  );
}

class GoalTrackingDetailsSuccessActionCreator {
  final List<Map> goalTrackingDetails;
  GoalTrackingDetailsSuccessActionCreator(
    this.goalTrackingDetails
  );
}

class GoalTrackingChartDetailsSuccessActionCreator {
  final List<Map> goalTrackingChartDetails;
  GoalTrackingChartDetailsSuccessActionCreator(
    this.goalTrackingChartDetails
  );
}

class ClearGoalTrackingDetailsActionCreator{
  ClearGoalTrackingDetailsActionCreator();
}

class ClearGoalTrackingChartDetailsActionCreator {
  ClearGoalTrackingChartDetailsActionCreator();
}
