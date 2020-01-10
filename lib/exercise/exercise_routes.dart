import 'package:gomotive/exercise/views/exercise_list.dart';
import 'package:gomotive/exercise/views/exercise_filter.dart';
import 'package:gomotive/exercise/views/exercise_info.dart';

var exerciseRoutes = {
	'/exercise/list': (context) => ExerciseList(),  
  '/exercise/filter': (context) => ExerciseFilter(), 
  '/exercise/info': (context) => ExerciseInfo(),  
};
