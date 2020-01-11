
import 'package:gomotive/homefit/workout/views/workouts.dart';
import 'package:gomotive/homefit/workout/views/workout_filter.dart';
import 'package:gomotive/homefit/workout/views/workouts_mobility.dart';
import 'package:gomotive/homefit/workout/views/workouts_strength.dart';
import 'package:gomotive/homefit/workout/views/workouts_metabolic.dart';
import 'package:gomotive/homefit/workout/views/workouts_power.dart';

var homefitWorkoutRoutes = {
  '/workouts': (context) => Workouts(),  
  '/workouts/filter': (context) => WorkoutFilter(),  
  '/workouts/mobility': (context) => WorkoutsMobility(),  
  '/workouts/strength': (context) => WorkoutsStrength(),  
  '/workouts/metabolic': (context) => WorkoutsMetabolic(),
  '/workouts/power': (context) => WorkoutsPower(),
};
