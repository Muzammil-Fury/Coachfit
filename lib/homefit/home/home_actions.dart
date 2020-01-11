class VerifyEmailSuccessActionCreator {
  final int emailExists;  
  VerifyEmailSuccessActionCreator(
    this.emailExists,    
  );
}

class ClearVerifyEmailActionCreator {
  ClearVerifyEmailActionCreator(    
  );
}


class DashboardDetailsSuccessActionCreator {
  final String welcomeVideoId;
  final String welcomeVideoURL;
  final String welcomeVideoThumbnailURL;
  final List<Map> availableSports;
  DashboardDetailsSuccessActionCreator(
    this.welcomeVideoId,
    this.welcomeVideoURL,
    this.welcomeVideoThumbnailURL,
    this.availableSports,
  );
}

class DashboardDetailsMovementMeterSuccessActionCreator {
  final Map currentWeekMovementMeter;
  DashboardDetailsMovementMeterSuccessActionCreator(
    this.currentWeekMovementMeter,
  );
}

class VerifyUserActionCreator {
  final Map user;
  final List<Map> plans;
  VerifyUserActionCreator(
    this.user,
    this.plans,
  );
}

class FamilyPlanMemberListSuccessActionCreator {
  final List<Map> familyPlanMemberList;
  FamilyPlanMemberListSuccessActionCreator(
    this.familyPlanMemberList
  );
}

class UpdateUserMovementMeterSettingsActionCreator {
  final Map movementMeterConfiguration;
  UpdateUserMovementMeterSettingsActionCreator(
    this.movementMeterConfiguration
  );
}

class DashboardNewWorkoutsSuccess {
  final List<Map> newWorkouts;
  DashboardNewWorkoutsSuccess(
    this.newWorkouts
  );
}

class DashboardFavoriteWorkoutsSuccess {
  final List<Map> favoriteWorkouts;
  final Map favoriteWorkoutsPaginateInfo;
  DashboardFavoriteWorkoutsSuccess(
    this.favoriteWorkouts,
    this.favoriteWorkoutsPaginateInfo,
  );
}


class HomeCleanup {
  HomeCleanup();
}
