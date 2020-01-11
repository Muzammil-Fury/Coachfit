
import 'package:homefit/workout/views/workouts.dart';
import 'package:homefit/workout/views/workout_filter.dart';
import 'package:homefit/workout/views/workouts_mobility.dart';
import 'package:homefit/workout/views/workouts_strength.dart';
import 'package:homefit/workout/views/workouts_metabolic.dart';
import 'package:homefit/workout/views/workouts_power.dart';

var workoutRoutes = {
  '/workouts': (context) => Workouts(),  
  '/workouts/filter': (context) => WorkoutFilter(),  
  '/workouts/mobility': (context) => WorkoutsMobility(),  
  '/workouts/strength': (context) => WorkoutsStrength(),  
  '/workouts/metabolic': (context) => WorkoutsMetabolic(),
  '/workouts/power': (context) => WorkoutsPower(),
};
