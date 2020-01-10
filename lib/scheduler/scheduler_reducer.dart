import 'package:redux/redux.dart';
import 'package:gomotive/scheduler/scheduler_actions.dart';
import 'package:gomotive/scheduler/scheduler_state.dart';

Reducer<SchedulerState> schedulerReducer = combineReducers([
  new TypedReducer<SchedulerState, StudioFacilityListSuccessActionCreator>(
    _studioFacilityListGetSuccessActionCreator
  ),  
  new TypedReducer<SchedulerState, StudioFacilityBookingListSuccessActionCreator>(
    _studioFacilityBookingListSuccessActionCreator
  ),  
  new TypedReducer<SchedulerState, StudioFacilityActionGetSuccessActionCreator>(
    _studioFacilityActionGetSuccessActionCreator
  ),  
  new TypedReducer<SchedulerState, ClearStudioFacilityBookingListActionCreator>(
    _clearStudioFacilityBookingListActionCreator
  ),  
  new TypedReducer<SchedulerState, GroupClassesListSuccessActionCreator>(
    _groupClassesListSuccessActionCreator
  ),
  new TypedReducer<SchedulerState, GroupClassBookingListSuccessActionCreator>(
    _groupClassBookingListSuccessActionCreator
  ),
  new TypedReducer<SchedulerState, ClearGroupClassesBookingListActionCreator>(
    _clearGroupClassesBookingListActionCreator
  ),
]);

SchedulerState _getCopy(SchedulerState state) {
  return new SchedulerState().copyWith(
    studioFacilityList: state.studioFacilityList,
    studioFacilityObj: state.studioFacilityObj,
    studioFacilityBookingSlots: state.studioFacilityBookingSlots,
    groupClassesList: state.groupClassesList,
  );
}


SchedulerState _studioFacilityListGetSuccessActionCreator(
  SchedulerState state, 
  StudioFacilityListSuccessActionCreator action
) {
  return _getCopy(state).copyWith(  
    studioFacilityList: action.studioFacilityList  
  );
}



SchedulerState _studioFacilityBookingListSuccessActionCreator(
  SchedulerState state, 
  StudioFacilityBookingListSuccessActionCreator action
) {
  return _getCopy(state).copyWith(  
    studioFacilityObj: action.studioFacilityObj,
    studioFacilityBookingSlots: action.studioFacilityBookingSlots,
  );
}


SchedulerState _studioFacilityActionGetSuccessActionCreator(
  SchedulerState state, 
  StudioFacilityActionGetSuccessActionCreator action
) {
  SchedulerState newState =_getCopy(state).copyWith(  
    studioFacilityObj: action.studioFacilityObj,
  );
  for(int i=0; i<newState.studioFacilityBookingSlots.length; i++) {
    if(newState.studioFacilityBookingSlots[i]["id"] == action.bookingSlot["id"]) {
      newState.studioFacilityBookingSlots[i] = action.bookingSlot;
      break;
    }
  }
  return newState;
}


SchedulerState _clearStudioFacilityBookingListActionCreator(
  SchedulerState state, 
  ClearStudioFacilityBookingListActionCreator action
) {
  return _getCopy(state).copyWith(  
    studioFacilityObj: new Map(),
    studioFacilityBookingSlots: new List<Map>(),
  );
}


SchedulerState _groupClassesListSuccessActionCreator(
  SchedulerState state, 
  GroupClassesListSuccessActionCreator action
) {
  return _getCopy(state).copyWith(  
    groupClassesList: action.groupClassesList  
  );
}

SchedulerState _groupClassBookingListSuccessActionCreator(
  SchedulerState state, 
  GroupClassBookingListSuccessActionCreator action
) {
  return _getCopy(state).copyWith(  
    groupClassObj: action.groupClassObj,
    groupClassBookingSlots: action.groupClassBookingSlots,
  );
}

SchedulerState _clearGroupClassesBookingListActionCreator(
  SchedulerState state, 
  ClearGroupClassesBookingListActionCreator action
) {
  return _getCopy(state).copyWith(  
    groupClassObj: new Map(),
    groupClassBookingSlots: new List<Map>(),
  );
}


