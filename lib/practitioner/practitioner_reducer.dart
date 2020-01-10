import 'package:redux/redux.dart';
import 'package:gomotive/practitioner/practitioner_actions.dart';
import 'package:gomotive/practitioner/practitioner_state.dart';
import 'package:gomotive/utils/utils.dart';

Reducer<PractitionerState> practitionerReducer = combineReducers([
  new TypedReducer<PractitionerState, HomePageDetailsSuccessActionCreator>(_homePageDetailsSuccessActionCreator),
  new TypedReducer<PractitionerState, PractitionerClientsSuccessActionCreator>(_practitionerClientsSuccessActionCreator),        
  new TypedReducer<PractitionerState, PractitionerClientHomePageSuccessActionCreator>(_practitionerClientHomePageSuccessActionCreator),        
  new TypedReducer<PractitionerState, ClearPractitionerClientHomeActionCreator>(_clearPractitionerClientHomeActionCreator),        
  new TypedReducer<PractitionerState, PractitionerGetEngagementSuccessActionCreator>(_practitionerGetEngagementSuccessActionCreator),
  new TypedReducer<PractitionerState, PractitionerEngagementClearActionCreator>(_practitionerEngagementClearActionCreator),
  new TypedReducer<PractitionerState, PractitionerClientFilterSuccessActionCreator>(_practitionerClientFilterSuccessActionCreator),
  new TypedReducer<PractitionerState, PractitionerClientToggleVisibilitySuccessActionCreator>(_practitionerClientToggleVisibilitySuccessActionCreator),
]);

PractitionerState _getCopy(PractitionerState state) {
  return new PractitionerState().copyWith( 
    unreadMessageCount: state.unreadMessageCount,
    unreadChats: state.unreadChats,
    alertCount: state.alertCount,
    menuItems: state.menuItems, 
    clients: state.clients,
    paginateInfo: state.paginateInfo,
    groupCount: state.groupCount,
    supportMultipleGameplan: state.supportMultipleGameplan,
    isWorkfitPractice: state.isWorkfitPractice,
    activeClientEngagement: state.activeClientEngagement,
    metricSettings: state.metricSettings, 
    clientObj: state.clientObj,      
    clientFilterSelectionList: state.clientFilterSelectionList,
    practitionerList: state.practitionerList,
    consultantList: state.consultantList,
    clientSearchPreference: state.clientSearchPreference,
  );
}


PractitionerState _homePageDetailsSuccessActionCreator(PractitionerState state,  HomePageDetailsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    unreadMessageCount: action.responseData["unread_message_count"],
    unreadChats: Utils.parseList(action.responseData, "unread_chat_list"),
    alertCount: action.responseData["alert_count"],
    menuItems: Utils.parseList(action.responseData["menu_items"], "menus"),
    metricSettings: action.responseData["metric_settings"],    
  );  
}



PractitionerState _practitionerClientsSuccessActionCreator(PractitionerState state,  PractitionerClientsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    clients: Utils.parseList(action.responseData, "clients"),
    paginateInfo: action.responseData["paginate_info"],
    groupCount: action.responseData["group_count"],
    supportMultipleGameplan: action.responseData["support_multiple_gameplan"],
    isWorkfitPractice: action.responseData["is_workfit_practice"]    
  );  
}


PractitionerState _practitionerClientHomePageSuccessActionCreator(PractitionerState state,  PractitionerClientHomePageSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    clientObj: action.clientObj
  );  
}


PractitionerState _clearPractitionerClientHomeActionCreator(PractitionerState state,  ClearPractitionerClientHomeActionCreator action) {
  return _getCopy(state).copyWith(
    clientObj: new Map(),
    activeClientEngagement: new Map(),
  );  
}

PractitionerState _practitionerGetEngagementSuccessActionCreator(PractitionerState state,  PractitionerGetEngagementSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    activeClientEngagement: action.engagement
  );  
}

PractitionerState _practitionerEngagementClearActionCreator(PractitionerState state,  PractitionerEngagementClearActionCreator action) {
  return _getCopy(state).copyWith(
    activeClientEngagement: new Map()
  );  
}


PractitionerState _practitionerClientFilterSuccessActionCreator(PractitionerState state,  PractitionerClientFilterSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    clientFilterSelectionList: state.clientFilterSelectionList,
    practitionerList: state.practitionerList,
    consultantList: state.consultantList,
    clientSearchPreference: state.clientSearchPreference,
  );  
}

PractitionerState _practitionerClientToggleVisibilitySuccessActionCreator(PractitionerState state,  PractitionerClientToggleVisibilitySuccessActionCreator action) {
  PractitionerState newState = _getCopy(state).copyWith();  
  newState.clients.removeAt(action.clientIndex);
  return newState;
}