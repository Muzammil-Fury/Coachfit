import 'package:redux/redux.dart';
import 'package:gomotive/education/education_actions.dart';
import 'package:gomotive/education/education_state.dart';

Reducer<EducationState> educationReducer = combineReducers([
  new TypedReducer<EducationState, EducationPartnersSuccessActionCreator>(
    _educationPartnersSuccessActionCreator
  ),
  new TypedReducer<EducationState, EducationPartnerCategoriesSuccessActionCreator>(
    _educationPartnerCategoriesSuccessActionCreator
  ),  
  new TypedReducer<EducationState, EducationPartnerContentSuccessActionCreator>(
    _educationPartnerContentSuccessActionCreator
  ),
  new TypedReducer<EducationState, ClearEducationPartnerContentActionCreator>(
    _clearEducationPartnerContentActionCreator
  ),
  new TypedReducer<EducationState, ClearEducationPartnerCategoryActionCreator>(
    _clearEducationPartnerCategoryActionCreator
  ),
  new TypedReducer<EducationState, ClearEducationPartnerActionCreator>(
    _clearEducationPartnerActionCreator
  ),
]);

EducationState _getCopy(EducationState state) {
  return new EducationState().copyWith( 
    educationPartners: state.educationPartners,
    educationCategories: state.educationCategories,
    educationContent: state.educationContent,
  );
}


EducationState _educationPartnersSuccessActionCreator(
  EducationState state,  
  EducationPartnersSuccessActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationPartners: action.partners
  );  
}

EducationState _educationPartnerCategoriesSuccessActionCreator(
  EducationState state,  
  EducationPartnerCategoriesSuccessActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationCategories: action.educationPartnerCategories
  );  
}


EducationState _educationPartnerContentSuccessActionCreator(
  EducationState state,  
  EducationPartnerContentSuccessActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationContent: action.educationContent
  );  
}


EducationState _clearEducationPartnerContentActionCreator(
  EducationState state,  
  ClearEducationPartnerContentActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationContent: new List<Map>()
  );  
}

EducationState _clearEducationPartnerCategoryActionCreator(
  EducationState state,  
  ClearEducationPartnerCategoryActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationCategories: new List<Map>()
  );  
}


EducationState _clearEducationPartnerActionCreator(
  EducationState state,  
  ClearEducationPartnerActionCreator action
) {
  return _getCopy(state).copyWith(    
    educationPartners: new List<Map>()
  );  
}