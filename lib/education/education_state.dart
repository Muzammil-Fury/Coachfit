import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class EducationState { 
  final List<Map> educationPartners;
  final List<Map> educationCategories;
  final List<Map> educationContent;

  const EducationState({    
    this.educationPartners,
    this.educationCategories,
    this.educationContent,
  });

  EducationState copyWith({    
    List<Map> educationPartners,
    List<Map> educationCategories,
    List<Map> educationContent,
  }) {
    return new EducationState(
      educationPartners: educationPartners ?? this.educationPartners,
      educationCategories: educationCategories ?? this.educationCategories,
      educationContent: educationContent ?? this.educationContent,
    );
  }
}
