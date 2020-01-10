import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class GameplanState {
  
  final List<Map> gameplanTemplateList;
  final Map gameplanPaginateInfo;
  final List<Map> gameplanTemplateWorkoutList;
  final List<Map> gameplanTemplateHabitList;
  final List<Map> gameplanTemplateNutritionDocumentList;
  final List<Map> gameplanTemplateGuidanceDocumentList;
  
  const GameplanState({
    this.gameplanTemplateList,
    this.gameplanPaginateInfo,
    this.gameplanTemplateWorkoutList,
    this.gameplanTemplateHabitList,
    this.gameplanTemplateNutritionDocumentList,
    this.gameplanTemplateGuidanceDocumentList,
  });

  GameplanState copyWith({
    List<Map> gameplanTemplateList,
    Map gameplanPaginateInfo,    
    final List<Map> gameplanTemplateWorkoutList,
    List<Map> gameplanTemplateHabitList,
    List<Map> gameplanTemplateNutritionDocumentList,
    List<Map> gameplanTemplateGuidanceDocumentList,
  }) {
    return new GameplanState(
      gameplanTemplateList: gameplanTemplateList ?? this.gameplanTemplateList,
      gameplanPaginateInfo: gameplanPaginateInfo ?? this.gameplanPaginateInfo,   
      gameplanTemplateWorkoutList: gameplanTemplateWorkoutList ?? this.gameplanTemplateWorkoutList,
      gameplanTemplateHabitList: gameplanTemplateHabitList ?? this.gameplanTemplateHabitList,
      gameplanTemplateNutritionDocumentList: gameplanTemplateNutritionDocumentList ?? this.gameplanTemplateNutritionDocumentList,
      gameplanTemplateGuidanceDocumentList: gameplanTemplateGuidanceDocumentList ?? this.gameplanTemplateGuidanceDocumentList,
    );
  }
}
