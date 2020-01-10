import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class DHFState { 
  final List<Map> assessment;
  
  const DHFState({    
    this.assessment,    
  });

  DHFState copyWith({    
    List<Map> assessment,    
  }) {
    return new DHFState(
      assessment: assessment ?? this.assessment,      
    );
  }
}
