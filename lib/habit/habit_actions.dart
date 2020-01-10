
class HabitTemplateListSuccess {
  final List<Map> habitTemplateList;
  HabitTemplateListSuccess(
    this.habitTemplateList,
  );
}

class EngagementHabitGetSuccess {
  final Map habitObj;
  final List<Map> habitFrequencySchedules;
  final List<Map> habitFrequencyDurationType;
  EngagementHabitGetSuccess(
    this.habitObj,
    this.habitFrequencySchedules,
    this.habitFrequencyDurationType,
  );
}

class ClearEngagementHabitActionCreator {
  ClearEngagementHabitActionCreator(
  );
}
