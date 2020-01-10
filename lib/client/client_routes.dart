import 'package:gomotive/client/views/client_home.dart';
import 'package:gomotive/client/views/client_scheduler.dart';
import 'package:gomotive/client/views/client_tracking.dart';
import 'package:gomotive/client/views/client_connect.dart';
import 'package:gomotive/client/views/client_profile.dart';
import 'package:gomotive/client/views/client_intake_list.dart';
import 'package:gomotive/client/views/client_tracking_movement_meter.dart';
import 'package:gomotive/client/views/client_tracking_movement_meter_add.dart';

var clientRoutes = {
	'/client/home': (context) => ClientHome(),
  '/client/scheduler': (context) => ClientScheduler(),
  '/client/tracking': (context) => ClientTracking(),
  '/client/connect': (context) => ClientConnect(),
  '/client/profile': (context) => ClientProfile(),
  '/client/intakeforms': (context) => ClientIntakeList(),
  '/client/tracking/movement_meter': (context) => ClientTrackingMovementMeter(),
  '/client/tracking/movement_meter/add': (context) => ClientTrackingMovementMeterAdd(),
};
