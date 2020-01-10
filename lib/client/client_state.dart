import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ClientState {
  final List<Map> menuItems;
  final bool showMovementGraph;
  final Map currentWeekMovementMeters;
  final String homePageTitle;
  final bool hasViewedWelcomeVideo;
  final String welcomeVideoURL;  
  final String workoutImageUrl;
  final int associatedPracticeCount;
  final int programCount;
  final String programType;
  final int programId;
  final List<Map> newsList;
  final List<Map> programList;
  final Map programObj;
  final Map programAllWorkouts;
  final List<Map> workoutProgressionList;
  final Map selectedWorkoutProgression;
  final List<Map> practitioners;
  final int unreadMessageCount;
  final int unreadChatCount;
  final List<Map> activeEngagements;
  final int intakeFormCount;
  final List<Map> intakeForms;
  final List<Map> goalTrackingDetails;
  final List<Map> goalTrackingChartDetails;

  const ClientState({
    this.menuItems,
    this.showMovementGraph,
    this.currentWeekMovementMeters,
    this.homePageTitle,
    this.hasViewedWelcomeVideo,
    this.welcomeVideoURL,
    this.workoutImageUrl,
    this.associatedPracticeCount,
    this.programCount,
    this.programType,
    this.programId,
    this.newsList,
    this.programObj,
    this.programAllWorkouts,
    this.programList,
    this.workoutProgressionList,
    this.selectedWorkoutProgression,
    this.practitioners,
    this.unreadMessageCount,
    this.unreadChatCount,
    this.activeEngagements,
    this.intakeFormCount,
    this.intakeForms,
    this.goalTrackingDetails,
    this.goalTrackingChartDetails
  });

  ClientState copyWith({
    List<Map> menuItems,
    bool showMovementGraph,
    Map currentWeekMovementMeters,
    String homePageTitle,
    bool hasViewedWelcomeVideo,
    String welcomeVideoURL,
    String workoutImageUrl,
    int associatedPracticeCount,
    int programCount,
    String programType,
    int programId,
    List<Map> newsList,
    Map programObj,
    Map programAllWorkouts,
    List<Map> programList,
    List<Map> workoutProgressionList,
    Map selectedWorkoutProgression,
    List<Map> practitioners,
    int unreadMessageCount,
    int unreadChatCount,
    List<Map> activeEngagements,
    int intakeFormCount,
    List<Map> intakeForms,
    List<Map> goalTrackingDetails,
    List<Map> goalTrackingChartDetails,
  }) {
    return new ClientState(
      menuItems: menuItems ?? this.menuItems,
      showMovementGraph: showMovementGraph ?? this.showMovementGraph,
      currentWeekMovementMeters: currentWeekMovementMeters ?? this.currentWeekMovementMeters,
      homePageTitle: homePageTitle ?? this.homePageTitle,
      hasViewedWelcomeVideo: hasViewedWelcomeVideo ?? this.hasViewedWelcomeVideo,
      welcomeVideoURL: welcomeVideoURL ?? this.welcomeVideoURL,
      workoutImageUrl: workoutImageUrl ?? this.workoutImageUrl,
      programCount: programCount ?? this.programCount,
      associatedPracticeCount: associatedPracticeCount ?? this.associatedPracticeCount,
      programType: programType ?? this.programType,
      programId: programId ?? this.programId,
      newsList: newsList ?? this.newsList,
      programObj: programObj ?? this.programObj,
      programAllWorkouts: programAllWorkouts ?? this.programAllWorkouts,
      programList: programList ?? this.programList,
      workoutProgressionList: workoutProgressionList ?? this.workoutProgressionList,
      selectedWorkoutProgression: selectedWorkoutProgression ?? this.selectedWorkoutProgression,
      practitioners: practitioners ?? this.practitioners,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      unreadChatCount: unreadChatCount ?? this.unreadChatCount,
      activeEngagements: activeEngagements ?? this.activeEngagements,
      intakeFormCount: intakeFormCount ?? this.intakeFormCount,
      intakeForms: intakeForms ?? this.intakeForms,
      goalTrackingDetails: goalTrackingDetails ?? this.goalTrackingDetails,
      goalTrackingChartDetails: goalTrackingChartDetails ?? this.goalTrackingChartDetails,
    );
  }
}
