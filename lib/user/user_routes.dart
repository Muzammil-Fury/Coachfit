
import 'package:gomotive/user/views/user_change_password.dart';
import 'package:gomotive/user/views/user_edit_profile.dart';
import 'package:gomotive/user/views/user_about.dart';
import 'package:gomotive/user/views/user_support.dart';
import 'package:gomotive/user/views/user_movement_meter_settings.dart';

var userRoutes = {
  '/user/change_password': (context) => UserChangePassword(),
  '/user/edit_profile': (context) => UserEditProfile(),
  '/user/about': (context) => UserAbout(),
  '/user/support': (context) => UserSupport(),
  '/user/movement_meter_settings': (context) => UserMovementMeterSettings(),
};
