import 'package:redux/redux.dart';
import 'package:gomotive/client/client_actions.dart';
import 'package:gomotive/client/client_state.dart';
import 'package:gomotive/utils/utils.dart';

Reducer<ClientState> clientReducer = combineReducers([
  new TypedReducer<ClientState, HomePageDetailsSuccessActionCreator>(_homePageDetailsSuccessActionCreator),  
  new TypedReducer<ClientState, ProgramListSuccessActionCreator>(_programListSuccessActionCreator),  
  new TypedReducer<ClientState, ProgramObjectSuccessActionCreator>(_programObjectSuccessActionCreator),  
  new TypedReducer<ClientState, ProgramObjectClearActionCreator>(_programObjClearActionCreator),
  new TypedReducer<ClientState, AllWorkoutListSuccessActionCreator>(_allWorkoutListSuccessActionCreator),
  new TypedReducer<ClientState, AllWorkoutListClearActionCreator>(_allWorkoutListClearActionCreator),
  new TypedReducer<ClientState, SetSelectedWorkoutProgressionActionCreator>(_setSelectedWorkoutProgressionActionCreator),
  new TypedReducer<ClientState, WorkoutProgressionClearActionCreator>(_workoutProgressionClearActionCreator),
  new TypedReducer<ClientState, WorkoutProgressionListSuccessActionCreator>(_workoutProgressionListSuccessActionCreator),
  new TypedReducer<ClientState, ClientActiveEngagementGetSuccessActionCreator>(_clientActiveEngagementGetSuccessActionCreator),
  new TypedReducer<ClientState, IntakeFormListSuccessActionCreator>(_intakeFormListSuccessActionCreator),
  new TypedReducer<ClientState, UpdateWeeklyMovementMeterActionCreator>(_updateWeeklyMovementMeterActionCreator),
  new TypedReducer<ClientState, ProgramSuccessActionCreator>(_programSuccessActionCreator),
  new TypedReducer<ClientState, GoalTrackingDetailsSuccessActionCreator>(_goalTrackingDetailsSuccessActionCreator),
  new TypedReducer<ClientState, GoalTrackingChartDetailsSuccessActionCreator>(_goalTrackingChartDetailsSuccessActionCreator),
  new TypedReducer<ClientState, ClearGoalTrackingDetailsActionCreator>(_clearGoalTrackingDetailsActionCreator),
  new TypedReducer<ClientState, ClearGoalTrackingChartDetailsActionCreator>(_clearGoalTrackingChartDetailsActionCreator),
]);

ClientState _getCopy(ClientState state) {
  return new ClientState().copyWith( 
    menuItems: state.menuItems,
    showMovementGraph: state.showMovementGraph,
    currentWeekMovementMeters: state.currentWeekMovementMeters,
    homePageTitle: state.homePageTitle,
    hasViewedWelcomeVideo: state.hasViewedWelcomeVideo,
    welcomeVideoURL: state.welcomeVideoURL,
    workoutImageUrl: state.workoutImageUrl,
    associatedPracticeCount: state.associatedPracticeCount,
    programCount: state.programCount,
    programType: state.programType,
    programId: state.programId,
    newsList: state.newsList,
    programList: state.programList,
    programObj: state.programObj,
    programAllWorkouts: state.programAllWorkouts,
    workoutProgressionList: state.workoutProgressionList,
    selectedWorkoutProgression: state.selectedWorkoutProgression,
    practitioners: state.practitioners,
    unreadMessageCount: state.unreadMessageCount,
    unreadChatCount: state.unreadChatCount,
    intakeFormCount: state.intakeFormCount,
    goalTrackingDetails: state.goalTrackingDetails,
    goalTrackingChartDetails: state.goalTrackingChartDetails
  );
}


ClientState _homePageDetailsSuccessActionCreator(ClientState state,  HomePageDetailsSuccessActionCreator action) {
  return _getCopy(state).copyWith(
    menuItems: Utils.parseList(action.responseData["menu_items"], "menus"),
    showMovementGraph: action.responseData["show_movement_graph"],
    currentWeekMovementMeters: action.responseData["current_week_movement_points"],
    homePageTitle: action.responseData["home_page_title"],
    hasViewedWelcomeVideo: action.responseData["has_viewed_welcome_video"],
    welcomeVideoURL: action.responseData["client_welcome_video_url"],
    workoutImageUrl: action.responseData["workout_image_url"],
    associatedPracticeCount: action.responseData["associated_practice_count"],
    programCount: action.responseData["program_count"],
    programType: action.responseData["program_type"],
    programId: action.responseData["program_id"],
    newsList: Utils.parseList(action.responseData, "news_list"),
    practitioners: Utils.parseList(action.responseData, "practitioners"),
    unreadMessageCount: action.responseData["unread_message_count"],
    unreadChatCount: action.responseData["unread_chat_count"],
    intakeFormCount: action.responseData["intake_form_count"],
    intakeForms: action.responseData["intake_forms"],
  );  
}

ClientState _programListSuccessActionCreator(ClientState state,  ProgramListSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    programList: Utils.parseList(action.responseData, "program_list")
  );  
}


ClientState _programObjectSuccessActionCreator(ClientState state,  ProgramObjectSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    programObj: action.responseData["program"]
  );  
}

ClientState _programObjClearActionCreator(ClientState state,  ProgramObjectClearActionCreator action) {
  return _getCopy(state).copyWith(    
    programObj: new Map()
  );  
}

ClientState _allWorkoutListSuccessActionCreator(ClientState state,  AllWorkoutListSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    programAllWorkouts: action.responseData["program"]
  );  
}

ClientState _allWorkoutListClearActionCreator(ClientState state,  AllWorkoutListClearActionCreator action) {
  return _getCopy(state).copyWith(    
    programAllWorkouts: new Map(),
  );  
}


ClientState _setSelectedWorkoutProgressionActionCreator(ClientState state,  SetSelectedWorkoutProgressionActionCreator action) {
  return _getCopy(state).copyWith(    
    selectedWorkoutProgression: action.selectedWorkoutProgression,
  );  
}

ClientState _workoutProgressionClearActionCreator(ClientState state,  WorkoutProgressionClearActionCreator action) {
  return _getCopy(state).copyWith(    
    selectedWorkoutProgression: new Map(),
  );  
}


ClientState _workoutProgressionListSuccessActionCreator(ClientState state,  WorkoutProgressionListSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    workoutProgressionList: action.workoutProgressionList                                   
  );  
}



ClientState _clientActiveEngagementGetSuccessActionCreator(ClientState state,  ClientActiveEngagementGetSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    activeEngagements: action.engagements                                   
  );  
}


ClientState _intakeFormListSuccessActionCreator(ClientState state,  IntakeFormListSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    intakeForms: action.intakeForms                                   
  );  
}


ClientState _updateWeeklyMovementMeterActionCreator(ClientState state,  UpdateWeeklyMovementMeterActionCreator action) {
  return _getCopy(state).copyWith(    
    currentWeekMovementMeters: action.weeklyMovementMeter    
  );  
}


ClientState _programSuccessActionCreator(ClientState state,  ProgramSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    programObj: action.programObj    
  );  
}


ClientState _goalTrackingDetailsSuccessActionCreator(ClientState state,  GoalTrackingDetailsSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    goalTrackingDetails: action.goalTrackingDetails    
  );  
}


ClientState _goalTrackingChartDetailsSuccessActionCreator(ClientState state,  GoalTrackingChartDetailsSuccessActionCreator action) {
  return _getCopy(state).copyWith(    
    goalTrackingChartDetails: action.goalTrackingChartDetails        
  );  
}

ClientState _clearGoalTrackingDetailsActionCreator(ClientState state,  ClearGoalTrackingDetailsActionCreator action) {
  return _getCopy(state).copyWith(    
    programObj: new Map(),
    goalTrackingDetails: new List<Map>()       
  );  
}

ClientState _clearGoalTrackingChartDetailsActionCreator(ClientState state,  ClearGoalTrackingChartDetailsActionCreator action) {
  return _getCopy(state).copyWith(    
    goalTrackingChartDetails: new List<Map>()      
  );  
}
