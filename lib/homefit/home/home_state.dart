import 'package:meta/meta.dart';

@immutable
class HomeFitHomeState {

  final int userEmailExists;
  final String welcomeVideoId;
  final String welcomeVideoURL;
  final String welcomeVideoThumbnailURL;
  final Map user;
  final Map currentWeekMovementPoints;
  final List<Map> familyPlanMemberList;
  final Map movementMeterConfiguration;
  final List<Map> availableSports;
  final List<Map> plans;
  final List<Map> newWorkouts;
  final List<Map> favoriteWorkouts;
  final Map favoriteWorkoutsPaginateInfo;

  const HomeFitHomeState({     //Only name need to be changed
    this.userEmailExists,
    this.welcomeVideoId,
    this.welcomeVideoURL,
    this.welcomeVideoThumbnailURL,
    this.user,
    this.currentWeekMovementPoints,
    this.familyPlanMemberList,
    this.movementMeterConfiguration,
    this.availableSports,
    this.plans,
    this.newWorkouts,
    this.favoriteWorkouts,
    this.favoriteWorkoutsPaginateInfo,
  });

  HomeFitHomeState copyWith({
    int userEmailExists,
    String welcomeVideoId,
    String welcomeVideoURL,
    String welcomeVideoThumbnailURL,
    Map user,
    Map currentWeekMovementPoints,
    List<Map> familyPlanMemberList,
    Map movementMeterConfiguration,
    List<Map> availableSports,
    List<Map> plans,
    List<Map> newWorkouts,
    List<Map> favoriteWorkouts,
    Map favoriteWorkoutsPaginateInfo,
  }) {
    return new HomeFitHomeState(
      userEmailExists: userEmailExists ?? this.userEmailExists,
      welcomeVideoId: welcomeVideoId ?? this.welcomeVideoId,
      welcomeVideoURL: welcomeVideoURL ?? this.welcomeVideoURL,
      welcomeVideoThumbnailURL: welcomeVideoThumbnailURL ?? this.welcomeVideoThumbnailURL,
      user: user ?? this.user,
      currentWeekMovementPoints: currentWeekMovementPoints ?? this.currentWeekMovementPoints,
      familyPlanMemberList: familyPlanMemberList ?? this.familyPlanMemberList,
      movementMeterConfiguration: movementMeterConfiguration ?? this.movementMeterConfiguration,
      availableSports: availableSports ?? this.availableSports,
      plans: plans ?? this.plans,
      newWorkouts: newWorkouts ?? this.newWorkouts,
      favoriteWorkouts: favoriteWorkouts ?? this.favoriteWorkouts,
      favoriteWorkoutsPaginateInfo: favoriteWorkoutsPaginateInfo ?? this.favoriteWorkoutsPaginateInfo,
    );
  }
}
