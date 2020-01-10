import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class GoalState {  
  final List<Map> goalTemplateList;
  final List<Map> goalTrackingUnitList;

  const GoalState({    
    this.goalTemplateList,
    this.goalTrackingUnitList,
  });

  GoalState copyWith({    
    List<Map> goalTemplateList,
    List<Map> goalTrackingUnitList,
  }) {
    return new GoalState(      
      goalTemplateList: goalTemplateList ?? this.goalTemplateList,
      goalTrackingUnitList: goalTrackingUnitList ?? this.goalTrackingUnitList,
    );
  }
}
