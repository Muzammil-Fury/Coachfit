import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class WorkoutState {

  final Map workoutObj;
  final Map supportingData;
  final Map workoutProgressionObj;
  final Map progressionSupportingData;
  final List<Map> workoutTemplateList;
  final Map workoutTemplatePaginateInfo;
  final Map workoutTemplateSearchParams;
  final Map workoutTemplateObj;
  final Map workoutTemplateObjSupportingData;
  final List<Map> engagementWorkouts;
  final Map workoutTemplateSearchParamsSupportingData;
  const WorkoutState({
    this.workoutObj,
    this.supportingData,
    this.workoutProgressionObj,
    this.progressionSupportingData,
    this.workoutTemplateList,
    this.workoutTemplatePaginateInfo,
    this.workoutTemplateSearchParams,
    this.workoutTemplateObj,
    this.workoutTemplateObjSupportingData,
    this.engagementWorkouts,
    this.workoutTemplateSearchParamsSupportingData,
  });

  WorkoutState copyWith({
    Map workoutObj,
    Map supportingData,
    Map workoutProgressionObj,
    Map progressionSupportingData,
    List<Map> workoutTemplateList,
    Map workoutTemplatePaginateInfo,
    Map workoutTemplateSearchParams,
    Map workoutTemplateObj,
    Map workoutTemplateObjSupportingData,
    List<Map> engagementWorkouts,
    Map workoutTemplateSearchParamsSupportingData,
  }) {
    return new WorkoutState(
      workoutObj: workoutObj ?? this.workoutObj,
      supportingData: supportingData ?? this.supportingData,
      workoutProgressionObj: workoutProgressionObj ?? this.workoutProgressionObj, 
      progressionSupportingData: progressionSupportingData ?? this.progressionSupportingData,
      workoutTemplateList: workoutTemplateList ?? this.workoutTemplateList,
      workoutTemplatePaginateInfo: workoutTemplatePaginateInfo ?? this.workoutTemplatePaginateInfo,
      workoutTemplateSearchParams: workoutTemplateSearchParams ?? this.workoutTemplateSearchParams,     
      workoutTemplateObj: workoutTemplateObj ?? this.workoutTemplateObj,
      workoutTemplateObjSupportingData: workoutTemplateObjSupportingData ?? this.workoutTemplateObjSupportingData,
      engagementWorkouts: engagementWorkouts ?? this.engagementWorkouts,
      workoutTemplateSearchParamsSupportingData: workoutTemplateSearchParamsSupportingData ?? this.workoutTemplateSearchParamsSupportingData,
    );
  }
}
