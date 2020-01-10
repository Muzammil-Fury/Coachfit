import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class IntakeState {  
  final List<Map> eformList;

  const IntakeState({    
    this.eformList,
  });

  IntakeState copyWith({    
    List<Map> eformList,
  }) {
    return new IntakeState(      
      eformList: eformList ?? this.eformList,
    );
  }
}
