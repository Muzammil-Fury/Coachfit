import 'package:gomotive/scheduler/views/studio_facility_list.dart';
import 'package:gomotive/scheduler/views/studio_facility_booking.dart';
import 'package:gomotive/scheduler/views/group_classes_list.dart';

var schedulerRoutes = {  
  '/scheduler/studio_facility': (context) => new StudioFacilityList(),
  '/scheduler/studio_facility_booking': (context) => new StudioFacilityBooking(),
  '/scheduler/group_classes': (context) => new GroupClassesList(),
};
