
import 'package:homefit/user/views/user_change_password.dart';
import 'package:homefit/user/views/user_edit_profile.dart';
import 'package:homefit/user/views/user_support.dart';
import 'package:homefit/user/views/user_movement_meter_settings.dart';
import 'package:homefit/user/views/user_profile.dart';
import 'package:homefit/user/views/user_profile_ipad.dart';
import 'package:homefit/user/views/user_activity_track.dart';

var userRoutes = {
  '/user': (context) => UserProfile(),
  '/user_ipad': (context) => UserProfileIpad(),
  '/user/change_password': (context) => UserChangePassword(),
  '/user/edit_profile': (context) => UserEditProfile(),
  '/user/support': (context) => UserSupport(),
  '/user/movement_meter_settings': (context) => UserMovementMeterSettings(),
  '/user/activity_track': (context) => UserActivityTrack(),
};
