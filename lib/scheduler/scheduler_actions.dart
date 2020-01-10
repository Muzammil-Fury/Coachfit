class StudioFacilityListSuccessActionCreator {  
  final List<Map> studioFacilityList;  
  StudioFacilityListSuccessActionCreator(
    this.studioFacilityList
  );
}

class StudioFacilityBookingListSuccessActionCreator {  
  final Map studioFacilityObj;
  final List<Map> studioFacilityBookingSlots;  
  StudioFacilityBookingListSuccessActionCreator(
    this.studioFacilityObj,
    this.studioFacilityBookingSlots
  );
}


class StudioFacilityActionGetSuccessActionCreator {  
  final Map studioFacilityObj;
  final Map bookingSlot;  
  StudioFacilityActionGetSuccessActionCreator(
    this.studioFacilityObj,
    this.bookingSlot
  );
}

class ClearStudioFacilityBookingListActionCreator{
  ClearStudioFacilityBookingListActionCreator();
}


class GroupClassesListSuccessActionCreator {  
  final List<Map> groupClassesList;  
  GroupClassesListSuccessActionCreator(
    this.groupClassesList
  );
}

class GroupClassBookingListSuccessActionCreator {  
  final Map groupClassObj;
  final List<Map> groupClassBookingSlots;  
  GroupClassBookingListSuccessActionCreator(
    this.groupClassObj,
    this.groupClassBookingSlots
  );
}


class ClearGroupClassesBookingListActionCreator{
  ClearGroupClassesBookingListActionCreator();
}
