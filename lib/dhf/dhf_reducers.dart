import 'package:redux/redux.dart';
import 'package:gomotive/dhf/dhf_actions.dart';
import 'package:gomotive/dhf/dhf_state.dart';

Reducer<DHFState> dhfReducer = combineReducers([
  new TypedReducer<DHFState, DHFAssessmentSuccessActionCreator>(
    _dHFAssessmentSuccessActionCreator
  ),  
]);

DHFState _getCopy(DHFState state) {
  return new DHFState().copyWith( 
    assessment: state.assessment
  );
}


DHFState _dHFAssessmentSuccessActionCreator(
  DHFState state,  
  DHFAssessmentSuccessActionCreator action
) {
  return _getCopy(state).copyWith(    
    assessment: action.assessment
  );  
}
