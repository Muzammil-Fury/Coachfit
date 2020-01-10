import 'package:meta/meta.dart';

@immutable
class SchedulerState {

  final List<Map> studioFacilityList;
  final Map studioFacilityObj;
  final List<Map> studioFacilityBookingSlots;
  final List<Map> groupClassesList;
  final Map groupClassObj;
  final List<Map> groupClassBookingSlots;


  const SchedulerState({
    this.studioFacilityList,
    this.studioFacilityObj,
    this.studioFacilityBookingSlots,
    this.groupClassesList,
    this.groupClassObj,
    this.groupClassBookingSlots,
  });

  SchedulerState copyWith({
    List<Map> studioFacilityList,
    Map studioFacilityObj,
    List<Map> studioFacilityBookingSlots,
    List<Map> groupClassesList,
    Map groupClassObj,
    List<Map> groupClassBookingSlots,
  }) {
    return new SchedulerState(
      studioFacilityList: studioFacilityList ?? this.studioFacilityList,
      studioFacilityObj: studioFacilityObj ?? this.studioFacilityObj,
      studioFacilityBookingSlots: studioFacilityBookingSlots ?? this.studioFacilityBookingSlots,
      groupClassesList: groupClassesList ?? this.groupClassesList,
      groupClassObj: groupClassObj ?? this.groupClassObj,
      groupClassBookingSlots: groupClassBookingSlots ?? this.groupClassBookingSlots,
    );
  }
}
