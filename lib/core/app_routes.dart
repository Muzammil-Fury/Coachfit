import 'package:gomotive/auth/auth_routes.dart';
import 'package:gomotive/home/home_routes.dart';
import 'package:gomotive/client/client_routes.dart';
import 'package:gomotive/practitioner/practitioner_routes.dart';
import 'package:gomotive/user/user_routes.dart';
import 'package:gomotive/news/news_routes.dart';
import 'package:gomotive/message/message_routes.dart';
import 'package:gomotive/exercise/exercise_routes.dart';
import 'package:gomotive/workout/workout_routes.dart';
import 'package:gomotive/gi/gi_routes.dart';
import 'package:gomotive/conversation/conversation_routes.dart';
import 'package:gomotive/scheduler/scheduler_routes.dart';
import 'package:gomotive/education/education_routes.dart';
import 'package:gomotive/dhf/dhf_routes.dart';
import 'package:gomotive/homefit/home/home_routes.dart';
import 'package:gomotive/homefit/workout/workout_routes.dart';

var routes = authRoutes
  ..addAll(homeRoutes)
  ..addAll(practitionerRoutes)
  ..addAll(clientRoutes)
  ..addAll(userRoutes)
  ..addAll(newsRoutes)
  ..addAll(messageRoutes)
  ..addAll(exerciseRoutes)
  ..addAll(workoutRoutes)
  ..addAll(giRoutes)
  ..addAll(conversationRoutes)
  ..addAll(schedulerRoutes)
  ..addAll(educationRoutes)
  ..addAll(dhfRoutes)
  ..addAll(homefitRoutes)
  ..addAll(homefitWorkoutRoutes);