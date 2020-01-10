import 'package:redux/redux.dart';
import 'package:gomotive/intake/intake_actions.dart';
import 'package:gomotive/intake/intake_state.dart';

Reducer<IntakeState> intakeReducer = combineReducers([  
  new TypedReducer<IntakeState, EFormListSuccessActionCreator>(_eFormListSuccessActionCreator),          
]);

IntakeState _getCopy(IntakeState state) {
  return new IntakeState().copyWith( 
    eformList: state.eformList
  );
}



IntakeState _eFormListSuccessActionCreator(IntakeState state,  EFormListSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    eformList: action.eformList,
  );  
}