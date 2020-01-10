import 'package:redux/redux.dart';
import 'package:gomotive/auth/auth_actions.dart';
import 'package:gomotive/auth/auth_state.dart';

Reducer<AuthState> authReducer = combineReducers([
  new TypedReducer<AuthState, AuthLoginSuccess>(_userLoginSuccessReducer),
  new TypedReducer<AuthState, BusinessPartnerDetailsSuccessActionCreator>(_businessPartnerDetailsSuccessActionCreator),
  new TypedReducer<AuthState, SaveUserProfileActionCreator>(_saveUserProfileActionCreator),  
]);

AuthState _getCopy(AuthState state) {
  return new AuthState().copyWith(    
    user: state.user,
    businessPartner: state.businessPartner,
    roles: state.roles
  );
}


AuthState _userLoginSuccessReducer(AuthState state, AuthLoginSuccess action) {
  return _getCopy(state).copyWith(
    user: action.user,
    roles: action.roles
  );  
}

AuthState _businessPartnerDetailsSuccessActionCreator(AuthState state, BusinessPartnerDetailsSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    businessPartner: action.businessPartner,
  );  
}

AuthState _saveUserProfileActionCreator(AuthState state, SaveUserProfileActionCreator action) {
  return _getCopy(state).copyWith(    
    user: action.user,
  );  
}

