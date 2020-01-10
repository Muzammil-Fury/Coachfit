import 'package:gomotive/workout/views/workout_setup.dart';
import 'package:gomotive/workout/views/workout_progressions.dart';
import 'package:gomotive/workout/views/workout_progression_build.dart';
import 'package:gomotive/workout/views/workout_template_list.dart';
import 'package:gomotive/workout/views/workout_template_setup.dart';
import 'package:gomotive/workout/views/workout_template_progressions.dart';

var workoutRoutes = {
  '/workout/setup': (context) => WorkoutSetup(),
  '/workout/progressions': (context) => WorkoutProgressions(),
  '/workout/progression/build': (context) => WorkoutProgressionBuild(),
  '/workout_template/list': (context) => WorkoutTemplateList(),
  '/workout_template/setup': (context) => WorkoutTemplateSetup(),
  '/workout_template/progressions': (context) => WorkoutTemplateProgressions(),
};
