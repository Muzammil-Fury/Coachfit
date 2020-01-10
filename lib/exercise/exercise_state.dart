import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ExerciseState {

  final List<Map> exerciseList;
  final Map paginateInfo;
  final Map searchParams;
  final int selectedIndex;
  final List<Map> workoutExercises;
  final List<int> workoutExerciseIdList;
  final Map searchParamsFilterData;
  
  const ExerciseState({
    this.exerciseList,
    this.paginateInfo,
    this.searchParams,
    this.selectedIndex,
    this.workoutExercises,
    this.workoutExerciseIdList,
    this.searchParamsFilterData,
  });

  ExerciseState copyWith({
    List<Map> exerciseList,
    Map paginateInfo,    
    Map searchParams,
    int selectedIndex,
    List<Map> workoutExercises,
    List<int> workoutExerciseIdList,
    Map searchParamsFilterData,
  }) {
    return new ExerciseState(
      exerciseList: exerciseList ?? this.exerciseList,
      paginateInfo: paginateInfo ?? this.paginateInfo,
      searchParams: searchParams ?? this.searchParams,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      workoutExercises: workoutExercises ?? this.workoutExercises,
      workoutExerciseIdList: workoutExerciseIdList ?? this.workoutExerciseIdList,
      searchParamsFilterData: searchParamsFilterData ?? this.searchParamsFilterData,
    );
  }
}
