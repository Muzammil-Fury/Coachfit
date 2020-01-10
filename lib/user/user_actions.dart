
class FetchUserProfileDetailsActionCreator {
  final Map user;
  final List<Map> genderList;
  final List<Map> timezoneList;
  FetchUserProfileDetailsActionCreator(
    this.user,
    this.genderList,
    this.timezoneList
  );
}

class MovementMeterSettingsFetchActionCreator {
  final Map movementMeterSettings;
  MovementMeterSettingsFetchActionCreator(
    this.movementMeterSettings
  );
}

class UserMovementMeterWeeklyGraph {
  final List<Map> movementMeterWeeklyGraph;
  UserMovementMeterWeeklyGraph(
    this.movementMeterWeeklyGraph
  );
}

class ClearUserMovementMeterWeeklyGraph {
  ClearUserMovementMeterWeeklyGraph(
  );
}