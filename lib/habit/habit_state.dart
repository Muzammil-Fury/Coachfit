import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class HabitState {  
  final List<Map> habitTemplateList;
  final Map habitObj;
  final List<Map> habitFrequencySchedules;
  final List<Map> habitFrequencyDurationType;  
  
  const HabitState({
    this.habitTemplateList,
    this.habitObj,
    this.habitFrequencySchedules,
    this.habitFrequencyDurationType,  
  });

  HabitState copyWith({    
    List<Map> habitTemplateList,
    Map habitObj,
    List<Map> habitFrequencySchedules,
    List<Map> habitFrequencyDurationType,    
  }) {
    return new HabitState(      
      habitTemplateList: habitTemplateList ?? this.habitTemplateList,
      habitObj: habitObj ?? this.habitObj,
      habitFrequencySchedules: habitFrequencySchedules ?? this.habitFrequencySchedules,
      habitFrequencyDurationType: habitFrequencyDurationType ?? this.habitFrequencyDurationType,      
    );
  }
}
