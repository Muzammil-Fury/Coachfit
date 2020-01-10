import 'package:redux/redux.dart';
import 'package:gomotive/document/document_actions.dart';
import 'package:gomotive/document/document_state.dart';

Reducer<DocumentState> documentReducer = combineReducers([
  new TypedReducer<DocumentState, EngagementDocumentListSuccess>(_engagementDocumentList),  
  new TypedReducer<DocumentState, HealthDocumentListSuccess>(_healthDocumentList),  
]);

DocumentState _getCopy(DocumentState state) {
  return new DocumentState().copyWith(     
    engagementDocumentList: state.engagementDocumentList,
    documentList: state.documentList,        
  );
}

DocumentState _engagementDocumentList(DocumentState state,  EngagementDocumentListSuccess action) {
  return _getCopy(state).copyWith(
    engagementDocumentList: action.engagementDocumentList,    
  );  
}

DocumentState _healthDocumentList(DocumentState state,  HealthDocumentListSuccess action) {
  return _getCopy(state).copyWith(
    documentList: action.documentList,    
  );  
}