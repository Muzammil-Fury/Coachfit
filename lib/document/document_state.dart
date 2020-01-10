import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class DocumentState {
  final List<Map> documentList;  
  final List<Map> engagementDocumentList;
  
  const DocumentState({
    this.documentList,   
    this.engagementDocumentList
  });

  DocumentState copyWith({
    List<Map> documentList, 
    List<Map> engagementDocumentList,   
  }) {
    return new DocumentState(
      documentList: documentList ?? this.documentList,  
      engagementDocumentList: engagementDocumentList ?? this.engagementDocumentList, 
    );
  }
}
